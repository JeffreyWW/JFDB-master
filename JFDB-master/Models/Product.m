//
// Created by Jeffrey on 16/8/25.
// Copyright (c) 2016 Jeffrey. All rights reserved.
//

#import "Product.h"
#import "JFDB.h"
#import "NSArray+JF.h"


@implementation Product {

}

/**生成Person类的随机数据,姓名根据本地的txt文件来生成,个数自定义*/
+ (NSArray *)reCreatRandomTableWithUserID:(NSString *)userID {
//    [Product dropTable];
//    NSMutableArray *arrayFinal = [NSMutableArray array];
//    NSString *name = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nameProduct" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
//    NSArray *names = [name componentsSeparatedByString:@"、"];
//    NSUInteger contentNumber = arc4random() % 11;;//获取1到10之间的随机数当做数组个数
//    NSArray *namesFinal = [names randomWithNumber:contentNumber];
//    for (int i = 1; i <= namesFinal.count; i++) {
//        Product *product = [[Product alloc] initWithRandomData];
//        product.name = namesFinal[(NSUInteger) (i - 1)];
//        product.productID = [NSString stringWithFormat:@"%d", i];
//        product.userID = userID;
//        [arrayFinal addObject:product];
//        [product executeInsertDataWithProperies];
//    }
    NSMutableArray *arrayFinal = [NSMutableArray array];
    NSString *stringUserIDsNames = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nameProduct" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *userIDsNames = [stringUserIDsNames componentsSeparatedByString:@"、"];
    NSUInteger contentNumber = arc4random() % 11;;//获取1到10之间的随机数当做数组个数
    NSArray *userIDNamesFinal = [userIDsNames randomWithNumber:contentNumber];
    for (int i = 1; i <= userIDNamesFinal.count; i++) {
        Product *product = [[Product alloc] initWithRandomData];
        NSString *userIDName = userIDNamesFinal[(NSUInteger) (i - 1)];
        NSArray *arrayUserIDName = [userIDName componentsSeparatedByString:@":"];
        product.productID = arrayUserIDName.firstObject;
        product.name = arrayUserIDName.lastObject;
        product.userID = userID;
//        [product executeInsertDataWithProperies];
        [arrayFinal addObject:product];

    }
    return arrayFinal;
}

- (instancetype)initWithRandomData {
    self = [super init];
    if (self) {
        [self getRandomTaste];//获取随机味道
        [self getRandomWeight];//获取随机份量
    }
    return self;
}

-(void)getRandomTaste {
    NSInteger taste = [self getRandomNumber:0 to:2];
    switch (taste) {
        case 0:
            self.taste = @"尼玛太难吃了";
            break;
        case 1:
            self.taste = @"一般般,继续努力";
            break;
        case 2:
            self.taste = @"味道好极了";
        default:
            break;
    }
}
-(void)getRandomWeight {
    NSInteger weight = [self getRandomNumber:0 to:3];
    switch (weight) {
        case 0:
            self.weight = @"小份";
            break;
        case 1:
            self.weight = @"中份";
            break;
        case 2:
            self.weight = @"大份";
            break;
        case 3:
            self.weight = @"超大份";
        default:
            break;
    }
}

-(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to {
    NSInteger random = to - from + 1;
    return (int)(from + arc4random() % random);
}
@end