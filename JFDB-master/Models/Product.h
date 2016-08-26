//
// Created by Jeffrey on 16/8/25.
// Copyright (c) 2016 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Product : NSObject

@property(nonatomic, copy) NSString * productID;//原则上每个上级模型包含的下级模型数组里的数据应该不会有重复,这里是产品id
@property(nonatomic, copy) NSString * userID;//所属Person的id,表示属于哪个Person(厨师)
@property(nonatomic, copy) NSString * name;//产品名(菜名)
@property(nonatomic, copy) NSString * weight;//份量,大份小份中份
@property(nonatomic, copy) NSString * taste;//味道


+ (NSArray *)reCreatRandomTableWithUserID:(NSString *)userID;

- (id)initWithRandomData;
@end