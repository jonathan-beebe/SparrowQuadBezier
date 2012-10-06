//
//  BBCubicBezierPath.m
//  Bezier
//
//  Created by Jon Beebe on 12/10/2.
//  Copyright 2012 Jon Beebe. All Rights Reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "BBCubicBezierPath.h"
#import "SPPoint+CGPoint.h"
#import "NSArray+BinarySearch.h"

#pragma mark - Interface (private)

@interface BBCubicBezierPath ()

@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, strong) NSArray *segmentRatios;

@end

#pragma mark - Implementation

@implementation BBCubicBezierPath

- (id)init
{
    self = [super init];
    if (self) {
        self.segments = [NSMutableArray array];
        self.resolution = 200;
    }
    return self;
}

- (int) segmentCount
{
    return [self.segments count];
}

- (float) length
{
    float l = 0;
    for (BBCubicBezierSegment *seg in self.segments) {
        l += seg.length;
    }
    return l;
}

- (BBCubicBezierSegment*)segmentAtIndex:(int)index
{
    if(index < self.segmentCount) {
        return [self.segments objectAtIndex:index];
    }
    return nil;
}

- (void) addSegmentWithA:(SPPoint *)a b:(SPPoint *)b c:(SPPoint *)c d:(SPPoint *)d
{
    BBCubicBezierSegment *seg = [[BBCubicBezierSegment alloc] initWithA:a b:b c:c d:d resolution:self.resolution];

    NSMutableArray *array = [NSMutableArray arrayWithArray:self.segments];
    [array addObject:seg];
    self.segments = [NSArray arrayWithArray:array];
    
    [self updateSegmentRatios];
}

- (void) updateSegmentRatios
{
    NSMutableArray *ratios = [NSMutableArray array];

    float totalLength = self.length;
    float cummulativeLength = 0;
    
    for (BBCubicBezierSegment *seg in self.segments) {
        cummulativeLength += seg.length;
        float ratio = cummulativeLength / totalLength;
        [ratios addObject:[NSNumber numberWithFloat:ratio]];
    }

    self.segmentRatios = [NSArray arrayWithArray:ratios];
}

- (UIBezierPath*)toUIBezierPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];

    int index = 0;
    for (BBCubicBezierSegment *seg in self.segments) {

        if(index == 0) {
            [path moveToPoint:CGPointMake(seg.a.x, seg.a.y)];
        }

        [path addCurveToPoint:[seg.d toCGPoint]
                controlPoint1:[seg.b toCGPoint]
                controlPoint2:[seg.c toCGPoint]];

        index++;
    }

    return path;
}

- (float) mx:(float)u
{
    int segIndex = [self getSegmentIndexAtTime:u];
    float newT = [self scaleTime:u forSegment:segIndex];
    BBCubicBezierSegment *seg = [self.segments objectAtIndex:segIndex];
    return [seg mx:newT];
}

- (float) my:(float)u
{
    int segIndex = [self getSegmentIndexAtTime:u];
    float newT = [self scaleTime:u forSegment:segIndex];
    BBCubicBezierSegment *seg = [self.segments objectAtIndex:segIndex];
    return [seg my:newT];
}

- (float) x:(float)t
{
    int segIndex = [self getSegmentIndexAtTime:t];
    float newT = [self scaleTime:t forSegment:segIndex];
    BBCubicBezierSegment *seg = [self.segments objectAtIndex:segIndex];
    return [seg x:newT];
}

- (float) y:(float)t
{
    int segIndex = [self getSegmentIndexAtTime:t];
    float newT = [self scaleTime:t forSegment:segIndex];
    BBCubicBezierSegment *seg = [self.segments objectAtIndex:segIndex];
    return [seg y:newT];
}

- (float) trad:(float)t
{
    int segIndex = [self getSegmentIndexAtTime:t];
    float newT = [self scaleTime:t forSegment:segIndex];
    BBCubicBezierSegment *seg = [self.segments objectAtIndex:segIndex];
    return [seg trad:newT];
}

- (float) tmx:(float)u
{
    int segIndex = [self getSegmentIndexAtTime:u];
    float newT = [self scaleTime:u forSegment:segIndex];
    BBCubicBezierSegment *seg = [self.segments objectAtIndex:segIndex];
    return [seg mx:newT];
}

- (float) tmy:(float)u
{
    int segIndex = [self getSegmentIndexAtTime:u];
    float newT = [self scaleTime:u forSegment:segIndex];
    BBCubicBezierSegment *seg = [self.segments objectAtIndex:segIndex];
    return [seg my:newT];
}

- (float) tmrad:(float)u
{
    int segIndex = [self getSegmentIndexAtTime:u];
    float newT = [self scaleTime:u forSegment:segIndex];
    BBCubicBezierSegment *seg = [self.segments objectAtIndex:segIndex];
    return [seg tmrad:newT];
}

/**
 Scale a number to fit within a range, e.g. given a range from 0.3 - 0.7 and a scale of 0 - 1,
 scale all values between 0.3 and 0.7, where 0.3 -> 0, 0.7 -> 1.
 */
- (float) scale:(float)num rangeMin:(float)rMin rangeMax:(float)rMax scaleMin:(float)sMin scaleMax:(float)sMax
{
    return ( ((sMax - sMin) * (num - rMin)) / (rMax - rMin)) + sMin;
}

/**
 We treat many segments as one, allowing for us to loop over them from 0 to 1
 effectively treating them as one long line.
 Given a time t between 0 and 1, find the segment containing that time.
 */
- (int) getSegmentIndexAtTime:(float)t
{
    //NSLog(@"t %f, array %@", t, self.segmentRatios);
    NSNumber *tNum = [NSNumber numberWithFloat:t];

    for (int i = 0; i < [self.segmentRatios count]; i++) {
        NSNumber *num = [self.segmentRatios objectAtIndex:i];
        if([num compare:tNum] != NSOrderedAscending) {
            return i;
        }
    }

    return 0;
}

/**
 Given a segment in our array of segments, scale it's portion of the time to 0, 1
 e.g. this segment represents time .3 - .5.
 Therefore .3 = 0, .4 = .5, .5 = 1.0
 */
- (float) scaleTime:(float)t forSegment:(int)index
{
    float min = 0;
    float max = [[self.segmentRatios objectAtIndex:index] floatValue];

    if(index > 0) {
        min = [[self.segmentRatios objectAtIndex:(index - 1)] floatValue];
    }

    return [self scale:t rangeMin:min rangeMax:max scaleMin:0 scaleMax:1];
}


- (NSString*)description
{
    NSMutableString *segmentStrings = [NSMutableString string];

    int i = 0;
    int max = self.segmentCount;
    NSString *comma = @",";

    for (BBCubicBezierSegment *seg in self.segments) {
        [segmentStrings appendFormat:@"%@%@\n", [seg description], comma];
        i++;
        if(i == max-1) {
            comma = @"";
        }
    }
    
    return [NSString stringWithFormat:@"path :[\n%@];", segmentStrings];
}

@end
