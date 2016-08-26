//
// Created by Jeffrey on 16/8/25.
// Copyright (c) 2016 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFDB.h"

@interface Person : NSObject
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *height;
@property(nonatomic, copy) NSString *weight;
@property(nonatomic, copy) NSString *age;
@property(nonatomic, copy) NSString *sex;
@property(nonatomic, strong) NSArray *products;

+ (NSArray *)reCreatRandomTableWithContentNumber:(NSUInteger)contentNumber;
@end