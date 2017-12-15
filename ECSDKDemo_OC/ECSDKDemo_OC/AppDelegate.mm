//
//  AppDelegate.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/4.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "AppDelegate.h"
#import "ECDeviceHeaders.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "AddressBookManager.h"
#import "CustomEmojiView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"

//BQMM集成
#import <BQMM/BQMM.h>

#import <Bugly/Bugly.h>
#define LOG_OPEN 0

@interface AppDelegate ()
@property (nonatomic, strong) LoginViewController *loginView;
@property (nonatomic, strong) MainViewController *mainView;
@property (nonatomic, strong) NSDateFormatter *dataformater;
@end

@implementation AppDelegate

- (void)redirectNSLogToDocumentFolder {
    
#if LOG_OPEN
    if(isatty(STDOUT_FILENO)){
        return;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    if([[device model] hasSuffix:@"Simulator"]){ //在模拟器不保存到文件中
        return;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"%@.log", [self.dataformater stringFromDate:[NSDate date]]];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
#endif

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [CustomEmojiView shardInstance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
#if !TARGET_IPHONE_SIMULATOR
    self.dataformater = [[NSDateFormatter alloc] init];
    [self.dataformater setDateFormat:@"yyyyMMddHH"];

    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.title = @"查看消息";
        action.identifier = @"action1";
        action.activationMode = UIUserNotificationActivationModeForeground;
        
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier = @"alert";
        [category setActions:@[action] forContext:UIUserNotificationActionContextDefault];

        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:[NSSet setWithObjects:category, nil]];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
#endif
    
    [self redirectNSLogToDocumentFolder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectStateChanged:) name:KNOTIFICATION_onConnected object:nil];
  
    #warning 设置代理
    [ECDevice sharedInstance].delegate = [DeviceDelegateHelper sharedInstance];
    
    [self shareSDK];
    UINavigationController * rootView = nil;
    //是否有登录信息
    [DemoGlobalClass sharedInstance].isAutoLogin = [self getLoginInfo];
    if ([DemoGlobalClass sharedInstance].isAutoLogin) {
        
        //打开本地数据库
        [[DeviceDBHelper sharedInstance] openDataBasePath:[DemoGlobalClass sharedInstance].userName];
        self.mainView = [[MainViewController alloc] init];
        rootView = [[UINavigationController alloc] initWithRootViewController:_mainView];
    } else {
        
        self.loginView = [[LoginViewController alloc] init];
        rootView = [[UINavigationController alloc] initWithRootViewController:_loginView];
    }
    
    //BQMM集成  初始化BQMM
    NSString *appId = @"a5a8ae16d6734c0190d3c7d73605ea11";
    NSString *appSecret = @"54945f511d2d44a8985ee71b92b24afa";
    [[MMEmotionCentre defaultCentre] setAppId:appId secret:appSecret];
    
    [MMEmotionCentre defaultCentre].sdkMode = MMSDKModeIM;
    [MMEmotionCentre defaultCentre].sdkLanguage = MMLanguageChinese;
    [MMEmotionCentre defaultCentre].sdkRegion = MMRegionOther;
    
    //初始化bugly
    [Bugly startWithAppId:@"d8a40c96a3"];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.window.rootViewController = rootView;
    
    [self.window makeKeyAndVisible];
    
    NSLog(@"测试 application didFinishLaunchingWithOptions");
    
    return YES;
}

- (void)shareSDK {
    [ShareSDK registerApp:@"1036529846b88" activePlatforms:@[@(SSDKPlatformTypeWechat)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx718c6680d68744a4"
                                      appSecret:@"dc60d64d62987255adc241917bdae597"];
                break;
            default:
                break;
        }
    }];
}

-(void)toast:(NSString*)message {
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

-(void)updateSoftAlertViewShow:(NSString*)message isForceUpdate:(BOOL)isForce {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新版本发布" message:message delegate:self cancelButtonTitle:isForce?nil:@"下次更新" otherButtonTitles:@"更新", nil];
    alert.tag = 100;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == 100) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://dwz.cn/F8pPd"]];
            exit(0);
        }
    }
}

