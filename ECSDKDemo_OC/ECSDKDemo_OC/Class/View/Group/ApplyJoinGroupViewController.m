//
//  ApplyJoinGroupViewController.m
//  ECSDKDemo_OC
//
//  Created by lrn on 14/12/10.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "ApplyJoinGroupViewController.h"

@interface ApplyJoinGroupViewController ()<UIAlertViewDelegate>
@end

const char KAlertGroup;

@implementation ApplyJoinGroupViewController
{
    UILabel * tellLabel;
    UILabel * groupLabel;
    UILabel * groupOwner;
    UILabel * groupName;
    UILabel * groupNum;
    
}

#pragma mark - prepareUI

-(void)prepareUI {
    
    CGFloat frameY = 0.0f;
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        frameY = 64.0f;
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        frameY = 0.0f;
    }
    self.navigationItem.leftBarButtonItem = leftItem;

    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, frameY, 320.0f, 50.0f)];
    label1.backgroundColor =[UIColor colorWithRed:0.97f green:0.96f blue:0.97f alpha:1.00f];
    label1.text = @"  群简介";
    [self.view addSubview:label1];
    
    groupName = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, frameY+60.0f, 320.0f, 40.0f)];
    groupName.font = [UIFont systemFontOfSize:18];
    groupName.textColor =[UIColor colorWithRed:0.39f green:0.39f blue:0.39f alpha:1.00f];
    [self.view addSubview:groupName];
    
    
    groupOwner = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, frameY+100.0f, 320.0f, 40.0f)];
    groupOwner.font = [UIFont systemFontOfSize:18];
    groupOwner.textColor =[UIColor colorWithRed:0.39f green:0.39f blue:0.39f alpha:1.00f];
    [self.view addSubview:groupOwner];
    
    groupLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, frameY+140.0f, 320.0f, 40.0f)];
    groupLabel.font = [UIFont systemFontOfSize:18];
    groupLabel.textColor =[UIColor colorWithRed:0.39f green:0.39f blue:0.39f alpha:1.00f];
    [self.view addSubview:groupLabel];

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, frameY+190.0f, 320.0f, 50.0f)];
    label.backgroundColor =[UIColor colorWithRed:0.97f green:0.96f blue:0.97f alpha:1.00f];
    label.text = @"  群公告";
    [self.view addSubview:label];
    
    tellLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, frameY+210.0f+50.0f, 320.0f, 80.0f)];
    tellLabel.numberOfLines =2;
    tellLabel.font = [UIFont systemFontOfSize:18];
    tellLabel.textColor =[UIColor colorWithRed:0.39f green:0.39f blue:0.39f alpha:1.00f];
    [self.view addSubview:tellLabel];

    UIButton * joinBtn = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, frameY+360.0f, 300.0f, 50.0f)];
    [joinBtn setTitle:@"申请加入" forState:UIControlStateNormal];
    [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinBtn setBackgroundImage:[CommonTools createImageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(joinBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:joinBtn];
}

#pragma mark - BtnClick
-(void)joinBtnClicked {
    if (self.applyGroup.mode == ECGroupPermMode_NeedIdAuth) {
        [self popDeclaredAlertView:self.applyGroup];
    }else if (self.applyGroup.mode == ECGroupPermMode_DefaultJoin){
        [self joinGroup:self.applyGroup.groupId withReason:nil];
    }
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareUI];
    
    __weak __typeof(self)weakSelf = self;
    [[ECDevice sharedInstance].messageManager getGroupDetail:self.applyGroup.groupId completion:^(ECError *error, ECGroup *group) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (group.declared.length == 0) {
            tellLabel.text = @"  该群组无公告";
        }else{
            tellLabel.text = [NSString stringWithFormat:@"  %@",group.declared];
        }
        groupLabel.text =[NSString stringWithFormat:@"  群ID:%@",group.groupId]; ;
        groupOwner.text =[NSString stringWithFormat:@"  群主:%@",group.owner];
        groupName.text = [NSString stringWithFormat:@"  群名字:%@",group.name];
        
        strongSelf.title = group.name;
        strongSelf.applyGroup.name = group.name;
        strongSelf.applyGroup.owner = group.owner;
        strongSelf.applyGroup.declared = group.declared;
    }];
}

-(void)popDeclaredAlertView:(ECGroup*)group
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"理由" message:@"加入群组理由" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    objc_setAssociatedObject(alertView, &KAlertGroup, group, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        ECGroup* group = objc_getAssociatedObject(alertView, &KAlertGroup);
        [self joinGroup:group.groupId withReason:textField.text];
    }
}

-(void)joinGroup:(NSString*)groupId withReason:(NSString*)reason
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"请稍等...";
    hud.removeFromSuperViewOnHide = YES;
    
    __weak __typeof(self)weakSelf = self;
    [[ECDevice sharedInstance].messageManager joinGroup:groupId reason:reason completion:^(ECError *error, NSString *groupId) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:NO];
        if (error.errorCode==ECErrorType_Have_Joined) {
            
            UIViewController* viewController = [[NSClassFromString(@"ChatViewController") alloc] init];
            SEL aSelector = NSSelectorFromString(@"ECDemo_setSessionId:");
            if ([viewController respondsToSelector:aSelector]) {
                IMP aIMP = [viewController methodForSelector:aSelector];
                void (*setter)(id, SEL, NSString*) = (void(*)(id, SEL, NSString*))aIMP;
                setter(viewController, aSelector, strongSelf.applyGroup.groupId);
            }
            [strongSelf.navigationController setViewControllers:[NSArray arrayWithObjects:[strongSelf.navigationController.viewControllers objectAtIndex:0],viewController, nil] animated:YES];
            
        }else if(error.errorCode==ECErrorType_NoError){
            if (strongSelf.applyGroup.mode == ECGroupPermMode_DefaultJoin) {
                
                UIViewController* viewController = [[NSClassFromString(@"ChatViewController") alloc] init];
                SEL aSelector = NSSelectorFromString(@"ECDemo_setSessionId:");
                if ([viewController respondsToSelector:aSelector]) {
                    IMP aIMP = [viewController methodForSelector:aSelector];
                    void (*setter)(id, SEL, NSString*) = (void(*)(id, SEL, NSString*))aIMP;
                    setter(viewController, aSelector, strongSelf.applyGroup.groupId);
                }
                [strongSelf.navigationController setViewControllers:[NSArray arrayWithObjects:[strongSelf.navigationController.viewControllers objectAtIndex:0],viewController, nil] animated:YES];
                
            }else{
                [strongSelf showToast:@"申请加入已发出，请等待群主同意请求"];
            }
        } else {
            NSString* detail = error.errorDescription.length>0?[NSString stringWithFormat:@"\r描述:%@",error.errorDescription]:@"";
            [strongSelf showToast:[NSString stringWithFormat:@"错误码:%d%@",(int)error.errorCode,detail]];
        }
    }];
}

//Toast错误信息
-(void)showToast:(NSString *)message
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}
@end
