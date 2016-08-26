//
//  PersonCell.h
//  JFDB-master
//
//  Created by Jeffrey on 16/8/26.
//  Copyright © 2016年 Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *lbUserID;
@property(nonatomic,weak)IBOutlet UILabel *lbName;
@property(nonatomic,weak)IBOutlet UILabel *lbHeight;
@property(nonatomic,weak)IBOutlet UILabel *lbWeight;
@property(nonatomic,weak)IBOutlet UILabel *lbAge;
@property(nonatomic,weak)IBOutlet UILabel *lbSex;
@property(nonatomic,weak)IBOutlet UIButton *btProduct;
@end
