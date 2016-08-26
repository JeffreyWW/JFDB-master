//
// Created by Jeffrey on 16/8/26.
// Copyright (c) 2016 Jeffrey. All rights reserved.
//

#import "NSArray+JF.h"


@implementation NSArray (JF)
-(NSArray *)randomWithNumber:(NSUInteger)number {
    NSMutableSet *randomSet = [[NSMutableSet alloc] init];
    while ([randomSet count] < number) {
        int r = arc4random() % [self count];
        [randomSet addObject:self[(NSUInteger) r]];
    }
    NSArray *randomArray = [randomSet allObjects];
    NSLog(@"数组是%@",randomArray);
    return randomArray;
}
@end