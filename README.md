SparrowQuadBezier
=================

Create a path from quadratic bezier segments, tween objects along the path, including easing. For the [Sparrow Framework](http://gamua.com/sparrow/)

![A car animating along 4 bezier curves in the Sparrow framework](https://raw.github.com/somethingkindawierd/SparrowQuadBezier/master/screenshot.png)

The Xcode project in this repo is based off the Sparrow AppScaffold, so it has some other files in it not directly related to the bezier paths. The files you'll most likely be interested are within the Bezier group:

*   BBQuadBezierSegment.h/m - This defines a single [quadratic bezier](http://en.wikipedia.org/wiki/B%C3%A9zier_curve#Quadratic_B.C3.A9zier_curves) curve. The most notable feature of the class is its ability to calculate any arbitrary x/y position along the cure using an estimated arc-length, resulting in animations that are smooth and utilize transitions effectively.
*   BBQuadBezierPath.h/m - This class groups a few bezier curves into one longer curve. Most likely you'll want more than one curve, and this class allows you to interact with a group of curves as if they were one. This means you can animate from 0..1 along the collection, not just one curve at a time. E.g. you can ask for any arbirary point allong the path, from 0 to 1, utilizing arc-length. This allows you to animate along any number of bezier curves, no matter how short or long each is, achieving linear animations.
*	BBQuadBezierPathTween.h/m - This is the tween class, handling the animation of x, y, and optionally the angle of your target display object.