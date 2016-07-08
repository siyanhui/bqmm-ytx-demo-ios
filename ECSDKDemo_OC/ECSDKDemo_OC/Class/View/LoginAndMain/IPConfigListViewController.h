//
//  IPConfigListViewController.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 16/3/9.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchIPViewController.h"

@interface IPConfigListViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *ipArray;
@property (nonatomic, strong) SwitchIPViewController *viewcontroller;
@end