+(AppDelegate*)shareInstance {
    return [[UIApplication sharedApplication] delegate];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"推送的内容：%@",notificationSettings);
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    self.callid = nil;
    NSString *userdata = [userInfo objectForKey:@"c"];
    NSLog(@"远程推送userdata:%@",userdata);
    if (userdata) {
        NSDictionary*callidobj = [NSJSONSerialization JSONObjectWithData:[userdata dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"远程推送callidobj:%@",callidobj);
        if ([callidobj isKindOfClass:[NSDictionary class]]) {
            self.callid = [callidobj objectForKey:@"callid"];
        }
    }
    
    NSLog(@"远程推送 callid=%@",self.callid);
}

#warning 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    #warning 将获取到的token传给SDK，用于苹果推送消息使用
    [[ECDevice sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

#warning 注册deviceToken失败；此处失败，与SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
    NSInteger count = 0;
    UINavigationController * rootView = (UINavigationController*)self.window.rootViewController;
    if ([rootView.viewControllers[0] isKindOfClass:[MainViewController class]]) {
        count = [[IMMsgDBAccess sharedInstance] getUnreadMessageCountFromSession];
    } 
    application.applicationIconBadgeNumber = count;
    
    [[ECDevice sharedInstance] setAppleBadgeNumber:count completion:^(ECError *error) {
        
    }];
    usleep(10);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  
    [DeviceDelegateHelper sharedInstance].isB2F = YES;
    [DeviceDelegateHelper sharedInstance].preDate = nil;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //BQMM集成
    [[MMEmotionCentre defaultCentre] clearSession];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [DeviceDelegateHelper sharedInstance].preDate = [NSDate date];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)getLoginInfo {
    NSString *loginInfo = [DemoGlobalClass sharedInstance].userName;
    if (loginInfo.length>0) {
        return YES;
    }
    return NO;
}

//登录页面和主页面的切换
-(void)connectStateChanged:(NSNotification *)notification {
    ECError* error = notification.object;
    UINavigationController * rootView = (UINavigationController*)self.window.rootViewController;
    if (error) {
        [DemoGlobalClass sharedInstance].isLogin = NO;
        
        if (error.errorCode == ECErrorType_KickedOff || error.errorCode == 10) {
            
            NSMutableArray *navArray = [NSMutableArray arrayWithArray:rootView.viewControllers];
            [navArray removeAllObjects];
            rootView.viewControllers = navArray;
            
            if (_loginView == nil) {
                self.loginView = [[LoginViewController alloc] init];
                rootView = [[UINavigationController alloc] initWithRootViewController:_loginView];
            } else {
                rootView = self.loginView.navigationController;
            }
            self.mainView = nil;
            
            [DemoGlobalClass sharedInstance].userName = nil;
            
            if (error.errorCode == ECErrorType_KickedOff){
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:error.errorDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            
        } else if (error.errorCode == ECErrorType_NoError) {
            
            [DemoGlobalClass sharedInstance].isLogin = YES;
            [DemoGlobalClass sharedInstance].isHiddenLoginError = NO;
            if (_mainView == nil) {
                self.mainView = [[MainViewController alloc] init];
                rootView = [[UINavigationController alloc] initWithRootViewController:_mainView];
            } else {
                rootView = self.mainView.navigationController;
            }
            self.loginView = nil;
            
        } else if (error.errorCode != ECErrorType_Connecting
                && error.errorCode != ECErrorType_TokenAuthFailed
                && error.errorCode != ECErrorType_AuthServerException
                && error.errorCode != ECErrorType_ConnectorServerException) {
            
            if (![DemoGlobalClass sharedInstance].isHiddenLoginError) {
                [DemoGlobalClass sharedInstance].isHiddenLoginError = YES;
                [self toast:[NSString stringWithFormat:@"错误码:%d",(int)error.errorCode]];
            }
        }
    }
    
    [rootView.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
    self.window.rootViewController = rootView;
}

@end
