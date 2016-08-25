//
// Created by Jeffrey on 16/8/23.
// Copyright (c) 2016 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (dataBase)
//TODO 需要给一个方法,传入一个字典,键值对为当前模型的数组属性名和对应的另外的一个类的类名.结果是在执行增删改查的时候,碰到这个属性,自动会按照那个模型去
//查它对应的表,最终结果可以一查多

//TODO 需要建立tableview控制器,设置增删改查的控件实现,让demo可视化

/**设置表名字,默认以类名当表名,如果先调用这个方法设置表名,则会根据设置好的表名去对应查找*/
+(void)configForTableName:(NSString *)tableName;

/**
 * 设置类的属性和表的字段关联,如果不设置,将按照类属性名和表字段一一对应
 * @param config 传入的设置,伪代码: @{ 属性名1 : 表对应字段名字1, 属性名2 : 表对应字段名字2 }
 */
+ (void)configForFields:(NSDictionary *)config;


+ (void)configForArraySubClass:(NSDictionary *)config;

+ (NSDictionary *)propertySubClass;

/**删除表,如果本类有数组属性,且有关联表,则会删除关联的子级表*/
+ (void)dropTable;

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
 * 方法1:主键没有改变的情况下,更新数据到数据库中
 * 数据变更以后调用这个方法,把更改过属性后的数据进行重新修改,内部是通过主键查询后进行修改,所以如果主键属性
 * 要变动的话,处理的时候应该在没有改变属性的情况下调用删除,然后改完属性后调用增加数据
 * 方法2:直接根据tableModel查到需要更改的数据,然后根据当前模型把查到的数据全部替换掉
 */
- (void)executeUpdateDataWithProperties;
- (void)executeUpdateDataWithPropertiesFromTableModel:(id)tableModel;

/**
 * 查
 * 根据定义好的模型的属性去查表,属性值一样的均为符合,最终会返回到数组里
 * 用法上直接把需要查的字段的值赋值,然后用这个模型调用查询方法即可,不需要查询的属性不用管,让它为空即可
 * 可以使用kvo的时候调用此方法,实时对数据库进行同步
 * return 返回符合条件的模型数组
 */
- (NSArray *)executQeueryWithProperties;
@end