//
// Created by Jeffrey on 16/8/21.
// Copyright (c) 2016 Jeffrey. All rights reserved.
//自带一个database,初始化的时候指定名字,默认为share.sql,这样就不用单例了,

#import "JFTable.h"
#include <stdarg.h>

@implementation JFTable {

}
#pragma mark --- 初始化方法

- (instancetype)initWithName:(NSString *)name fields:(NSArray<NSString *> *)fields nameDatabase:(NSString *)nameDatabase {
    self = [super init];
    if (self) {
        if (name) {
            _name = name;
        } else {
            NSLog(@"表名不能为空");
        }
        _fields = fields;
        /**字段数组第一个作为主键*/
        _primaryKey = self.fields.firstObject;

        /**数据库名称(注意,不是表名),如果没有传值,则使用默认值*/
        self.nameDatabase = nameDatabase ? nameDatabase : nameDatabaseDefault;
        /**在document里创建数据库*/
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [doc stringByAppendingPathComponent:[self.nameDatabase stringByAppendingPathExtension:@"db"]];
        self.database = [FMDatabase databaseWithPath:filePath];
        /**创建最终的表*/
        [self createTable];
    }

    return self;
}

+ (instancetype)tableWithName:(NSString *)name fields:(NSArray<NSString *> *)fields nameDatabase:(NSString *)nameDatabase {
    return [[self alloc] initWithName:name fields:fields nameDatabase:nameDatabase];
}

- (instancetype)initWithName:(NSString *)name fields:(NSArray<NSString *> *)fields {
    self = [self initWithName:name fields:fields nameDatabase:nil];
    return self;
}

+ (instancetype)tableWithName:(NSString *)name fields:(NSArray<NSString *> *)fields {
    return [[self alloc] initWithName:name fields:fields];
}

#pragma mark --- 创建,以及删除当前表

/**根据字段数组以及表名,创建表,此方法不用调用,初始化table的时候会自动调用并创建表*/
- (void)createTable {
    if ([self.database open]) {
        /**转换初始化的字段数组为sql语句*/
        NSString *sqlCreatTable = [JFTable transforFieldsToSql_createTable:self.fields];
        /**得到最终的整体创建表的sql语句,结果类似
        @"CREATE TABLE IF NOT EXISTS tableName (TEXT PRIMARY KEY , name text , phoneNum text);"
         */
        NSString *sql_creatTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ %@", self.name, sqlCreatTable];
        BOOL result = [self.database executeUpdate:sql_creatTable];
        if (result) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
        [self.database close];
    } else {
        NSLog(@"数据库打开失败");
    }
}

/**删除表*/
- (void)dropTable {
    if ([self.database open]) {
        NSString *sql_dropTable = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@;", self.name];
        BOOL result = [self.database executeUpdate:sql_dropTable];
        if (result) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
        [self.database close];
    } else {
        NSLog(@"数据库打开失败");
    }
}


#pragma mark --- 数据的增删改查方法

/**添加数据*/
- (void)executeInsertDataWithDataSource:(NSDictionary *)dataSource {
    NSString *fields = [JFTable transforFieldsToSql_quote:dataSource.allKeys];
    NSMutableArray *arrayQuestion = [NSMutableArray array];
    for (int i = 0; i < dataSource.allKeys.count; i++) {
        [arrayQuestion addObject:@"?"];
    }
    NSString *question = [JFTable transforFieldsToSql_quote:arrayQuestion];

    if ([self.database open]) {
        /**sql结果类似INSERT INTO test (home ,phone ,userID ,name ,mother ) VALUES (? ,? ,? ,? ,? )*/
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ %@ VALUES %@", self.name, fields, question];

        NSArray *values = dataSource.allValues;
        BOOL result = [self.database executeUpdate:sql withArgumentsInArray:values];
        if (result) {
            NSLog(@"插入数据成功");
        } else {
            NSLog(@"插入数据失败");
        }
        [self.database close];
    } else {
        NSLog(@"数据库打开失败");
    }
}

/**删除数据*/
- (void)executeDeleteDataWithDeleteParam:(NSDictionary *)deleteParam {
    if ([self.database open]) {
        if (deleteParam) {
            NSMutableString *stringFields = [[NSMutableString alloc] init];
            for (int i = 0; i < deleteParam.allKeys.count; i++) {
                NSString *stringAnd = i == 0 ? @"" : @"AND";
                NSString *key = deleteParam.allKeys[i];
                NSString *stringField = [NSString stringWithFormat:@"%@ %@ = ? ", stringAnd, key];
                [stringFields appendString:stringField];
            }
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", self.name, stringFields];
            BOOL result = [self.database executeUpdate:sql withArgumentsInArray:deleteParam.allValues];
            if (result) {
                NSLog(@"删除数据成功");
            } else {
                NSLog(@"删除数据失败");
            }
        }
        [self.database close];
    } else {
        NSLog(@"数据库打开失败");
    }
}
/**修改数据,传入需要修改的数据dataParam和所在字段值updataParam*/
-(void)executeUpdateData:(NSDictionary *)dataParam where:(NSDictionary *)updateParam {
    if ([self.database open]) {
        NSString *stringForDataParam = [JFTable transforDictionaryToSql_comma:dataParam.allKeys] ;
        NSString *stringForUpdateParam = [JFTable transforDictionaryToSql_AND:updateParam.allKeys];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",self.name,stringForDataParam, stringForUpdateParam];
//        BOOL result = [self.database executeUpdate:sql,@"Lucy",@"American",@"0"];
        NSMutableArray *arrayValues = [NSMutableArray array];
        [arrayValues addObjectsFromArray:dataParam.allValues];
        [arrayValues addObjectsFromArray:updateParam.allValues];
//        BOOL result = [self.database executeUpdate:sql,@"Lucy",@"American",@"0"];
        BOOL result = [self.database executeUpdate:sql withArgumentsInArray:arrayValues];
        if (result) {
            NSLog(@"修改数据成功");
        } else {
            NSLog(@"修改数据失败");
        }
    } else {
        NSLog(@"数据库打开失败");
    }
}

