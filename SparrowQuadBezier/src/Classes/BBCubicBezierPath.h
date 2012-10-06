//
//  BBCubicBezierPath.h
//  Bezier
//
//  This class groups cubic bezier segments into a larger path. It's a rough-draft that works, but could certainly
//  be extended and improved.
//
//  Created by Jon Beebe on 12/10/2.
//  Copyright 2012 Jon Beebe. All Rights Reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>
#import "BBCubicBezierSegment.h"

@interface BBCubicBezierPath : NSObject

@property (nonatomic, strong, readonly) NSArray *segments;
@property (nonatomic, readonly) int segmentCount;
@property (nonatomic, readonly) float length;

/// The resolution of a segment's arc-length estimation.
/// If you notice your tween skipping or jumping, increase the resolution a bit.
@property (nonatomic, assign) int resolution;

- (void) addSegmentWithA:(SPPoint*)a b:(SPPoint*)b c:(SPPoint*)c d:(SPPoint*)d;
- (UIBezierPath*)toUIBezierPath;
- (BBCubicBezierSegment*)segmentAtIndex:(int)index;

- (float) mx:(float)u;
- (float) my:(float)u;
- (float) x:(float)t;
- (float) y:(float)t;
- (float) trad:(float)t;

- (float) tmx:(float)u;
- (float) tmy:(float)u;
- (float) tmrad:(float)u;

@end
