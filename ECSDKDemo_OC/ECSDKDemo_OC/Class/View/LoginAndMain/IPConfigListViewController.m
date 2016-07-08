//
//  IPConfigListViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 16/3/9.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import "IPConfigListViewController.h"

@interface IPConfigListViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NSDictionary *curValueDic;
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation IPConfigListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"配置列表";
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UITableView *tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];;
    tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.backgroundView = [[UIView alloc] init];
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    self.tableview = tableView;
    [self.view addSubview:tableView];
}

-(void)returnClicked {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - table DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ipArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *ipInfo = [self.ipArray objectAtIndex:indexPath.row];
    static NSString* cellid = @"ipconfig_cellid";
    UITableViewCell * cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"名称:%@",ipInfo[@(0)]];
    
    return cell;
}

#pragma mark - tabl Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *selectIpConfig = [self.ipArray objectAtIndex:indexPath.row];
    self.curValueDic = selectIpConfig;
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"选择"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"使用",@"删除",nil];
    [menu setCancelButtonIndex:2];
    menu.tag = 1000;
    [menu showInView:self.view.window];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 1000 && actionSheet.cancelButtonIndex!=buttonIndex) {
        switch (buttonIndex) {
                
            case 0:
                [self.viewcontroller selectIpConfig:self.curValueDic];
                [self returnClicked];
                break;
                
            case 1:
                [self.viewcontroller deleteIpConfig:self.curValueDic[@(0)]];
                [self.ipArray removeObject:self.curValueDic];
                [self.tableview reloadData];
                break;
                
            default:
                break;
        }
    }
}

@end
