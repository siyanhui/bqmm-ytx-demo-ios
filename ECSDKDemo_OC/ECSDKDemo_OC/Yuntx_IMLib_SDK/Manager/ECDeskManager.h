//
//  ECDeskManager.h
//  CCPiPhoneSDK
//
//  Created by jiazy on 15/5/18.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import "ECManagerBase.h"
#import "ECError.h"

/**
 *  客服消息
 */
@protocol ECDeskManager <ECManagerBase>
@optional

/**
 @brief  开始和客服聊天
 @param agent      客服账号
 @param completion 执行结果回调block
 */
-(void)startConsultationWithOSAccount:(NSString*)osAccount andQueueType:(NSInteger)qType completion:(void(^)(ECError* error, NSString* osAccount))completion;

/**
 @brief 结束聊天
 @param agent      客服账号
 @param completion 执行结果回调block
 */
-(void)finishConsultation:(void(^)(ECError* error))completion;

/**
 @brief  发送消息
 @param message    发给客服的消息
 @param progress   上传进度
 @param completion 执行结果回调block
 @return 函数调用成功返回消息id，失败返回nil
 */
-(NSString*)sendToDeskMessage:(ECMessage*)message progress:(id<ECProgressDelegate>)progress completion:(void(^)(ECError *error, ECMessage* message))completion;
@required

@end

