//
// Created by Jeffrey on 16/8/23.
// Copyright (c) 2016 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (dataBase)

/**设置表名字,默认以类名当表名,如果先调用这个方法设置表名,则会根据设置好的表名去对应查找*/
+(void)configForTableName:(NSString *)tableName;

#pragma mark --- 增删该查,数据均存在以各自类名为表名的表中
/**
 * 增
 * 把模型转化成一条数据添加到数据库中
 */
- (void)executeInsertDataWithProperies;

/**
 * 删
 * 把模型从数据库中删除,注:如果有数据库中有和这条数据相同的数据(所有字段值均一样),则也会删除
 */
- (void)executeDeleteDataWithProperties;

/**
 * 改
 * 主键没有改变的情况下,更新数据到数据库中
 * 数据变更以后调用这个方法,把更改过属性后的数据进行重新修改,内部是通过主键查询后进行修改,所以如果主键属性
 * 要变动的话,处理的时候应该在没有改变属性的情况下调用删除,然后改完属性后调用增加数据
 */
- (void)executeUpdateDataWithProperties;

/**
 * 查
 * 根据定义好的模型的属性去查表,属性值一样的均为符合,最终会返回到数组里
 * 用法上直接把需要查的字段的值赋值,然后用这个模型调用查询方法即可,不需要查询的属性不用管,让它为空即可
 * 可以使用kvo的时候调用此方法,实时对数据库进行同步
 * return 返回符合条件的模型数组
 */
- (NSArray *)executQeueryWithProperties;
@end