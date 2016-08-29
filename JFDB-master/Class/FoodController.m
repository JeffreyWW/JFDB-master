//
//  FoodController.m
//  JFDB-master
//
//  Created by Jeffrey on 16/8/29.
//  Copyright © 2016年 Jeffrey. All rights reserved.
//

#import "FoodController.h"
#import "ProductCell.h"
#import "Product.h"

@interface FoodController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak) IBOutlet UITableView *tableView;

@end

@implementation FoodController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseConfig];
    // Do any additional setup after loading the view.
}
-(void)baseConfig {
    self.title = @"食物数据显示";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.person.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Product *product = self.person.products[(NSUInteger) indexPath.row];
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell"];
    cell.lbProductID.text = product.productID;
    cell.lbName.text = product.name;
    cell.lbTaste.text = product.taste;
    cell.lbWeight.text = product.weight;
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
