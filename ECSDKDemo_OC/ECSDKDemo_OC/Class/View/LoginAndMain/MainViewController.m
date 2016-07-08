//
//  MainViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "MainViewController.h"
#import "SUNSlideSwitchView.h"
#import "SessionViewController.h"
#import "ContactListViewController.h"
#import "GroupListViewController.h"
#import "AppDelegate.h"
#import "ECLoginInfo.h"
#import "ECDevice.h"
#import "InviteJoinViewController.h"

NSString *const Notification_ChangeMainDisplay = @"Notification_ChangeMainDisplay";

#warning 使用 SUNSlideSwitchView 需要tableview高度减少；如果不使用，设置未0.0f即可
CGFloat NavAndBarHeight = 64.0f;

@interface MainViewController()<SUNSlideSwitchViewDelegate, SlideSwitchSubviewDelegate>

//显示的内容view
@property (nonatomic, strong) SessionViewController *sessionView;
@property (nonatomic, strong) ContactListViewController *contactView;
@property (nonatomic, strong) GroupListViewController *groupListView;
@property (nonatomic, strong) GroupListViewController *discussGroupList;
@property (nonatomic, strong) UIView *menuView;

@end

@implementation MainViewController {
    SUNSlideSwitchView *_slideSwitchView;
    BOOL notFirst;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];  //BQMM集成
    
    [self completionSyncHistory];
    
    UIBarButtonItem * rightBtn = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClicked)];
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = [UIColor redColor];
        NavAndBarHeight = 64.0f;
    } else {
        rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_add"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClicked)];
        NavAndBarHeight = 44.0f;
    }
    
    self.navigationItem.rightBarButtonItem =rightBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMainDisplaySubview:) name:Notification_ChangeMainDisplay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveHistoryMessage) name:KNOTIFICATION_haveHistoryMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completionSyncHistory) name:KNOTIFICATION_HistoryMessageCompletion object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popNameInputAlertView) name:KNOTIFICATION_needInputName object:nil];

    //滑动效果的添加
    _slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_slideSwitchView];
    _slideSwitchView.slideSwitchViewDelegate = self;
    
    _slideSwitchView.tabItemNormalColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1];
    _slideSwitchView.tabItemSelectedColor = [UIColor redColor];
    _slideSwitchView.shadowImage = [[UIImage imageNamed:@"navigation_bar_on"]
                                        stretchableImageWithLeftCapWidth:50.f topCapHeight:5.0f];
    
    self.sessionView = [[SessionViewController alloc] init];
    self.sessionView.title = @"沟通";
    self.sessionView.mainView = self;
    self.sessionView.tableView.scrollsToTop = YES;
    
    self.contactView = [[ContactListViewController alloc] init];
    self.contactView.title = @"联系人";
    self.contactView.mainView = self;
    self.contactView.tableView.scrollsToTop = YES;
    
    self.groupListView = [[GroupListViewController alloc] init];
    self.groupListView.title = @"群组";
    self.groupListView.mainView = self;
    self.groupListView.isDiscuss = NO;
    self.groupListView.tableView.scrollsToTop = YES;
    
    //讨论组
    self.discussGroupList = [[GroupListViewController alloc] init];
    _discussGroupList.title = @"讨论组";
    _discussGroupList.mainView = self;
    _discussGroupList.isDiscuss = YES;
    _discussGroupList.tableView.scrollsToTop = YES;
    
    [_slideSwitchView buildUI];
}

- (void) dealloc {
    [self ClearView];
}

-(void)haveHistoryMessage {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    NSString *title = @"收取中...";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    CGSize size = [title sizeWithFont:label.font];
    
    UIActivityIndicatorView *Activityview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    Activityview.frame = CGRectMake((self.view.frame.size.width-size.width-Activityview.frame.size.width)*0.5f-5, 22.0f-Activityview.frame.size.height*0.5f, Activityview.frame.size.width, Activityview.frame.size.height);
    label.frame = CGRectMake(Activityview.frame.origin.x+Activityview.frame.size.width+5, 22-size.height*0.5f, size.width, size.height);
    label.text = title;
    [Activityview startAnimating];
    [view addSubview:Activityview];
    [view addSubview:label];
    
    self.navigationItem.titleView = view;
    self.title = nil;
}

-(void)completionSyncHistory {
    self.title = @"云通讯IM";
    self.navigationItem.titleView = nil;
}

