//
// Created by Jeffrey on 16/8/23.
// Copyright (c) 2016 Jeffrey. All rights reserved.
//
/**
 * 先通过runtime拿到所有属性,
 */


#import <objc/runtime.h>
#import "JFTable.h"
#import "NSObject+dataBase.h"
static const char *tableNameKey = "tableNameKey";


@implementation NSObject (dataBase)
/**利用runtime设置一个全局tableName方法(一个类对应一张表)*/
+ (void)setTableName:(NSString *)tableName {
    objc_setAssociatedObject(self, tableNameKey, tableName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
/**利用runtime获取表名(一个类对应一张表),如果之前没有设置过,则使用类名来当做表名*/
+ (NSString *)tableName {
    NSString *name = (NSString *) objc_getAssociatedObject(self, tableNameKey);
    NSString *tableName = name ? name : NSStringFromClass([self class]);
    return tableName;
}
+(void)configForTableName:(NSString *)tableName {
    [self setTableName:tableName];
}
+(NSArray *)getProperties {
    NSMutableArray *arrayProperties = [NSMutableArray array];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyNmae = property_getName(propertyList[i]);
        NSString *stringProperty = [NSString stringWithUTF8String:propertyNmae];
        [arrayProperties addObject:stringProperty];
    }
    return arrayProperties;
}
/**获取所有属性的键值对,包含多个数据*/
-(NSDictionary *)getPropertiesKeyValues {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *propertyKey = [NSString stringWithUTF8String:propertyName];
        NSString *propertyValue = [self valueForKey:propertyKey];
        dictionary[propertyKey] = propertyValue;
    }
    return dictionary;
}
/**获取主键的键值对,所以仅有一个数据*/
-(NSDictionary *)getPrimaryKeyValue {
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    const char *primaryName = property_getName(propertyList[0]);
    NSString *primaryKey = [NSString stringWithUTF8String:primaryName];
    NSString *primaryValue = [self valueForKey:primaryKey];
    NSDictionary *primaryKeyValue = @{
            primaryKey:primaryValue
    };
    return primaryKeyValue;
}

/**获取到这个类类名的表*/
+(JFTable *)createTableWithClassName {
    NSArray *properties = [self getProperties];
    NSString *tableName = [self tableName];
    JFTable *table = [JFTable tableWithName:tableName fields:properties];
    return table;
}
/**把实例里的属性当做一条数据加入到表中*/
-(void)executeInsertDataWithProperies {
    JFTable *table = [[self class] createTableWithClassName];
    NSDictionary *dataSource = [self getPropertiesKeyValues];
    [table executeInsertDataWithDataSource:dataSource];
}
/**把这个实例从数据库中删除,重复的也会删除!*/
-(void)executeDeleteDataWithProperties {
    JFTable *table = [[self class] createTableWithClassName];
    NSDictionary *deleteParam = [self getPropertiesKeyValues];
    [table executeDeleteDataWithDeleteParam:deleteParam];
}
/**把模型在数据库中对应的数据更新*/
-(void)executeUpdateDataWithProperties {
    JFTable *table = [[self class] createTableWithClassName];
    NSDictionary *dataParam = [self getPropertiesKeyValues];
    [table executeUpdateData:dataParam where:[self getPrimaryKeyValue]];
}

/**查询数据,返回数组*/
-(NSArray *)executQeueryWithProperties {
    JFTable *table = [[self class] createTableWithClassName];
    NSDictionary *queryParam = [self getPropertiesKeyValues];
    NSArray *arrayDataSoruce = [table executQeueryDataWithQueryParam:queryParam];
    NSArray *fields = [[self class] getProperties];
    /**里面是每一条数据*/
    NSMutableArray *arrayModels = [NSMutableArray array];
    for (NSDictionary *datasource in arrayDataSoruce) {
        id model = [[[self class] alloc] init];
        /**遍历每一条数据的键值对,给模型赋值*/
        for (int i = 0; i < datasource.allKeys.count; i++) {
            NSString *key = datasource.allKeys[(NSUInteger) i];
            NSString *value = datasource.allValues[(NSUInteger) i];
            [model setValue:value forKey:key];
        }
        [arrayModels addObject:model];
    }
    return arrayModels;
}

@end