//
//  SwitchIPViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 15/11/5.
//  Copyright © 2015年 ronglian. All rights reserved.
//

#import "SwitchIPViewController.h"
#import "IMMsgDBAccess.h"
#import "IPConfigListViewController.h"

@interface SwitchIPViewController()
@property (nonatomic, strong) FMDatabase *dataBase;
@end

@implementation SwitchIPViewController
-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"配置ip地址";
    //数据库文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *olddbPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"im_demo_ipconfig.db"];
    
    //数据库文件夹
    NSArray *docpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *newdbPath = [[docpaths objectAtIndex:0] stringByAppendingPathComponent:@"im_demo_ipconfig.db"];
    
    if ((![[NSFileManager defaultManager] fileExistsAtPath:newdbPath]) && [[NSFileManager defaultManager] fileExistsAtPath:olddbPath]) {
        //如果新的路径没有，且老的数据库存在，拷贝老的到新的，且删除老的数据库
        [[NSFileManager defaultManager] copyItemAtPath:olddbPath toPath:newdbPath error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:olddbPath error:nil];
    }
    
    self.dataBase = [FMDatabase databaseWithPath:newdbPath];
    [self.dataBase open];
    [self configIpTableCreate];
    
    UIScrollView *myview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    myview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+150.0f);
    self.view = myview;
    myview.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.96f alpha:1.00f];
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
    
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"重置配置" style:UIBarButtonItemStyleDone target:self action:@selector(resetConfig)];
    [rightBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [rightBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    CGFloat marginX = 10.0f;
    CGFloat marginY = 10.0f;
    CGFloat heigth = 30.0f;
    CGFloat wigth = 300.0f;
    NSArray *placeHolderArr = @[@"配置描述",@"Connect IP",@"Connect Port",@"LVS IP",@"LVS Port", @"File IP",@"File Port", @"APP ID",@"APP Token"];
    NSInteger i=0;
    for (; i<placeHolderArr.count; i++) {
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(marginX, marginX+(marginY+heigth)*i, wigth, heigth)];
        text.tag = 99+i;
        text.keyboardType = UIKeyboardTypeURL;
        text.borderStyle = UITextBorderStyleRoundedRect;
        text.placeholder = placeHolderArr[i];
        [self.view addSubview:text];
    }
    
    name_textfield = (UITextField*)[self.view viewWithTag:99];
    name_textfield.keyboardType = UIKeyboardTypeDefault;
    
    cip_textfield = (UITextField*)[self.view viewWithTag:100];
    cport_textfield = (UITextField*)[self.view viewWithTag:101];
    cport_textfield.text = @"8085";
    
    lip_textfield = (UITextField*)[self.view viewWithTag:102];
    lport_textfield = (UITextField*)[self.view viewWithTag:103];
    lport_textfield.text = @"8888";
    
    fip_textfield = (UITextField*)[self.view viewWithTag:104];
    fport_textfield = (UITextField*)[self.view viewWithTag:105];
    fport_textfield.text = @"8090";
    
    key_textfield = (UITextField*)[self.view viewWithTag:106];
    token_textfield = (UITextField*)[self.view viewWithTag:107];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10.0f, marginX+(marginY+heigth)*i, 90.0f, heigth);
    [button setTitle:@"设置IP" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"select_account_button"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setIPConfig) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(110.0f, marginX+(marginY+heigth)*i, 90.0f, heigth);
    [button setTitle:@"设置APP" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"select_account_button"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setAPPConfig) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(210.0f, marginX+(marginY+heigth)*i, 90.0f, heigth);
    [button setTitle:@"设置全部" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"select_account_button"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setAllConfig) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    i++;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20.0f, marginX+(marginY+heigth)*i, 130.0f, heigth);
    [button setTitle:@"添加列表" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"select_account_button"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addIPConfig) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(160.0f, marginX+(marginY+heigth)*i, 130.0f, heigth);
    [button setTitle:@"查询列表" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"select_account_button"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getIPConfig) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)SingleTap:(UITapGestureRecognizer*)recognizer {
    [self.view endEditing:YES];
}

