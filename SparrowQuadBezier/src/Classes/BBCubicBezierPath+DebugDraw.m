//
//  BBQuadBezierPath+DebugDraw.m
//  Bezier
//
//  Created by Jon Beebe on 12/10/1.
//
//

#import "BBCubicBezierPath+DebugDraw.h"

@implementation BBCubicBezierPath (DebugDraw)

- (SPTexture*) drawPathWidth:(float)width height:(float)height
{

    return [[SPTexture alloc]
            initWithWidth:width height:height
            draw:^(CGContextRef context)
            {
                // Draw the stroke of the path.
                CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
                [[self toUIBezierPath] stroke];

                CGContextSetLineWidth(context, 1.0);

                for (BBCubicBezierSegment *seg in self.segments) {

                    // Draw the lines to the handles
                    [self drawLineInContext:context from:seg.a to:seg.b];
                    [self drawLineInContext:context from:seg.c to:seg.d];

                    // Draw the handles for each control point
                    [self drawDotInContext:context AtPt:seg.b];
                    [self drawDotInContext:context AtPt:seg.c];

                }

            }];
}

- (void) drawLineInContext:(CGContextRef)context from:(SPPoint*)ptA to:(SPPoint*)ptB
{
    CGContextSetRGBStrokeColor(context, 0.0, 0.5, 1.0, 1.0);
    CGContextMoveToPoint(context, ptA.x, ptA.y);
    CGContextAddLineToPoint(context, ptB.x, ptB.y);
    CGContextStrokePath(context);
}

- (void) drawDotInContext:(CGContextRef)context AtPt:(SPPoint*)pt
{
    float width = 5.0;
    float height = 5.0;

    CGRect rect = CGRectMake(pt.x - (width/2), pt.y - (height/2), width, height);

    CGContextSetRGBStrokeColor(context, 0, 0.5, 1.0, 1.0);
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.5f);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextFillEllipseInRect(context, rect);
    CGContextStrokeEllipseInRect(context, rect);
}

@end
