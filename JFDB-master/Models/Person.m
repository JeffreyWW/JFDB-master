//
// Created by Jeffrey on 16/8/25.
// Copyright (c) 2016 Jeffrey. All rights reserved.
//

#import "Person.h"
#import "NSArray+JF.h"
#import "Product.h"

@implementation Person {

}
- (instancetype)initWithRandomData {
    self = [super init];
    if (self) {
        [self getRandomHeight];
        [self getRandomWeight];
        [self getRandomAge];
        [self getRandomSex];
    }
    return self;
}

/**生成Person类的随机数据,姓名根据本地的txt文件来生成,个数自定义*/
+ (NSArray *)reCreatRandomTableWithContentNumber:(NSUInteger)contentNumber {
    [Person dropTable];
    [Product dropTable];
    NSMutableArray *arrayFinal = [NSMutableArray array];
    NSString *stringUserIDsNames = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"namePerson" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *userIDsNames = [stringUserIDsNames componentsSeparatedByString:@"、"];
    NSArray *userIDNamesFinal = [userIDsNames randomWithNumber:contentNumber];
    for (int i = 1; i <= userIDNamesFinal.count; i++) {
        Person *person = [[Person alloc] initWithRandomData];
        NSString *userIDName = userIDNamesFinal[(NSUInteger) (i - 1)];
        NSArray *arrayUserIDName = [userIDName componentsSeparatedByString:@":"];
        person.userID = arrayUserIDName.firstObject;
        person.name = arrayUserIDName.lastObject;
        person.products = [Product reCreatRandomTableWithUserID:person.userID];
        [person executeInsertDataWithProperies];
        [arrayFinal addObject:person];

    }



//    for (int i = 1; i <= userIDNamesFinal.count; i++) {
//        Person *person = [[Person alloc] initWithRandomData];
//        person.name = userIDNamesFinal[(NSUInteger) (i - 1)];
//        person.userID = [NSString stringWithFormat:@"%d", i];
//        person.products = [Product reCreatRandomTableWithUserID:person.userID];
//        [person executeInsertDataWithProperies];
//        [arrayFinal addObject:person];
//    }
    return arrayFinal;
}
-(void)getRandomSex {
    NSInteger sex = [self getRandomNumber:0 to:1];
    NSString *stringSex = sex == 0 ? @"男" : @"女";
    self.sex = stringSex;
}
-(void)getRandomAge {
    NSInteger age = [self getRandomNumber:18 to:35];
    NSString *stringAge = [NSString stringWithFormat:@"%d", age];
    self.age = stringAge;
}
-(void)getRandomHeight {
    NSInteger height = [self getRandomNumber:160 to:190];
    NSString *stringHeight = [NSString stringWithFormat:@"%dCM", height];
    self.height = stringHeight;
}

-(void)getRandomWeight {
    NSInteger weight = [self getRandomNumber:55 to:80];
    NSString *stringWeight = [NSString stringWithFormat:@"%dKG", weight];
    self.weight = stringWeight;
}

-(void)getRandomProducts {
    NSArray *products = [Product reCreatRandomTableWithUserID:self.userID];
    self.products = products;
}

-(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to {
    NSInteger random = to - from + 1;
    return (int)(from + arc4random() % random);
}
@end