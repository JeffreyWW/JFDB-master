//
//  HowToWorkController.h
//  JFDB-master
//
//  Created by Jeffrey on 16/8/24.
//  Copyright © 2016年 Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WorkType) {
    WorkTypeAdd,
    WorkTypeDelete,
    WorkTypeChange,
    WorkTypeCheck,
};


@interface HowToWorkController : UIViewController
@property(nonatomic,assign) WorkType workType;
@end
