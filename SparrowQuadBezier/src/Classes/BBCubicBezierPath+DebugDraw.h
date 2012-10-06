//
//  BBQuadBezierPath+DebugDraw.h
//  Bezier
//
//  Created by Jon Beebe on 12/10/1.
//
//

#import "BBCubicBezierPath.h"

@interface BBCubicBezierPath (DebugDraw)

- (SPTexture*) drawPathWidth:(float)width height:(float)height;

@end
