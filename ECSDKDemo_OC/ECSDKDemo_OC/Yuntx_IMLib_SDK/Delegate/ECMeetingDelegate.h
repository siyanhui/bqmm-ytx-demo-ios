//
//  ECMeetingDelegate.h
//  CCPiPhoneSDK
//
//  Created by adminlrn on 15/4/13.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ECDelegateBase.h"
#import "ECInterphoneMeetingMsg.h"
#import "ECMultiVoiceMeetingMsg.h"
#import "ECMultiVideoMeetingMsg.h"
#import "ECMeetingMember.h"
#import "ECMeetingRoom.h"
#import "ECError.h"


ECKIT_EXTERN NSString *const ECMeetingDelegate_CallerAccount;
ECKIT_EXTERN NSString *const ECMeetingDelegate_CallerPhone;
ECKIT_EXTERN NSString *const ECMeetingDelegate_CallerName;
ECKIT_EXTERN NSString *const ECMeetingDelegate_CallerConfId;
ECKIT_EXTERN NSString *const ECMeetingDelegate_CallerConfType;
ECKIT_EXTERN NSString *const ECMeetingDelegate_CallerConfInviteUserData;

/**
 * 该代理接收会议通知消息
 */
@protocol ECMeetingDelegate <ECDelegateBase>

@optional

/**
 @brief 有会议呼叫邀请
 @param callid      会话id
 @param calltype    呼叫类型
 @param meetingData 会议的数据
 */
- (NSString*)onMeetingCallReceived:(NSString*)callid withCallType:(CallType)calltype withMeetingData:(NSDictionary*)meetingData;

/**
 @brief 实时对讲通知消息
 @param msg 实时对讲消息
 */
-(void)onReceiveInterphoneMeetingMsg:(ECInterphoneMeetingMsg *)msg;

/**
 @brief 语音群聊通知消息
 @param msg 语音群聊消息
 */
-(void)onReceiveMultiVoiceMeetingMsg:(ECMultiVoiceMeetingMsg *)msg;

/**
 @brief 多路视频通知消息
 @param msg 多路视频消息
 */
-(void)onReceiveMultiVideoMeetingMsg:(ECMultiVideoMeetingMsg *)msg;

@end