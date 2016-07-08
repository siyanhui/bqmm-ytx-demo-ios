//
//  GroupListViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "GroupListViewController.h"
#import "GroupListViewCell.h"
#import "ApplyJoinGroupViewController.h"
#import "CreateGroupViewController.h"

extern CGFloat NavAndBarHeight;

@implementation GroupListViewController
{
    NSMutableArray *dataSourceArray;
}
-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGFloat frameY = 0.0f;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        frameY = 64.0f;
    } else {
        frameY = 44.0f;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width,self.view.frame.size.height-frameY) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.discussArray = [NSMutableArray array];
    if (self.isDiscuss) {
        dataSourceArray = [DeviceDBHelper sharedInstance].joinDiscussArray;
    } else {
        dataSourceArray = [DeviceDBHelper sharedInstance].joinGroupArray;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_msg) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(returnClicked)];
        [leftItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (void)returnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - prepareGroupDisplay
-(void)prepareGroupDisplay{
    
    __weak __typeof(self)weakSelf = self;
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在获取列表";
    hud.removeFromSuperViewOnHide = YES;
    
    [[ECDevice sharedInstance].messageManager queryOwnGroupsWith:(weakSelf.isDiscuss?ECGroupType_Discuss:ECGroupType_Group) completion:^(ECError *error, NSArray *groups) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        
        if (error.errorCode == ECErrorType_NoError) {
            NSLog(@"groups%@",groups);
            [dataSourceArray removeAllObjects];
            [dataSourceArray addObjectsFromArray:groups];
            [strongSelf.tableView reloadData];
            [[IMMsgDBAccess sharedInstance] addGroupIDs:groups];
        } else {
            NSString* detail = error.errorDescription.length>0?[NSString stringWithFormat:@"\r描述:%@",error.errorDescription]:@"";
            [strongSelf showToast:[NSString stringWithFormat:@"错误码:%d%@",(int)error.errorCode,detail]];
        }
    }];
}

//Toast错误信息
-(void)showToast:(NSString *)message{
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0f;
}

const char KalertViewGroupMessage;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (dataSourceArray.count == 0) {
        return;
    }
    ECGroup* group = [dataSourceArray objectAtIndex:indexPath.row];
    if (_msg) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"确认发送给：" message:group.name delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        objc_setAssociatedObject(view, &KalertViewGroupMessage, group, OBJC_ASSOCIATION_RETAIN);
        [view show];
    }

    UIViewController* viewController = [[NSClassFromString(@"ChatViewController") alloc] init];
    SEL aSelector = NSSelectorFromString(@"ECDemo_setSessionId:");
    if ([viewController respondsToSelector:aSelector]) {
        IMP aIMP = [viewController methodForSelector:aSelector];
        void (*setter)(id, SEL, NSString*) = (void(*)(id, SEL, NSString*))aIMP;
        setter(viewController, aSelector,group.groupId);
    }
    [self.mainView pushViewController:viewController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ECGroup *group = (ECGroup*)objc_getAssociatedObject(alertView, &KalertViewGroupMessage);
    if (buttonIndex!=alertView.cancelButtonIndex) {
        _msg.to = group.groupId;
        _msg.sessionId = _msg.to;
        _msg.from = [DemoGlobalClass sharedInstance].userName;
        [[DeviceChatHelper sharedInstance] sendMessage:_msg];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onMesssageChanged object:_msg];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataSourceArray.count >0) {
        return dataSourceArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *GroupListViewCellid = @"GroupListViewCellidentifier";
    GroupListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupListViewCellid];
    if (cell == nil) {
        cell = [[GroupListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupListViewCellid];
    }
    
    if (dataSourceArray.count <=0) {
        return nil;
    }
    ECGroup *group = [dataSourceArray objectAtIndex:indexPath.row];
    cell.isDiscuss = self.isDiscuss;
    [cell setTableViewCellNameLabel:group.name andNumberLabel:group.groupId andIsJoin:YES andMemberNumber:group.memberCount];
    
    return cell;
}

@end
