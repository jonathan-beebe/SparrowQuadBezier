//
//  BBCubicBezierSegment.m
//  Bezier
//
//  Created by Jon Beebe on 12/10/2.
//  Copyright 2012 Jon Beebe. All Rights Reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "BBCubicBezierSegment.h"
#import "SPPoint+toString.h"
#import "NSArray+BinarySearch.h"

#pragma mark - Interface

@interface BBCubicBezierSegment ()

@property (nonatomic, strong) NSCache *cache;

@property (nonatomic) int len;
@property (nonatomic, readwrite) float length;
@property (nonatomic, strong) NSArray *arcLengths;

@end

#pragma mark - Implementation

@implementation BBCubicBezierSegment

- (id) initWithA:(SPPoint*)a b:(SPPoint*)b c:(SPPoint*)c d:(SPPoint*)d
{
    return [self initWithA:a b:b c:c d:d resolution:200];
}

- (id) initWithA:(SPPoint*)a b:(SPPoint*)b c:(SPPoint*)c d:(SPPoint*)d resolution:(int)resolution
{
    self = [super init];
    if (self) {
        self.a = a;
        self.b = b;
        self.c = c;
        self.d = d;

        self.len = resolution;

        self.cache = [[NSCache alloc] init];

        NSMutableArray *arcLengths = [NSMutableArray arrayWithCapacity:self.len + 1];
        
        [arcLengths addObject:[NSNumber numberWithInt:0]];

        float ox = [self x:0];
        float oy = [self y:0];
        float clen = 0;
        float increment = 1.0 / self.len;
        
        for(int i = 1; i <= self.len; i += 1) {
            float x = [self x:(i * increment)];
            float y = [self y:(i * increment)];
            float dx = ox - x;
            float dy = oy - y;
            clen += sqrtf(dx * dx + dy * dy);
            [arcLengths addObject:[NSNumber numberWithFloat:clen]];
            ox = x;
            oy = y;
        }
        
        self.length = clen;

        self.arcLengths = [NSArray arrayWithArray:arcLengths];
        
    }
    return self;
}

- (float) map:(float)u
{

    NSString *cacheKey = [NSString stringWithFormat:@"map.%f", u];
    NSNumber *cached = [self.cache objectForKey:cacheKey];

    if(cached != nil) {
        return [cached floatValue];
    }

    float targetLength = u * [[self.arcLengths objectAtIndex:self.len] floatValue];

    int index = [self.arcLengths indexNearestNotGreaterThanValue:[NSNumber numberWithFloat:targetLength]];

    float lengthBefore = [[self.arcLengths objectAtIndex:index] floatValue];
    float value;
    
    if (lengthBefore == targetLength) {
        value = index / self.len;
    } else {
        value = (index + (targetLength - lengthBefore) / ([[self.arcLengths objectAtIndex:index] floatValue] + 1 - lengthBefore)) / self.len;
    }

    [self.cache setObject:[NSNumber numberWithFloat:value] forKey:cacheKey];
    return value;
}

- (float) mx:(float)u
{
    return [self x:[self map:u]];
}

- (float) my:(float)u
{
    return [self y:[self map:u]];
}

- (float) x:(float)t
{
    return ((1 - t) * (1 - t) * (1 - t)) * self.a.x
    + 3 * ((1 - t) * (1 - t)) * t * self.b.x
    + 3 * (1 - t) * (t * t) * self.c.x
    + (t * t * t) * self.d.x;
}

- (float) y:(float)t
{
    return ((1 - t) * (1 - t) * (1 - t)) * self.a.y
    + 3 * ((1 - t) * (1 - t)) * t * self.b.y
    + 3 * (1 - t) * (t * t) * self.c.y
    + (t * t * t) * self.d.y;
}

- (float) tx:(float)t
{
    return [self bezierTangent:t a:self.a.x b:self.b.x c:self.c.x d:self.d.x];
}

- (float) ty:(float)t
{
    return [self bezierTangent:t a:self.a.y b:self.b.y c:self.c.y d:self.d.y];
}

- (float) trad:(float)t
{
    return atan2f([self tx:t], -[self ty:t]);
}

- (float) tmx:(float)u
{
    return [self bezierTangent:[self map:u] a:self.a.x b:self.b.x c:self.c.x d:self.d.x];
}

- (float) tmy:(float)u
{
    return [self bezierTangent:[self map:u] a:self.a.y b:self.b.y c:self.c.y d:self.d.y];
}

- (float) tmrad:(float)u
{
    return atan2f([self tmx:u], -[self tmy:u]);
}

/**
 http://stackoverflow.com/questions/4089443/find-the-tangent-of-a-point-on-a-cubic-bezier-curve-on-an-iphone
 */
- (float) bezierTangent:(float)t a:(float)a b:(float)b c:(float)c d:(float)d
{
    // note that abcd are aka x0 x1 x2 x3

    /*  the four coefficients ..
     A = x3 - 3 * x2 + 3 * x1 - x0
     B = 3 * x2 - 6 * x1 + 3 * x0
     C = 3 * x1 - 3 * x0
     D = x0

     and then...
     Vx = 3At2 + 2Bt + C         */

    // first calcuate what are usually know as the coeffients,
    // they are trivial based on the four control points:

    float C1 = ( d - (3.0 * c) + (3.0 * b) - a );
    float C2 = ( (3.0 * c) - (6.0 * b) + (3.0 * a) );
    float C3 = ( (3.0 * b) - (3.0 * a) );
    //float C4 = ( a );  // (not needed for this calculation)

    // finally it is easy to calculate the slope element, using those coefficients:

    return ( ( 3.0 * C1 * t* t ) + ( 2.0 * C2 * t ) + C3 );

    // note that this routine works for both the x and y side;
    // simply run this routine twice, once for x once for y
    // note that there are sometimes said to be 8 (not 4) coefficients,
    // these are simply the four for x and four for y, calculated as above in each case.
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"{\n    a:%@, \n    b:%@, \n    c:%@, \n    d:%@\n}", self.a, self.b, self.c, self.d];
}

@end
