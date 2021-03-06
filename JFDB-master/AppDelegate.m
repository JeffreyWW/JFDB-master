//
//  AppDelegate.m
//  JFDB-master
//
//  Created by Jeffrey on 16/8/24.
//  Copyright (c) 2016 Jeffrey. All rights reserved.
//主界面:展现数据,选择项:,左边按照属性名名,右边按照更改后的字段名


#import "AppDelegate.h"
#import "Person.h"


@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /**设置表名*/
    [Person configForTableName:@"personTable"];
    /**设置字段对应,如果不设置,按照属性名*/
    [Person configForPropertiesFields:@{
            @"userID": @"ID",
            @"height": @"HEIGHT",
            @"weight": @"WEIGHT",
            @"age": @"AGE",
            @"sex": @"SEX",
            @"name": @"NAME"
    }];
    /**设置数组属性和类名对应*/
    [Person configForArraySubClass:@{
            @"products" : @"Product"
    }];
    // Override point for customization after application launch.
    return YES;
}
-(void)saveDBIntoDocument {
//    NSFileManager*fileManager =[NSFileManager defaultManager];
//    NSError*error;
//    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString*documentsDirectory = paths[0];
//
//    NSString*txtPath =[documentsDirectory stringByAppendingPathComponent:@"defaultDataBase.db"];
//
//    if(![fileManager fileExistsAtPath:txtPath]){
//        NSString*resourcePath =[[NSBundle mainBundle] pathForResource:@"defaultDataBase" ofType:@"db"];
//        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
//    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end