//
//  SwitchIPViewController.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 15/11/5.
//  Copyright © 2015年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchIPViewController : UIViewController
{
    UITextField *name_textfield;
    UITextField *cip_textfield;
    UITextField *cport_textfield;
    UITextField *lip_textfield;
    UITextField *lport_textfield;
    UITextField *fip_textfield;
    UITextField *fport_textfield;
    UITextField *key_textfield;
    UITextField *token_textfield;
}
-(BOOL)deleteIpConfig:(NSString*)name;
-(void)selectIpConfig:(NSDictionary*)valuedic;
@end
