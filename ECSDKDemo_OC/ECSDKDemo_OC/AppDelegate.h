//
//  AppDelegate.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/4.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *callid;
+(AppDelegate*)shareInstance;
-(void)updateSoftAlertViewShow:(NSString*)message isForceUpdate:(BOOL)isForce;
-(void)toast:(NSString*)message;
@end

