//
//  BBQuadBezierPath.h
//  Bezier
//
//  Created by Jon Beebe on 12/10/2.
//  Copyright 2012 Jon Beebe. All Rights Reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>
#import "BBQuadBezierSegment.h"

@interface BBQuadBezierPath : NSObject

@property (nonatomic, strong, readonly) NSArray *segments;
@property (nonatomic, readonly) int segmentCount;
@property (nonatomic, readonly) float length;

- (void) addSegmentWithA:(SPPoint*)a b:(SPPoint*)b c:(SPPoint*)c d:(SPPoint*)d;
- (UIBezierPath*)toUIBezierPath;
- (BBQuadBezierSegment*)segmentAtIndex:(int)index;

- (float) mx:(float)u;
- (float) my:(float)u;
- (float) x:(float)t;
- (float) y:(float)t;
- (float) trad:(float)t;

@end
