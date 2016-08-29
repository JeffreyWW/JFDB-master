//
//  MainController.m
//  JFDB-master
//
//  Created by Jeffrey on 16/8/25.
//  Copyright © 2016年 Jeffrey. All rights reserved.
//
//TODO 主界面还需要设置增删改查的4个按钮,对应4个页面.
/**
 * 增:弹出一个tableview,对应每个字段,并且能选择对应的数据值,product则进入到另外一个相同的界面,只是没有数组属性,添加完成会返回到当前模型这里,继续添加常规属性
 * 最后总体有个确认,添加完成返回到主界面刷新,添加过程中需要先拿到之前的表对比主键问题
 * 删:直接在当前界面做,因为常规来说,主键唯一,所以这里删除对应删除掉数据库中的这个模型即可,完成后刷新界面
 * 改:同上,只是为编辑按钮,每个字段都可以修改
 * 查:和增类似,最后返回刷新
 *
 *
 *
 */

#import "MainController.h"
#import "Person.h"
#import "Product.h"
#import "PersonCell.h"
#import "FoodController.h"

@interface MainController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *arrayPerson;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseConfig];
    /**从沙盒数据库读取数据并显示*/
    [self showAllPersonData];

    // Do any additional setup after loading the view.
}

-(void)baseConfig {
    self.title = @"厨师数据显示";
}
/**显示所有Person数据*/
-(void)showAllPersonData {
    /**定义查询条件,不给属性赋值,即为查询所有数据*/
    Person *person = [[Person alloc] init];
    /**查询得到的数组给当前数据源赋值*/
    self.arrayPerson = [person executQeueryWithProperties];
    /**刷新tableview*/
    //TODO 查询现在数据的第一个Person有点bug,有的组添加多了数据,有的则没有数据
    [self.tableView reloadData];
}

/**点击重置并随机生成指定条数数据,现在为5条*/
- (IBAction)clickBtRestData:(UIButton *)sender {
    [Person reCreatRandomTableWithContentNumber:5];
    Person *person = [[Person alloc] init];
    self.arrayPerson = [person executQeueryWithProperties];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayPerson.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Person *person = self.arrayPerson[(NSUInteger) indexPath.row];
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell"];
    cell.lbUserID.text = person.userID;
    cell.lbWeight.text = person.weight;
    cell.lbHeight.text = person.height;
    cell.lbAge.text = person.age;
    cell.lbSex.text = person.sex;
    cell.lbName.text = person.name;
    cell.showFood = ^{
        [self performSegueWithIdentifier:@"food" sender:person];
    };
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"food"]) {
        FoodController *foodController = segue.destinationViewController;
        foodController.person = sender;
    }


}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *stringCount = [NSString stringWithFormat:@"总计%d条数据", self.arrayPerson.count];
    return stringCount;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Person *person = self.arrayPerson[(NSUInteger) indexPath.row];
    NSLog(@"次级product数据有%d条", person.products.count);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
