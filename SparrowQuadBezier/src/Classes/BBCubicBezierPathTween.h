//
//  BBCubicBezierPathTween.h
//  Bezier
//
//  Created by Jon Beebe on 12/10/2.
//  Copyright 2012 Jon Beebe. All Rights Reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SPEventDispatcher.h"
#import "BBCubicBezierPath.h"

@interface BBCubicBezierPathTween : SPEventDispatcher <SPAnimatable>

/// Initializes a tween with a target, duration (in seconds) and a transition function.
/// _Designated Initializer_.
- (id)initWithTarget:(id)target path:(BBCubicBezierPath*)path time:(double)time transition:(NSString*)transition;

/// Initializes a tween with a target, a time (in seconds) and a linear transition
/// (`SP_TRANSITION_LINEAR`).
- (id)initWithTarget:(id)target path:(BBCubicBezierPath*)path time:(double)time;

/// Factory method.
+ (BBCubicBezierPathTween *)tweenWithTarget:(id)target path:(BBCubicBezierPath*)path time:(double)time transition:(NSString *)transition;

/// Factory method.
+ (BBCubicBezierPathTween *)tweenWithTarget:(id)target path:(BBCubicBezierPath*)path time:(double)time;

/// The target object that is animated.
@property (nonatomic, readonly, strong) id target;

/// The path to animate the target along
@property (nonatomic, readonly, strong) BBCubicBezierPath *path;

/// The transition method used for the animation.
@property (nonatomic, readonly, copy) NSString *transition;

/// The total time the tween will take (in seconds).
@property (nonatomic, readonly) double time;

/// The time that has passed since the tween was started (in seconds).
@property (nonatomic, readonly) double currentTime;

/// The delay before the tween is started.
@property (nonatomic, assign) double delay;

/// The type of loop. (Default: SPLoopTypeNone)
@property (nonatomic, assign) SPLoopType loop;

@property (nonatomic, assign) BOOL updateAngle;
@property (nonatomic, assign) float angleOffset;

@end
