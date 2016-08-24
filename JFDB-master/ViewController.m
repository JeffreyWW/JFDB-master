//
//  ViewController.m
//  JFDB-master
//
//  Created by Jeffrey on 16/8/24.
//  Copyright (c) 2016 Jeffrey. All rights reserved.
//


#import "ViewController.h"
#import "JFDB.h"
#import "Tdata.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置类和表关联(只需要设置一次即可,整个程序都能知道,如果不设置,默认按照表名去查或者建表)
    [Tdata configForTableName:@"T_DATA_DICTIONARY"];
    //设置类属性和表字段对应
    [Tdata configForFields:@{
            @"userID" : @"ID",
            @"key" : @"DKEY",
            @"userMemo" : @"MEMO",
            @"userUpKey" : @"UPKEY"
    }];
    //定义一个查询条件,没有给属性赋值,则表示查询全表
    Tdata *tdata = [[Tdata alloc] init];
    //查询数据
    NSArray *array = [tdata executQeueryWithProperties];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

@end