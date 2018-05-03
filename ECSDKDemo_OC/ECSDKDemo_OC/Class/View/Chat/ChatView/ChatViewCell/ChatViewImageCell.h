//
//  ChatViewImageCell.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/16.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "ChatViewCell.h"

@interface ChatViewImageCell : ChatViewCell
extern NSString *const KResponderCustomChatViewImageCellBubbleViewEvent;

//BQMM集成
+(CGFloat)getHightOfCellViewWithMessage:(ECMessage *)message;
- (void)setdata:(ECMessage *)message;
@end
