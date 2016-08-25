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
static const char *fieldsSubClassKey = "fieldsSubClassKey";


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
/**设置字段对应*/
+(void)configForFields:(NSDictionary *)config {
    [self setFields:config];
}

/**设置数组属性和对应的类名*/
//设置好了以后,添加数据的时候,在设置字段的时候,之前是没有设置这个字段的,现在赋值给单独是一个属性数组,存放数组属性的字段名.然后根据
//设置好以后可以直接返回的字段,拿到对应的类,通过这个类直接去查符合这个模型主键的所有的数据并且赋值给这个模型的这个字段
+(void)configForArraySubClass:(NSDictionary *)config {
    [self setFieldsSubClass:config];
}

+(void)setFieldsSubClass:(NSDictionary *)config {
    objc_setAssociatedObject(self, fieldsSubClassKey, config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(NSDictionary *)propertySubClass {
    NSDictionary *fieldsSubClass = objc_getAssociatedObject(self, fieldsSubClassKey);
    return fieldsSubClass;
}

+(void)setFields:(NSDictionary *)config {
    objc_setAssociatedObject(self, fieldsKey, config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
/**字典,键值对为属性:字段,如果之前没有设置过,则也返回字典,只是和表中的字段是一一对应的*/
+(NSDictionary *)propertiesFields {
    NSDictionary *propertiesFields = objc_getAssociatedObject(self, fieldsKey);
    unsigned int count;
    if (!propertiesFields) {
        NSMutableDictionary *m_propertiesFields = [NSMutableDictionary dictionary];
        objc_property_t *propertyList = class_copyPropertyList([self class], &count);
        for (unsigned int i = 0; i < count; i++) {
            const char *propertyName = property_getName(propertyList[i]);//属性名
            NSString *stringProperty = [NSString stringWithUTF8String:propertyName];
            m_propertiesFields[stringProperty] = stringProperty;
        }
        return m_propertiesFields;
    }

    return propertiesFields;
}
/**字典,键值对为字段:属性*/
+(NSDictionary *)fieldsProperties {
    NSDictionary *propertiesFields = [self propertiesFields];
    NSMutableDictionary *fieldsProperties = [NSMutableDictionary dictionary];
    for (NSString *property in propertiesFields.allKeys) {
        NSString *field = propertiesFields[property];
        if (field) {
            fieldsProperties[field] = property;
        }
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
        const char *propertyName = property_getName(propertyList[i]);
        const char *type = property_getAttributes(propertyList[i]);
        NSString *stringType = [NSString stringWithUTF8String:type];
        NSString *stringProperty = [NSString stringWithUTF8String:propertyName];
        NSString *typeClassName = [stringType componentsSeparatedByString:@"\""][1];
        NSString *field=nil;
        if ([typeClassName isEqualToString:@"NSString"]) {
            field = fields[stringProperty] ? fields[stringProperty] : stringProperty;
            [arrayProperties addObject:field];
        } else if ([typeClassName isEqualToString:@"NSArray"]||[typeClassName isEqualToString:@"NSMutableArray"]){
            //TODO 这里是数组属性的逻辑
        }
    }
    return arrayProperties;
}
/**获取所有属性的键值对,包含多个数据,用来查询数据,需要把数组属性去除掉*/
-(NSDictionary *)getFieldsValues {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    NSDictionary *propertiesFields = [[self class] propertiesFields];
    for (unsigned int i = 0; i < count; i++) {
//        const char *propertyName = property_getName(propertyList[i]);
//        NSString *property = [NSString stringWithUTF8String:propertyName];//获取到属性
//        NSString *field = propertiesFields[property] ? propertiesFields[property] : property;//拿到对应表中的字段,如果为空,就直接还是用属性名
//        NSString *fieldValue = [self valueForKey:property];//取这个属性的值
//        dictionary[field] = fieldValue;//设置字典,为表字段的值为模型的值

        const char *propertyName = property_getName(propertyList[i]);//属性名
        NSString *property = [NSString stringWithUTF8String:propertyName];//属性名字符串
        const char *type = property_getAttributes(propertyList[i]);//属性的类型名
        NSString *stringType = [NSString stringWithUTF8String:type];//类型名字符串,但是会有点不同
        NSString *typeClassName = [stringType componentsSeparatedByString:@"\""][1];//最终的类型名字符串

        if ([typeClassName isEqualToString:@"NSString"]) {
            NSString *field = propertiesFields[property] ? propertiesFields[property] : property;//拿到对应表中的字段,如果为空,就直接还是用属性名
            NSString *fieldValue = [self valueForKey:property];//取这个属性的值
            dictionary[field] = fieldValue;//设置字典,为表字段的值为模型的值
        } else {
            //TODO 这里是属性名不是字符串的判断逻辑
        }
    }

//    for (unsigned int i = 0; i < count; i++) {
//        const char *propertyName = property_getName(propertyList[i]);
//        const char *type = property_getAttributes(propertyList[i]);
//        NSString *stringType = [NSString stringWithUTF8String:type];
//        NSString *stringProperty = [NSString stringWithUTF8String:propertyName];
//        NSString *typeClassName = [stringType componentsSeparatedByString:@"\""][1];
//        NSString *field=nil;
//        if ([typeClassName isEqualToString:@"NSString"]) {
//            field = fields[stringProperty] ? fields[stringProperty] : stringProperty;
//            [arrayProperties addObject:field];
//        } else if ([typeClassName isEqualToString:@"NSArray"]||[typeClassName isEqualToString:@"NSMutableArray"]){
//            //TODO 这里是数组属性的逻辑
//        }
//    }


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
/**获取到主键*/
+(NSString *)primaryKey {
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    const char *primaryName = property_getName(propertyList[0]);
    NSString *primaryKey = [NSString stringWithUTF8String:primaryName];
    return primaryKey;
}
/**获取到这个类类名的表*/
+(JFTable *)createTableWithClassName {
    NSArray *fields = [self getAllFields];
    NSString *tableName = [self tableName];
    JFTable *table = [JFTable tableWithName:tableName fields:fields];
    return table;
}

/**删除表*/
+(void)dropTable {
    JFTable *table = [self createTableWithClassName];
    [table dropTable];
    NSDictionary *propertySubClass = [self propertySubClass];
    for (NSString *StrSubClass in propertySubClass.allValues) {
        Class subClass = NSClassFromString(StrSubClass);
        [subClass dropTable];
    }

}

#pragma mark --- 增删改查
/**把实例里的属性当做一条数据加入到表中*/
-(void)executeInsertDataWithProperies {
    JFTable *table = [[self class] createTableWithClassName];
    NSDictionary *dataSource = [self getFieldsValues];
    [table executeInsertDataWithDataSource:dataSource];
    NSDictionary *primaryKeyValue = [self getPrimaryKeyValue];//主键,主要用来查找次级数据数组
    NSString *primary = primaryKeyValue.allKeys.firstObject;//主键
    NSString *primartValue = primaryKeyValue.allValues.firstObject;//主键的值,用来去子表中查数组

    NSDictionary *propertySubClass = [[self class] propertySubClass];//字典,存的是属性名和关联的类名的键值对
    if (propertySubClass.allKeys.count > 0 && primaryKeyValue) {
        for (int i = 0; i < propertySubClass.allKeys.count; i++) {
            NSString *property = propertySubClass.allKeys[(NSUInteger) i];//每一个数组属性的属性名
            NSString *className = propertySubClass.allValues[(NSUInteger) i];//每一个数组属性对应的类名
            NSArray *subModels = [self valueForKey:property];
            if (subModels.count > 0) {
                for (id subModel in subModels) {
                    [subModel executeInsertDataWithProperies];
                }

            }
        }




    }


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
/**同上,但是可以指定一个模型参数*/
-(void)executeUpdateDataWithPropertiesFromTableModel:(id)tableModel {
    JFTable *table = [[self class] createTableWithClassName];
    NSDictionary *dataFromTable = [tableModel getFieldsValues];
    NSDictionary *dataFromModel = [self getFieldsValues];

    [table executeUpdateData:dataFromModel where:dataFromTable];
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
            NSDictionary *fieldsProperties = [[model class] fieldsProperties];
            NSString *field = datasource.allKeys[(NSUInteger) i];
            NSString *property = fieldsProperties[field];
            NSString *value = datasource.allValues[(NSUInteger) i];
            [model setValue:value forKey:property];
        }
        /**把每条数据从自己的表中拿到了各个字符串属性并且赋值后,还需要对其数组进行查询并返回给其数组属性*/
        NSDictionary *propertySubClass = [[self class] propertySubClass];
        for (int i = 0; i < propertySubClass.allKeys.count; i++) {
            NSString *property = propertySubClass.allKeys[(NSUInteger) i];//数组属性名
            NSString *strSubClass = propertySubClass.allValues[(NSUInteger) i];//数组里面模型类名
            Class subClass = NSClassFromString(strSubClass);//数组里面模型的类
            id subModel = [[subClass alloc] init];//声明一个次级模型,当做查询条件
            NSString *primaryKey = [[self class] primaryKey];//拿到当前模型(父级)主键
            NSString *valueForPrimaryKey = [self valueForKey:primaryKey];//拿到主键的值
            [subModel setValue:valueForPrimaryKey forKey:primaryKey];//之前定义好的,次级模型有一个属性,为上一级的主键
            NSArray *arraySubModels = [subModel executQeueryWithProperties];//次级模型去查它的表,按照字段为父级模型主键且值相同的去查,表示,属于这个上级模型的所有次级模型
            [model setValue:arraySubModels forKey:property];//把这个模型数组给数组属性赋值
        }
            [arrayModels addObject:model];//这里是外面的查询,把父级查好的自己的字符串字段和数组处理好以后,添加到最后要返回的数组里去
    }
    return arrayModels;
}

@end