- (void)returnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetConfig {
    [[DemoGlobalClass sharedInstance] resetResourceServer];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)addIPConfig {
    NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if ([name_textfield.text stringByTrimmingCharactersInSet:ws].length==0
        || [cip_textfield.text stringByTrimmingCharactersInSet:ws].length==0
        || [cport_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [lip_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [lport_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [fip_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [fport_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [key_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [token_textfield.text stringByTrimmingCharactersInSet:ws].length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检查输入内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSDictionary *valueDic = @{@"name":[name_textfield.text stringByTrimmingCharactersInSet:ws],@"cip":[cip_textfield.text stringByTrimmingCharactersInSet:ws] ,@"cport":[cport_textfield.text stringByTrimmingCharactersInSet:ws],@"lip":[lip_textfield.text stringByTrimmingCharactersInSet:ws],@"lport":[lport_textfield.text stringByTrimmingCharactersInSet:ws],@"fip":[fip_textfield.text stringByTrimmingCharactersInSet:ws],@"fport":[fport_textfield.text stringByTrimmingCharactersInSet:ws],@"appid":[key_textfield.text stringByTrimmingCharactersInSet:ws],@"apptoken":[token_textfield.text stringByTrimmingCharactersInSet:ws]};
    
    if ([self addIpConfig:valueDic]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)getIPConfig {
    NSMutableArray* configArray = [self getAllIpConfig];
    if (configArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂时无列表，请先添加列表" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else {
        IPConfigListViewController *view = [[IPConfigListViewController alloc] init];
        view.viewcontroller = self;
        view.ipArray = configArray;
        [self.navigationController pushViewController:view animated:YES];
    }
}

-(void)setIPConfig {
    
    NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if ([cip_textfield.text stringByTrimmingCharactersInSet:ws].length==0
        || [cport_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [lip_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [lport_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [fip_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [fport_textfield.text stringByTrimmingCharactersInSet:ws].length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检查输入内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[DemoGlobalClass sharedInstance] setConfigData:[cip_textfield.text stringByTrimmingCharactersInSet:ws] :[cport_textfield.text stringByTrimmingCharactersInSet:ws] :[lip_textfield.text stringByTrimmingCharactersInSet:ws] :[lport_textfield.text stringByTrimmingCharactersInSet:ws] :[fip_textfield.text stringByTrimmingCharactersInSet:ws] :[fport_textfield.text stringByTrimmingCharactersInSet:ws]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)setAPPConfig {
    NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if ( [key_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [token_textfield.text stringByTrimmingCharactersInSet:ws].length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检查输入内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[DemoGlobalClass sharedInstance] setAppKey:[key_textfield.text stringByTrimmingCharactersInSet:ws] AndAppToken:[token_textfield.text stringByTrimmingCharactersInSet:ws]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)setAllConfig {
    
    NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if ([cip_textfield.text stringByTrimmingCharactersInSet:ws].length==0
        || [cport_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [lip_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [lport_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [fip_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [fport_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [key_textfield.text stringByTrimmingCharactersInSet:ws].length == 0
        || [token_textfield.text stringByTrimmingCharactersInSet:ws].length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检查输入内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[DemoGlobalClass sharedInstance] setConfigData:[cip_textfield.text stringByTrimmingCharactersInSet:ws] :[cport_textfield.text stringByTrimmingCharactersInSet:ws] :[lip_textfield.text stringByTrimmingCharactersInSet:ws] :[lport_textfield.text stringByTrimmingCharactersInSet:ws] :[fip_textfield.text stringByTrimmingCharactersInSet:ws] :[fport_textfield.text stringByTrimmingCharactersInSet:ws]];
    
    [[DemoGlobalClass sharedInstance] setAppKey:[key_textfield.text stringByTrimmingCharactersInSet:ws] AndAppToken:[token_textfield.text stringByTrimmingCharactersInSet:ws]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)selectIpConfig:(NSDictionary*)valuedic {
    NSArray * textarray = @[name_textfield, cip_textfield, cport_textfield, lip_textfield, lport_textfield, fip_textfield, fport_textfield, key_textfield, token_textfield];
    for (int index=0; index<textarray.count; index++) {
        UITextField* textfiled = (UITextField*)textarray[index];
        textfiled.text = valuedic[@(index)];
    }
}

//////////////////////////////////////
-(void)configIpTableCreate {
    BOOL isExist = [self.dataBase tableExists:@"configIpTable"];
    if (!isExist) {
        [self.dataBase executeUpdate:@"CREATE table configIpTable(name varchar(32) PRIMARY KEY,cip varchar(32),cport varchar(32),lip varchar(32),lport varchar(32),fip varchar(32),fport varchar(32),appid varchar(80),apptoken varchar(80));CREATE INDEX configIpTable_index ON configIpTable(name);"];
    }
}

-(BOOL)deleteIpConfig:(NSString*)name {
    return [self.dataBase executeUpdate:[NSString stringWithFormat: @"DELETE FROM configIpTable WHERE name = '%@'", name]];
}

-(BOOL)addIpConfig:(NSDictionary*)valueDic {
    return [self.dataBase executeUpdate:@"INSERT OR REPLACE INTO configIpTable(name,cip,cport,lip,lport,fip,fport,appid,apptoken) VALUES (:name,:cip,:cport,:lip,:lport,:fip,:fport,:appid,:apptoken)" withParameterDictionary:valueDic];
}

-(NSMutableArray*)getAllIpConfig {
    NSMutableArray *msgArray = [[NSMutableArray alloc] init];
    FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT name,cip,cport,lip,lport,fip,fport,appid,apptoken FROM configIpTable"]];
    
    while ([rs next]) {
        int columnIndex = 0;
        NSMutableDictionary *valueDic = [NSMutableDictionary dictionary];
        [msgArray addObject:valueDic];
        
        for (; columnIndex<10; columnIndex++) {
            NSString * value = [rs stringForColumnIndex:columnIndex];
            if (value == nil) {
                value = @"";
            }
            [valueDic setObject:value forKey:@(columnIndex)];
        }
    }
    return msgArray;
}
//////////////////////////////////////
@end
