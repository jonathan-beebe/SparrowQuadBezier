//
//  BBCubicBezierSegment.h
//  Bezier
//
//  Based on https://gist.github.com/670236 which came from: http://gamedev.stackexchange.com/a/5427/20365
//
//  Defines a cubic bezier curve. http://en.wikipedia.org/wiki/B%C3%A9zier_curve
//
//  All point values along the curve are found by moving from 0 to 1, where t=0 is pt a, and t=1 is pt d.
//
//  This class provides 2 methods for finding a point along the curve from 0 to 1.
//
//  The default method uses the normal bezier equations for defining points along cubic curves.
//  This method results in unevenly spaced points with distance changing depending upon the curvature of the line.
//  You can read more about it here: http://www.efg2.com/Lab/Graphics/Jean-YvesQueinecBezierCurves.htm
//
//  The second method uses an estimated arc-length, resulting in points evenly spaced across the distance of the curve.
//  Very good discussions about this method can be read here:
//      http://www.planetclegg.com/projects/WarpingTextToSplines.html
//      http://steve.hollasch.net/cgindex/curves/cbezarclen.html
//
//  Created by Jon Beebe on 12/10/2.
//  Copyright 2012 Jon Beebe. All Rights Reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>

@interface BBCubicBezierSegment : NSObject

/// The beginning point for the curve. Sometimes referred to as P0.
@property (nonatomic, strong) SPPoint *a;

/// The control point for a, defining direction of the line from a. Sometimes reffered to as P1.
@property (nonatomic, strong) SPPoint *b;

/// The control point for d, defining direction of the line towards d. Sometimes reffered to as P2.
@property (nonatomic, strong) SPPoint *c;

/// The ending point for the curve. Sometimes referred to as P3.
@property (nonatomic, strong) SPPoint *d;

/// Guestimated length of the curve, in pixels.
@property (nonatomic, readonly) float length;

- (id) initWithA:(SPPoint*)a b:(SPPoint*)b c:(SPPoint*)c d:(SPPoint*)d;

/// Init with a custom resolution for the arc-length estimation.
- (id) initWithA:(SPPoint*)a b:(SPPoint*)b c:(SPPoint*)c d:(SPPoint*)d resolution:(int)resolution;

/// Find the value of x along the curve at time t.
- (float) x:(float)t;

/// Find the value of y along the curve at time t.
- (float) y:(float)t;

/// Find the tangent angle, in radians, of the point at time t.
- (float) trad:(float)t;

/// Map a time u to a new value based on arc-length estimation.
/// Attempts to normalize time based on the length of the curve.
- (float) map:(float)u;

/// Find the value of x along the curve for time u, mapped evenly based on the curve's length.
- (float) mx:(float)u;

/// Find the value of y along the curve for time u, mapped evenly based on the curve's length.
- (float) my:(float)u;

/// Find the x value of the tangent at time t.
- (float) tx:(float)t;

/// Find the y value of the tangent at time t.
- (float) ty:(float)t;

/// Find the tangent angle of the point at time t.
- (float) trad:(float)t;

/// Find the x value of the tangent at time u, mapped evenly based on the curve's length.
- (float) tmx:(float)u;

/// Find the y value of the tangent at time u, mapped evenly based on the curve's length.
- (float) tmy:(float)u;

/// Find the tangent angle of the point at time t, mapped evenly based on the curve's length.
- (float) tmrad:(float)u;

@end
