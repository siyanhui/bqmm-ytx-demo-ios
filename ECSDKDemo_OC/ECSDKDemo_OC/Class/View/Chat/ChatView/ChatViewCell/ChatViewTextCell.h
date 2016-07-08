//
//  ChatViewTextCell.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/8.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "ChatViewCell.h"
extern NSString *const KResponderCustomChatViewTextCellBubbleViewEvent;
extern NSString *const KResponderCustomChatViewTextLnkCellBubbleViewEvent;
@interface ChatViewTextCell : ChatViewCell

//BQMM集成
+(CGFloat)getHightOfCellViewWithMessage:(ECMessage *)message;

@end
