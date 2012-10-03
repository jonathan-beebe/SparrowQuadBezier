//
//  NSArray+BinarySearch.m
//
//  Perform a binary search on the contents of an NSArray.
//
//  Created by Jon Beebe on 12/9/30.
//
//

#import "NSArray+BinarySearch.h"

@implementation NSArray (BinarySearch)

- (int) indexNearestNotGreaterThanValue:(NSNumber *)value
{
    int low = 0;
    int high = [self count] - 1;
    float index = 0;

    NSNumber *num = [[NSNumber alloc] init];
    
    while (low < high) {
        index = low + ((high - low) / 2);
        if(index < 0) { index = 0; }

        num = [self objectAtIndex:index];

        // meaning num < value
        if([num compare:value] == NSOrderedAscending) {
            low = index + 1;
        } else {
            high = index;
        }
    }

    num = [self objectAtIndex:index];

    // meaning num > value
    if(index > 0 && [num compare:value] == NSOrderedDescending) {
        index--;
    }

    return index;
}

@end
