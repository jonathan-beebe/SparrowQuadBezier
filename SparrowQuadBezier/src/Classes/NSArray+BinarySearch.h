//
//  NSArray+BinarySearch.h
//
//  Perform a binary search on the contents of an NSArray.
//  Currently this only works if the array only contains NSNumbers.
//
//  Created by Jon Beebe on 12/9/30.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (BinarySearch)

/**
 Find the index of the value closest to, but not larger than, the input value.
 */
- (int) indexNearestNotGreaterThanValue:(NSNumber*)value;

@end