-(void)rightBtnClicked {
    if (self.menuView == nil) {
        
        self.menuView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClearView)];
        [self.menuView addGestureRecognizer:tap];

        NSArray *menuTitles = nil;
        if ([DemoGlobalClass sharedInstance].isSDKSupportVoIP) {
            menuTitles = @[@"语音群聊", @"实时对讲", @"视频会议", @"搜索群组", @"创建群组", @"创建讨论组", @"设置"];
        } else {
            menuTitles = @[@"搜索群组", @"创建群组", @"创建讨论组", @"设置"];
        }
        
        CGFloat menuHeight = 40.0f;
        CGFloat menuWight = 150.0f;
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(160.0f, 64.0f, menuWight, menuHeight*menuTitles.count)];
        view.tag = 50;
        view.backgroundColor = [UIColor blackColor];
        [self.menuView addSubview:view];

        for (NSString* title in menuTitles) {
            NSUInteger index = [menuTitles indexOfObject:title];
            UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            menuBtn.frame = CGRectMake(0.0f, menuHeight*index, menuWight, menuHeight);
            [menuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [menuBtn setTitle:title forState:UIControlStateNormal];
            [menuBtn addTarget:self action:@selector(menuListBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:menuBtn];
        }
    }
    
    if (self.menuView.superview == nil) {
        [self.view.window addSubview:self.menuView];
    }
}

-(void)ClearView {
    [self.menuView removeFromSuperview];
}

-(void)menuListBtnClicked:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSString * btnTitle = [button titleForState:UIControlStateNormal];
    
    if ([btnTitle isEqualToString:@"语音群聊"]) {
        
        id viewController = [[NSClassFromString(@"RoomListViewController") alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([btnTitle isEqualToString:@"实时对讲"]) {
        
        id viewController = [[NSClassFromString(@"InterphoneViewController") alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([btnTitle isEqualToString:@"搜索群组"]) {
        
        //搜索群组
        id viewController = [[NSClassFromString(@"SearchModeViewController") alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([btnTitle isEqualToString:@"创建群组"]) {
        
        //创建群组
        id viewController = [[NSClassFromString(@"CreateGroupViewController") alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([btnTitle isEqualToString:@"设置"]) {
        
        //设置
        id viewController = [[NSClassFromString(@"SettingViewController") alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([btnTitle isEqualToString:@"视频会议"]) {
        
        //视频会议
        id viewController = [[NSClassFromString(@"MultiVideoConfListViewController") alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([btnTitle isEqualToString:@"创建讨论组"]) {
        
        //创建讨论组
        InviteJoinViewController * ijvc = [[InviteJoinViewController alloc]init];
        ijvc.isDiscuss = YES;
        ijvc.isGroupCreateSuccess = NO;
        ijvc.backView = self;
        [self.navigationController pushViewController:ijvc animated:YES];
    }
    
    [self ClearView];
}

//Toast错误信息
-(void)showToast:(NSString *)message {
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

-(void)changeMainDisplaySubview:(NSNotification*)notification {
    NSInteger selectIndex = [notification.object integerValue];
    [_slideSwitchView setSelectedViewIndex:selectIndex andAnimation:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainviewdidappear" object:nil];
    [self popNameInputAlertView];
    [self.groupListView prepareGroupDisplay];
    [self.discussGroupList prepareGroupDisplay];
}

/*
 * 返回tab个数
 */
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view {
    return 4;
}

/*
 * 每个tab所属的viewController
 */
- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    if (number == 0) {
        return self.sessionView;
    } else if (number == 1) {
        return self.contactView;
    } else if (number == 2) {
        return self.groupListView;
    } else if (number == 3) {
        return self.discussGroupList;
    } else {
        return nil;
    }
}

/*
 * 点击tab
 */
- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number {
    if (number == 0) {
        self.groupListView.tableView.scrollsToTop = NO;
        self.sessionView.tableView.scrollsToTop = YES;
        self.contactView.tableView.scrollsToTop = NO;
        self.discussGroupList.tableView.scrollsToTop = NO;
        [self.sessionView prepareDisplay];
    } else if (number == 1) {
        self.groupListView.tableView.scrollsToTop = NO;
        self.sessionView.tableView.scrollsToTop = NO;
        self.contactView.tableView.scrollsToTop = YES;
        self.discussGroupList.tableView.scrollsToTop = NO;
        [self.contactView prepareDisplay];
    } else if (number == 2) {
        self.groupListView.tableView.scrollsToTop = YES;
        self.sessionView.tableView.scrollsToTop = NO;
        self.contactView.tableView.scrollsToTop = NO;
        self.discussGroupList.tableView.scrollsToTop = NO;
        [self.groupListView prepareGroupDisplay];
    } else if (number == 3) {
        self.discussGroupList.tableView.scrollsToTop = YES;
        self.groupListView.tableView.scrollsToTop = NO;
        self.sessionView.tableView.scrollsToTop = NO;
        self.contactView.tableView.scrollsToTop = NO;
        [self.discussGroupList prepareGroupDisplay];
    } else {
        
    }
}

#pragma mark - SlideSwitchSubviewDelegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:viewController animated:animated];
}

-(void)popNameInputAlertView {
    
    if ([self.navigationController.topViewController isKindOfClass:NSClassFromString(@"PersonInfoViewController")]) {
        return;
    }
    
    if ([DemoGlobalClass sharedInstance].isNeedSetData) {
        UIViewController* viewController = [[NSClassFromString(@"PersonInfoViewController") alloc] init];
        [viewController.navigationItem setHidesBackButton:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
