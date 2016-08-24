//
// Created by Jeffrey on 16/8/21.
// Copyright (c) 2016 Jeffrey. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <FMDB/FMDatabase.h>
/**默认database的名字*/
static NSString *nameDatabaseDefault = @"defaultDataBase";

@interface JFTable : NSObject

/**表名*/
@property(nonatomic, copy, readonly) NSString *name;
/**字段名,只读*/
@property(nonatomic, strong, readonly) NSArray <NSString *>*fields;
/**主键*/
@property(nonatomic, readonly) NSString *primaryKey;

/**自带database的名字,默认为defaultDataBase.sql,除非特殊需要,修改成其它名字,尽量不要修改,除非需要多个数据库.
 * sql操作均在这个数据库里进行,临时修改都将无法关联之前的数据,需要修改可以修改static字符串
 */
@property(nonatomic, copy) NSString *nameDatabase;
/**自带一个database,大多数的时候不需要对它进行操作*/
@property(nonatomic, strong) FMDatabase *database;

#pragma mark --- 表格的创建(初始化)以及删除当前表
/**
 * 可以理解为创建表格
 * 初始化方法,直接使用第一个和第二个方法即可,尽量不要传nameDatabase
 * @param name 表名
 * @param fields 字段名称,以数组形式给出,数组中第一个字符串即为表的主键,即primaryKey属性
 * @param nameDatabase 数据库名(不是表名,一个数据库可以包含多个表),默认为头文件的nameDatabaseDefault的值,如需要修改
 * 在头文件下面修改即可,尽量不要初始化的时候重新给值,那样的话其他功能可能会有影响
 * @return
 */
- (instancetype)initWithName:(NSString *)name fields:(NSArray<NSString *> *)fields;
+ (instancetype)tableWithName:(NSString *)name fields:(NSArray<NSString *> *)fields;
/**不推荐使用,如特殊需要,可使用*/
- (instancetype)initWithName:(NSString *)name fields:(NSArray<NSString *> *)fields nameDatabase:(NSString *)nameDatabase;
+ (instancetype)tableWithName:(NSString *)name fields:(NSArray<NSString *> *)fields nameDatabase:(NSString *)nameDatabase;

/**删除表*/
- (void)dropTable;

#pragma mark --- 增删改查,方法均以execute开头
/**
 * 增
 * 插入一条数据,数据以字典形式给出即可
 * 注意:如果插入数据主键重复,则不会插入成功
 * @param dataSource 插入的数据,键为字段名称,即fields属性里的所有字段名,值为需要赋的值
 */
- (void)executeInsertDataWithDataSource:(NSDictionary *)dataSource;

/**
 * 删
 * 删除数据,条件以字典形式给出,目前只支持交际查询,即,字典里的条件是交集限制(sql里的关键字为AND)
 * @param deleteParam 删除条件
 */
- (void)executeDeleteDataWithDeleteParam:(NSDictionary *)deleteParam;

/**
 * 改
 * 修改数据,给出目标值和需要修改的位置,进行修改
 * @param dataParam 目标值,以字典给出,里面的键值对为对应数据需要修改后的字段和值
 * @param updateParam 查询条件,以字典形式给出,里面键值对为对应字段和值,符合值的所有数据将会进行对应的修改操作,注意这里条件是合并关系,即里面多个条件满足的数据再进行修改
 */
- (void)executeUpdateData:(NSDictionary *)dataParam where:(NSDictionary *)updateParam;

/**
 * 查
 * 查询一条数据,条件以字典形式给出,和删类似
 * @param queryParam 查询条件
 * @return 返回数组,数据最终以数组形式返回,里面装的字典,键值对为对应的每条数据的键值
 */
- (NSArray *)executQeueryDataWithQueryParam:(NSDictionary *)queryParam;


@end