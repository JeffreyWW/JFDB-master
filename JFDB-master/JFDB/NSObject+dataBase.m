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
static const char *fieldsKey = "fieldKey";


@implementation NSObject (dataBase)
#pragma mark --- 表名相关方法
+(void)configForTableName:(NSString *)tableName {
    [self setTableName:tableName];
}
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

+(void)configForFields:(NSDictionary *)config {
    [self setFields:config];
}
+(void)setFields:(NSDictionary *)config {
    objc_setAssociatedObject(self, fieldsKey, config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+(NSDictionary *)propertiesFields {
    return objc_getAssociatedObject(self, fieldsKey);
}
+(NSDictionary *)fieldsProperties {
    NSDictionary *propertiesFields = [self propertiesFields];
    NSMutableDictionary *fieldsProperties = [NSMutableDictionary dictionary];
    for (NSString *property in propertiesFields.allKeys) {
        NSString *field = propertiesFields[property];
        fieldsProperties[field] = property;
    }
    return fieldsProperties;
}

/**获取到所有属性名的数组,当作字段去和表对应,如果有设置,则按照设置过的字典的values对应**/
+(NSArray *)getAllFields {
    NSMutableArray *arrayProperties = [NSMutableArray array];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    NSDictionary *fields = [self propertiesFields];
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyNmae = property_getName(propertyList[i]);
        NSString *stringProperty = [NSString stringWithUTF8String:propertyNmae];
        NSString *field = fields[stringProperty] ? fields[stringProperty] : stringProperty;
        [arrayProperties addObject:field];
    }
    return arrayProperties;
}
/**获取所有属性的键值对,包含多个数据,用来查询数据*/
-(NSDictionary *)getFieldsValues {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    NSDictionary *propertiesFields = [[self class] propertiesFields];
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *property = [NSString stringWithUTF8String:propertyName];//获取到属性
        NSString *field = propertiesFields[property];//拿到对应表中的字段
        NSString *fieldValue = [self valueForKey:property];//取这个属性的值
        dictionary[field] = fieldValue;//设置字典,为表字段的值为模型的值
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
    NSArray *properties = [self getAllFields];
    NSString *tableName = [self tableName];
    JFTable *table = [JFTable tableWithName:tableName fields:properties];
    return table;
}
/**把实例里的属性当做一条数据加入到表中*/
-(void)executeInsertDataWithProperies {
    JFTable *table = [[self class] createTableWithClassName];
    NSDictionary *dataSource = [self getFieldsValues];
    [table executeInsertDataWithDataSource:dataSource];
}
/**把这个实例从数据库中删除,重复的也会删除!*/
-(void)executeDeleteDataWithProperties {
    JFTable *table = [[self class] createTableWithClassName];
    NSDictionary *deleteParam = [self getFieldsValues];
    [table executeDeleteDataWithDeleteParam:deleteParam];
}
/**把模型在数据库中对应的数据更新*/
-(void)executeUpdateDataWithProperties {
    JFTable *table = [[self class] createTableWithClassName];
    NSDictionary *dataParam = [self getFieldsValues];
    [table executeUpdateData:dataParam where:[self getPrimaryKeyValue]];
}

/**查询数据,返回数组*/
-(NSArray *)executQeueryWithProperties {
    JFTable *table = [[self class] createTableWithClassName];
    NSDictionary *queryParam = [self getFieldsValues];
    NSArray *arrayDataSoruce = [table executQeueryDataWithQueryParam:queryParam];
    NSArray *fields = [[self class] getAllFields];
    /**里面是每一条数据*/
    NSMutableArray *arrayModels = [NSMutableArray array];
    for (NSDictionary *datasource in arrayDataSoruce) {
        id model = [[[self class] alloc] init];
        /**遍历每一条数据的键值对,给模型赋值*/
        for (int i = 0; i < datasource.allKeys.count; i++) {
            //需要根据这个key变成模型里的属性key
            NSDictionary *fieldsProperties = [[self class] fieldsProperties];
            NSString *field = datasource.allKeys[(NSUInteger) i];
            NSString *property = fieldsProperties[field];
            NSString *value = datasource.allValues[(NSUInteger) i];
            [model setValue:value forKey:property];
        }
        [arrayModels addObject:model];
    }
    return arrayModels;
}

@end