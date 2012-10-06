SparrowQuadBezier
=================

Create a path from cubic bezier segments, tween objects along the path, including easing. For the [Sparrow Framework](http://gamua.com/sparrow/)

You might be wondering why it's called SparrowQuadBezier when it should be SparrowCubicBezier. I miss-typed the curve name in the original project. Maybe I'll rename it someday, but I'm hestant since it'll break links to the url.

Notable Features
----------------

*	Animate objects along bezier curves using tweens and easing!
*	Combine many bezier curves into a single path, animating seamlessly along the entire path.
*	Automatically keep the target object's angle synced with the angle of the curve.

![A car animating along 4 bezier curves in the Sparrow framework](https://raw.github.com/somethingkindawierd/SparrowQuadBezier/master/screenshot.png)

The Xcode project in this repo is based off the Sparrow AppScaffold, so it has some other files in it not directly related to the bezier paths. The files you'll most likely be interested are within the Bezier group:

*   BBCubicBezierSegment.h/m - This defines a single [cubic bezier](http://en.wikipedia.org/wiki/B%C3%A9zier_curve#Cubic_B.C3.A9zier_curves) curve. The most notable feature of the class is its ability to calculate any arbitrary x/y position along the curve using an estimated arc-length, resulting in animations that are smooth and utilize transitions effectively.
*   BBCubicBezierPath.h/m - This class groups a few bezier curves into one longer curve. Most likely you'll want more than one curve, and this class allows you to interact with a group of curves as if they were one. This means you can animate from 0..1 along the collection, not just one curve at a time. E.g. you can ask for any arbitrary point along the path, from 0 to 1, utilizing arc-length. This allows you to animate along any number of bezier curves, no matter how short or long each is, achieving linear animations.
*	BBCubicBezierPathTween.h/m - This is the tween class, handling the animation of x, y, and optionally the angle of your target display object.

Example
-------

A path is defined from many curves, like this:

```objective-c
BBCubicBezierPath *path = [[BBCubicBezierPath alloc] init];

[path addSegmentWithA:[SPPoint pointWithX:0.0 y:0.0]
                    b:[SPPoint pointWithX:0.0 y:height / 4]
                    c:[SPPoint pointWithX:width / 4 y:height / 4]
                    d:[SPPoint pointWithX:width / 4 y:height / 4]];

[path addSegmentWithA:[SPPoint pointWithX:width / 4 y:height / 4]
                    b:[SPPoint pointWithX:width - (width / 4) y:height / 4]
                    c:[SPPoint pointWithX:width - 10 y:height - (height / 4)]
                    d:[SPPoint pointWithX:width / 2 y:height / 2]];

[path addSegmentWithA:[SPPoint pointWithX:width / 2 y:height / 2]
                    b:[SPPoint pointWithX:10 y:height / 4]
                    c:[SPPoint pointWithX:(width / 4) y:height - (height / 4)]
                    d:[SPPoint pointWithX:width - (width / 4) y:height - (height / 4)]];

[path addSegmentWithA:[SPPoint pointWithX:width - (width / 4) y:height - (height / 4)]
                    b:[SPPoint pointWithX:width - (width / 4) y:height - (height / 4)]
                    c:[SPPoint pointWithX:width y:height - (height / 4)]
                    d:[SPPoint pointWithX:width y:height]];
```

The tween is just as simple as Sparrow's SPTween class

```objective-c
BBCubicBezierPathTween *bezTween = [BBCubicBezierPathTween tweenWithTarget:targetSprite
                                                                      path:path
                                                                      time:5.0
                                                                transition:SP_TRANSITION_EASE_IN_OUT];
bezTween.loop = SPLoopTypeReverse;

[bezTween addEventListener:@selector(onTweenStarted:) atObject:self forType:SP_EVENT_TYPE_TWEEN_STARTED];

[[SPStage mainStage].juggler addObject:bezTween];
```

If you have any questions feel free to ask me on [twitter: @bejonbee](https://twitter.com/bejonbee)