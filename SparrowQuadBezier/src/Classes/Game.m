//
//  Game.m
//  AppScaffold
//

#import "Game.h"
#import "BBCubicBezierPath.h"
#import "BBCubicBezierPath+DebugDraw.h"

#import "BBCubicBezierPathTween.h"

#pragma mark - Interface (private)

@interface Game () {
    BBCubicBezierPath *activePath;
    float currentTime;
    float animationInterval;
    float animationTime;
    SPSprite *dot;

    BBCubicBezierPathTween *bezTween;
}

- (void)setup;
- (void)onResize:(SPResizeEvent *)event;

@end

#pragma mark - Implementation

@implementation Game

@synthesize gameWidth  = mGameWidth;
@synthesize gameHeight = mGameHeight;

- (id)initWithWidth:(float)width height:(float)height
{
    if ((self = [super init]))
    {
        mGameWidth = width;
        mGameHeight = height;
        
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    // release any resources here
}

- (void)setup
{
    // setup code here...

    float width = self.gameWidth;
    float height = self.gameHeight;

    BBCubicBezierPath *path = [[BBCubicBezierPath alloc] init];

    // You'll probably be able to get away with a much lower resolution, such as the default of 200.
    // This demonstrates that even very high resolutions don't have much of a performance hit, at least in
    // this small demo app. If you notice your tween skipping or jumping, increase the resolution a bit.
    
    path.resolution = 1000;

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
    
    SPTexture *cgTexture = [path drawPathWidth:width height:height];
    SPImage *cgImage = [[SPImage alloc] initWithTexture:cgTexture];
    [self addChild:cgImage atIndex:0];

    // Draw points for the path as a whole.
    int iMax = 30;
    for (int i = 0; i <= iMax; i+= 1) {
        float iFloat = ((float)i) / iMax;
//        [self drawDotsAtX:[path x:iFloat] y:[path y:iFloat]];
        [self drawDotsAtX:[path mx:iFloat] y:[path my:iFloat]];
    }



    // Create the car/dot

    SPImage *img = [SPImage imageWithContentsOfFile:@"car-top-view.png"];

    img.x = -img.width / 2;
    img.y = -img.height / 2;

    SPSprite *sprite = [[SPSprite alloc] init];
    [sprite addChild:img];
    dot = sprite;

    [self addChild:dot];
    
    // Create the tween to animate along the quad bezier path
    
    bezTween = [BBCubicBezierPathTween tweenWithTarget:dot path:path time:5.0 transition:SP_TRANSITION_EASE_IN_OUT];
    bezTween.loop = SPLoopTypeReverse;
    bezTween.angleOffset = SP_D2R(-90);

    [bezTween addEventListener:@selector(onTweenStarted:) atObject:self forType:SP_EVENT_TYPE_TWEEN_STARTED];
//    [bezTween addEventListener:@selector(onTweenUpdate:) atObject:self forType:SP_EVENT_TYPE_TWEEN_UPDATED];
    [bezTween addEventListener:@selector(onTweenCompleted:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];

    [[SPStage mainStage].juggler addObject:bezTween];

}

- (void)onTweenStarted:(SPEvent *)event
{
    NSLog(@"tween started");
}

- (void)onTweenUpdate:(SPEvent *)event
{
    NSLog(@"tween updated");
}

- (void)onTweenCompleted:(SPEvent *)event
{
    NSLog(@"tween complete");
}

- (void) drawDotsAtX:(float)x y:(float)y
{
    SPSprite *container = [self getDot];

    container.x = x;
    container.y = y;

    [self addChild:container];
}

- (SPSprite*)getDot
{
    return [self getDotSize:6.0f];
}

- (SPSprite*)getDotSize:(float)size
{

    float width = size;
    float height = size;
    float borderWidth = floorf(size / 6);
    
    SPTexture *cgTexture = [[SPTexture alloc]
                            initWithWidth:size + borderWidth height:size + borderWidth
                            draw:^(CGContextRef context)
                            {
                                CGContextSetLineWidth(context, borderWidth);
                                CGContextSetRGBStrokeColor(context, 0, 1.0f, 0, 1.0f);
                                CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.5f);
                                CGContextFillEllipseInRect(context, CGRectMake(0.5, 0.5, width - 0.5, height - 0.5));
                                CGContextStrokeEllipseInRect(context, CGRectMake(0.5, 0.5, width - 0.5, height - 0.5));
                            }];

    SPImage *cgImage = [[SPImage alloc] initWithTexture:cgTexture];
    cgImage.x = - width/2;
    cgImage.y = - height/2;

    SPSprite *container = [[SPSprite alloc] init];
    [container addChild:cgImage];

    return container;
}

- (void)onResize:(SPResizeEvent *)event
{
    NSLog(@"new size: %.0fx%.0f (%@)", event.width, event.height,
          event.isPortrait ? @"portrait" : @"landscape");
}

@end
