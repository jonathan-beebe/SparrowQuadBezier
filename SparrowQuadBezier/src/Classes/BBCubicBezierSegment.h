//
//  BBCubicBezierSegment.h
//  Bezier
//
//  Defines a bezier curve. http://en.wikipedia.org/wiki/B%C3%A9zier_curve
//
//  Created by Jon Beebe on 12/10/2.
//  Copyright 2012 Jon Beebe. All Rights Reserved.
//
//  Based on https://gist.github.com/670236 which came from: http://gamedev.stackexchange.com/a/5427/20365
//  Other useful resources:
//      http://www.planetclegg.com/projects/WarpingTextToSplines.html
//      http://steve.hollasch.net/cgindex/curves/cbezarclen.html
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>

@interface BBCubicBezierSegment : NSObject

/// The beginning point for the curve. Sometimes referred to as P0.
@property (nonatomic, strong) SPPoint *a;

/// The 
@property (nonatomic, strong) SPPoint *b;
@property (nonatomic, strong) SPPoint *c;
@property (nonatomic, strong) SPPoint *d;

@property (nonatomic, readonly) float length;

- (id) initWithA:(SPPoint*)a b:(SPPoint*)b c:(SPPoint*)c d:(SPPoint*)d;

/// Init with a custom resolution for the arc-length estimation.
- (id) initWithA:(SPPoint*)a b:(SPPoint*)b c:(SPPoint*)c d:(SPPoint*)d resolution:(int)resolution;

- (float) map:(float)u;
- (float) mx:(float)u;
- (float) my:(float)u;
- (float) x:(float)t;
- (float) y:(float)t;

- (float) tx:(float)t;
- (float) ty:(float)t;
- (float) trad:(float)t;

- (float) tmx:(float)u;
- (float) tmy:(float)u;
- (float) tmrad:(float)u;

@end