/**查询数据,返回数组,数组里面存字典*/
- (NSArray *)executQeueryDataWithQueryParam:(NSDictionary *)queryParam {
    NSMutableArray *resultDataSoures = [NSMutableArray array];
    if ([self.database open]) {
        NSLog(@"开始查询数据......");
        NSString *sql;
        if (queryParam.count > 0) {
            /**WHERE后面的field的字符串拼接,用的是字典的所有的key加"?"*/
            NSString *stringFields = [JFTable transforDictionaryToSql_AND:queryParam.allKeys];
            /**对应字段的值是什么*/
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", self.name, stringFields];
        } else {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@", self.name];
        }
        FMResultSet *resultSet = [self.database executeQuery:sql withArgumentsInArray:queryParam.allValues];
        while ([resultSet next]) {
            NSMutableDictionary *resultDataSingle = [NSMutableDictionary dictionary];
            for (NSString *field in self.fields) {
                NSString *valueForField = [resultSet stringForColumn:field];
                resultDataSingle[field] = valueForField;
            }
            [resultDataSoures addObject:resultDataSingle];
        }
        [self.database close];
    } else {
        NSLog(@"数据库打开失败");
        resultDataSoures = nil;
    }
    NSLog(@"查询结束,返回数据是%@,总个数是%d", resultDataSoures, resultDataSoures.count);
    return resultDataSoures;
}

#pragma mark --- 一些sql语句转换

/**转换字段数组为sql语句,最终的形式类似(TEXT PRIMARY KEY , name text , phoneNum text);*/
+ (NSString *)transforFieldsToSql_createTable:(NSArray *)fields {
    NSMutableString *stringSql = [[NSMutableString alloc] initWithString:@"("];
    for (int i = 1; i <= fields.count; i++) {
        /**获取字段字符串*/
        NSString *field = fields[(NSUInteger) (i - 1)];
        /**如果是第一个字段,设置为主键,类型则都设置为TEXT类型*/
        NSString *type = i == 1 ? @"TEXT PRIMARY KEY" : @"TEXT";
        /**中间添加则为",",否则最后一个结尾的时候为");" */
        NSString *punctuation = i == fields.count ? @");" : @",";
        /**拼接sql语句,最终的形式类似(TEXT PRIMARY KEY , name text , phoneNum text); */
        NSString *sqlSingle = [NSString stringWithFormat:@"%@ %@ %@", field, type, punctuation];//例如name test
        [stringSql appendString:sqlSingle];
    }
    return stringSql;
}

/**转换字典为sql语句,主要是用来插入等,类似(name, phoneNum)*/
+ (NSString *)transforFieldsToSql_quote:(NSArray *)fields {
    NSMutableString *string = [[NSMutableString alloc] initWithString:@"("];
    for (int i = 1; i <= fields.count; i++) {
        /**获取字段字符串*/
        NSString *field = fields[(NSUInteger) (i - 1)];
        NSString *punctuation = i == fields.count ? @")" : @",";
        /**拼接sql语句,最终的形式类似(TEXT PRIMARY KEY , name text , phoneNum text); */
        NSString *sqlSingle = [NSString stringWithFormat:@"%@ %@", field, punctuation];//例如name test
        [string appendString:sqlSingle];
    }
    return string;
}

/**参数转换成制定=?格式,例如:  name = ? , home = ?,或者name = ? AND home = ?
 * 最最后一个值不会有符号
 */
+(NSString *)transforDictionaryToSql_comma:(NSArray *)params {
    return [self transforDictionaryToSql:params identify:@","];
}
+(NSString *)transforDictionaryToSql_AND:(NSArray *)params {
    return [self transforDictionaryToSql:params identify:@"AND "];
}
+(NSString *)transforDictionaryToSql:(NSArray *)params identify:(NSString *)identify{
    NSMutableString *string = [[NSMutableString alloc] init];
    for (int i = 0; i < params.count; i++) {
        NSString *key = params[(NSUInteger) i];
        NSString *comma = i == params.count - 1 ? @"" : identify;
        NSString *stringSingleParam = [NSString stringWithFormat:@"%@ = ?%@", key, comma];
        [string appendString:stringSingleParam];
    }
    return string;
}
@end
