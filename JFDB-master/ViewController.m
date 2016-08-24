//
//  ViewController.m
//  JFDB-master
//
//  Created by Jeffrey on 16/8/24.
//  Copyright (c) 2016 Jeffrey. All rights reserved.
//


#import "ViewController.h"
#import "HowToWorkController.h"
#import "JFDB.h"
#import "Tdata.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic) enum WorkType workType;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseConfig];
    [self configForTableView];
    //设置类和表关联(只需要设置一次即可,整个程序都能知道,如果不设置,默认按照表名去查或者建表)
    [Tdata configForTableName:@"T_DATA_DICTIONARY"];
    //设置类属性名和表字段对应,如不设置,默认去按照属性名去表中查相应字段
    [Tdata configForFields:@{
            @"userID" : @"ID",
            @"key" : @"DKEY",
            @"userMemo" : @"MEMO",
            @"userUpKey" : @"UPKEY"
    }];
    //定义一个查询条件,没有给属性赋值,则表示查询全表
    Tdata *tdata = [[Tdata alloc] init];
    tdata.userMemo = @"2016.0.0.1";
    //查询数据
    NSArray *array = [tdata executQeueryWithProperties];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)baseConfig {
    self.title = @"请选择功能";
}
-(void)configForTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.dataSource = @[@"添加数据", @"删除数据", @"修改数据", @"查询数据"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString *description = self.dataSource[(NSUInteger) indexPath.row];
    cell.textLabel.text = description;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            self.workType = WorkTypeAdd;
            break;
        case 1:
            self.workType = WorkTypeDelete;
            break;
        case 2:
            self.workType = WorkTypeChange;

            break;
        case 3:
            self.workType = WorkTypeCheck;
            break;
        default:
            break;
    }
    [self performSegueWithIdentifier:@"selectType" sender:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HowToWorkController *howToWorkController = segue.destinationViewController;
    howToWorkController.workType = self.workType;
}

@end