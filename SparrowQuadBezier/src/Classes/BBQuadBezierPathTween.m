//
//  BBQuadBezierPathTween.m
//  Bezier
//
//  Created by Jon Beebe on 12/10/2.
//  Copyright 2012 Jon Beebe. All Rights Reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "BBQuadBezierPathTween.h"
#import "SPTransitions.h"
#import "SPTweenedProperty.h"

#define TRANS_SUFFIX  @":"

typedef float (*FnPtrTransition) (id, SEL, float);

#pragma mark - Interface (private)

@interface BBQuadBezierPathTween ()

@property (nonatomic, readwrite, strong) id target;
@property (nonatomic, readwrite, strong) BBQuadBezierPath *path;
@property (nonatomic, readwrite) double time;
@property (nonatomic, readwrite) double currentTime;

@property (nonatomic) SEL transitionSel;
@property (nonatomic) IMP transitionFunc;
@property (nonatomic) int loopCount;

@property (nonatomic) float tStart;
@property (nonatomic) float tCurrent;
@property (nonatomic) float tEnd;

@end

#pragma mark - Implementation

@implementation BBQuadBezierPathTween

#pragma mark - Initialization

/// Initializes a tween with a target, duration (in seconds) and a transition function.
/// _Designated Initializer_.
- (id)initWithTarget:(id)target path:(BBQuadBezierPath*)path time:(double)time transition:(NSString*)transition
{
    if ((self = [super init]))
    {
        self.target = target;
        self.time = MAX(0.0001, time); // zero is not allowed
        self.currentTime = 0;
        self.delay = 0;
        self.loop = SPLoopTypeNone;
        self.loopCount = 0;
        self.path = path;
        self.tStart = 0.0;
        self.tCurrent = 0.0;
        self.tEnd = 1.0;
        self.updateAngle = YES;

        // create function pointer for transition
        NSString *transMethod = [transition stringByAppendingString:TRANS_SUFFIX];
        self.transitionSel = NSSelectorFromString(transMethod);
        if (![SPTransitions respondsToSelector:self.transitionSel])
            [NSException raise:SP_EXC_INVALID_OPERATION
                        format:@"transition not found: '%@'", transition];
        self.transitionFunc = [SPTransitions methodForSelector:self.transitionSel];
    }
    return self;
}

/// Initializes a tween with a target, a time (in seconds) and a linear transition
/// (`SP_TRANSITION_LINEAR`).
- (id)initWithTarget:(id)target path:(BBQuadBezierPath*)path time:(double)time
{
    return [self initWithTarget:target path:path time:time transition:SP_TRANSITION_LINEAR];
}

/// Factory method.
+ (BBQuadBezierPathTween *)tweenWithTarget:(id)target path:(BBQuadBezierPath*)path time:(double)time transition:(NSString *)transition
{
    return [[BBQuadBezierPathTween alloc] initWithTarget:target path:path time:time transition:transition];
}

/// Factory method.
+ (BBQuadBezierPathTween *)tweenWithTarget:(id)target path:(BBQuadBezierPath*)path time:(double)time;
{
    return [[BBQuadBezierPathTween alloc] initWithTarget:target path:path time:time];
}

#pragma mark - SPAnimatable

/// Advance the animation by a number of seconds.
- (void)advanceTime:(double)seconds
{
    if (seconds == 0.0 || (self.loop == SPLoopTypeNone && self.currentTime == self.time))
        return; // nothing to do

    if (self.currentTime == self.time)
    {
        self.currentTime = 0.0;
        self.loopCount++;
    }

    double previousTime = self.currentTime;
    double restTime = self.time - self.currentTime;
    double carryOverTime = seconds > restTime ? seconds - restTime : 0.0;
    self.currentTime = MIN(self.time, self.currentTime + seconds);

    if (self.currentTime <= 0) return; // the delay is not over yet

    if (previousTime <= 0 && self.currentTime > 0 && self.loopCount == 0 &&
        [self hasEventListenerForType:SP_EVENT_TYPE_TWEEN_STARTED])
    {
        SPEvent *event = [[SPEvent alloc] initWithType:SP_EVENT_TYPE_TWEEN_STARTED];
        [self dispatchEvent:event];
    }

    float ratio = self.currentTime / self.time;
    FnPtrTransition transFunc = (FnPtrTransition) self.transitionFunc;
    Class transClass = [SPTransitions class];
    BOOL mInvertTransition = (self.loop == SPLoopTypeReverse && self.loopCount % 2 == 1);

    if (previousTime <= 0 && self.currentTime > 0) {
        self.tStart = self.tCurrent;
    }

    float transitionValue = mInvertTransition ?
    1.0f - transFunc(transClass, self.transitionSel, 1.0f - ratio) :
    transFunc(transClass, self.transitionSel, ratio);
    
    // This should always be 1
    float tDelta = self.tEnd - self.tStart;
    
    self.tCurrent = self.tStart + tDelta * transitionValue;

    // Get the mx and my for the current value of t

    float mx = [self.path mx:self.tCurrent];
    float my = [self.path my:self.tCurrent];

    // Set the x & y property of our target.
    [self.target setValue:[NSNumber numberWithFloat:mx] forKey:@"x"];
    [self.target setValue:[NSNumber numberWithFloat:my] forKey:@"y"];

    if(self.updateAngle == YES) {
        float trad = [self.path trad:self.tCurrent];
        [self.target setValue:[NSNumber numberWithFloat:trad] forKey:@"rotation"];
    }

    if ([self hasEventListenerForType:SP_EVENT_TYPE_TWEEN_UPDATED])
    {
        SPEvent *event = [[SPEvent alloc] initWithType:SP_EVENT_TYPE_TWEEN_UPDATED];
        [self dispatchEvent:event];
    }

    if (previousTime < self.time && self.currentTime == self.time)
    {
		if (self.loop == SPLoopTypeRepeat)
		{
            self.tCurrent = self.tStart;
		}
		else if (self.loop == SPLoopTypeReverse)
		{
            self.tCurrent = self.tEnd; // since tweens not necessarily end with endValue
            self.tEnd = self.tStart;
		}

        if ([self hasEventListenerForType:SP_EVENT_TYPE_TWEEN_COMPLETED])
        {
            SPEvent *event = [[SPEvent alloc] initWithType:SP_EVENT_TYPE_TWEEN_COMPLETED];
            [self dispatchEvent:event];
        }
    }

    [self advanceTime:carryOverTime];
    
}

- (void)setDelay:(double)delay
{
    self.currentTime = self.currentTime + self.delay - delay;
    _delay = delay;
}

- (NSString*)transition
{
    NSString *selectorName = NSStringFromSelector(self.transitionSel);
    return [selectorName substringToIndex:selectorName.length - [TRANS_SUFFIX length]];
}

- (BOOL)isComplete
{
    return self.currentTime >= self.time && self.loop == SPLoopTypeNone;
}

@end
