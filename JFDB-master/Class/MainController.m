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

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [Person reCreatTableWithRandomData];
    [Person configForArraySubClass:@{
            @"products" : @"Product"
    }];
    Product *product = [[Product alloc] init];
    product.productID = @"5555";
    product.userID = @"4";
    product.name = @"茴香";

    Product *product2 = [[Product alloc] init];
    product2.productID = @"133331";
    product2.userID = @"1";
    product2.name = @"茴香";




    Person *person = [[Person alloc]init];
    person.userID = @"444444";
    person.products = @[product, product2];
    [person executeInsertDataWithProperies];



    // Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
