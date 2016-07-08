//
//  SessionViewCell.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSession.h"

@interface SessionViewCell : UITableViewCell
@property (nonatomic, strong, readonly) UIImageView *portraitImg;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *contentLabel;
@property (nonatomic, strong, readonly) UILabel *unReadLabel;
@property (nonatomic, strong, readonly) UILabel *dateLabel;
@property (nonatomic, strong, readonly) UIImageView *noPushImg;
@property (nonatomic, strong) UIButton *unReadMsgRed;
@property (nonatomic, strong, readonly) UILabel *atLabel;
@property (nonatomic, strong) ECSession *session;
@end
