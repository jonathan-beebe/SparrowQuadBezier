//
//  SPPoint+CGPoint.m
//  Bezier
//
//  Created by Jon Beebe on 12/9/30.
//
//

#import "SPPoint+CGPoint.h"

@implementation SPPoint (CGPoint)

- (CGPoint) toCGPoint
{
    return CGPointMake(self.x, self.y);
}

@end
