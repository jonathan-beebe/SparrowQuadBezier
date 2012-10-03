//
//  SPPoint+toString.m
//  Bezier
//
//  Created by Jon Beebe on 12/9/30.
//
//

#import "SPPoint+toString.h"

@implementation SPPoint (toString)

- (NSString*)description
{
    return [NSString stringWithFormat:@"{x:%f, y:%f}", self.x, self.y];
}

@end
