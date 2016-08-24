//
//  HowToWorkController.m
//  JFDB-master
//
//  Created by Jeffrey on 16/8/24.
//  Copyright © 2016年 Jeffrey. All rights reserved.
//

#import "HowToWorkController.h"

@interface HowToWorkController ()

@end

@implementation HowToWorkController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseConfig];
    // Do any additional setup after loading the view.
}

-(void)baseConfig {
    switch (self.workType) {
        case WorkTypeAdd:
        {
            self.title = @"增加数据";
        }
            break;
        case WorkTypeDelete:
        {
            self.title = @"删除数据";
        }
            break;
        case WorkTypeChange:
        {
            self.title = @"修改数据";
        }
            break;
        case WorkTypeCheck:
        {
            self.title = @"查询数据";
        }
            break;
    }

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
