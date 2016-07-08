//
//  AboutViewController.m
//  ECSDKDemo_OC
//
//  Created by admin on 16/3/9.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"关于";
    
    UIBarButtonItem *item;
    if ([UIDevice currentDevice].systemVersion.integerValue>7.0) {
        self.edgesForExtendedLayout = UIRectEdgeTop;
        item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick)];
    } else {
        item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick)];
    }
    self.navigationItem.leftBarButtonItem = item;
    
    [self buildUI];
}

- (void)buildUI {
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-80.0f)/2, 74.0f, 80.0f, 80.0f);
    [imageBtn setImage:[UIImage imageNamed:@"im_img4.png"] forState:UIControlStateNormal];
    [self.view addSubview:imageBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, CGRectGetMaxY(imageBtn.frame), [UIScreen mainScreen].bounds.size.width-80.0f*2, 60.0f)];
    label.text = @"给开发者做的平台 功能全 技术强 集成快";
    label.font = [UIFont systemFontOfSize:14.0f];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *dowloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dowloadBtn.frame =CGRectMake(20.0f, CGRectGetMaxY(label.frame)+40.0f, 280.0f, 50.0f);
    [dowloadBtn setBackgroundImage:[UIImage imageNamed:@"select_account_button"] forState:UIControlStateNormal];
    [dowloadBtn setTitle:@"网页下载" forState:UIControlStateNormal];
    [dowloadBtn addTarget:self action:@selector(dowloadBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dowloadBtn];
}

- (void)dowloadBtnClicked {
    id viewController = [[NSClassFromString(@"DownloadViewController") alloc] init];
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)returnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
