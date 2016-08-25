//
// Created by Jeffrey on 16/8/25.
// Copyright (c) 2016 Jeffrey. All rights reserved.
//

#import "Person.h"


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

+(void)reCreatTableWithRandomData {
    [Person dropTable];
    NSString *name = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"name" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *names = [name componentsSeparatedByString:@"、"];
    for (int i = 1; i <= names.count; i++) {
        Person *person = [[Person alloc] initWithRandomData];
        person.name = names[(NSUInteger) (i - 1)];
        person.userID = [NSString stringWithFormat:@"%d", i];
        [person executeInsertDataWithProperies];
    }

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

-(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to {
    NSInteger random = to - from + 1;
    return (int)(from + arc4random() % random);
}
@end