//
//  ProductCell.h
//  JFDB-master
//
//  Created by Jeffrey on 16/8/29.
//  Copyright © 2016年 Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel *lbProductID;
@property(nonatomic,weak)IBOutlet UILabel *lbName;
@property(nonatomic,weak)IBOutlet UILabel *lbWeight;
@property(nonatomic,weak)IBOutlet UILabel *lbTaste;




@end
