//
//  MainController.m
//  JFDB-master
//
//  Created by Jeffrey on 16/8/25.
//  Copyright © 2016年 Jeffrey. All rights reserved.
//

#import "MainController.h"
#import "Person.h"
#import "Product.h"
#import "PersonCell.h"

@interface MainController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *arrayPerson;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseConfig];
    [self showAllPersonData];

    // Do any additional setup after loading the view.
}

-(void)baseConfig {
    self.title = @"数据库数据展示";
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

/**点击重置并随机生成指定条数数据,现在为10条*/
- (IBAction)clickBtRestData:(UIButton *)sender {
    [Person reCreatRandomTableWithContentNumber:3];
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
    return cell;
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
