//
//  SessionViewCell.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "SessionViewCell.h"

@implementation SessionViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _portraitImg = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 45.0f, 45.0f)];
        _portraitImg.contentMode = UIViewContentModeScaleAspectFit;
        _portraitImg.image = [UIImage imageNamed:@"personal_portrait"];
        [self.contentView addSubview:_portraitImg];
        
        _unReadMsgRed = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unReadMsgRed setBackgroundImage:[UIImage imageNamed:@"UN_ReadMsg"] forState:UIControlStateNormal];
        _unReadMsgRed.userInteractionEnabled = NO;
        [_unReadMsgRed sizeToFit];
        _unReadMsgRed.center = CGPointMake(CGRectGetMaxX(_portraitImg.frame),10.0f);
        [self.contentView addSubview:_unReadMsgRed];
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(210.0f, 5.0f, 100.0f, 20.0f)];
        _dateLabel.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
        _dateLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dateLabel];
        
        _atLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_portraitImg.frame), 35.0f, 40.0f, 15.0f)];
        _atLabel.textColor = [UIColor redColor];
        _atLabel.text = @"[有人@我]";
        _atLabel.backgroundColor = [UIColor clearColor];
        _atLabel.font = [UIFont systemFontOfSize:13.0f];
        _atLabel.textAlignment = NSTextAlignmentCenter;
        [_atLabel sizeToFit];
        _atLabel.hidden = YES;
        [self.contentView addSubview:_atLabel];
        
        _unReadLabel = [[UILabel alloc]initWithFrame:CGRectMake(280.0f, 35.0f, 25.0f, 20.0f)];
        _unReadLabel.backgroundColor = [UIColor redColor];
        _unReadLabel.textColor = [UIColor whiteColor];
        _unReadLabel.font = [UIFont systemFontOfSize:13];
        _unReadLabel.layer.cornerRadius =10;
        _unReadLabel.layer.masksToBounds = YES;
        
        _unReadLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_unReadLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 10.0f, _dateLabel.frame.origin.x-70.0f, 25.0f)];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height, self.frame.size.width-140.0f, 15.0f)];
        _contentLabel.font = [UIFont systemFontOfSize:13.0f];
        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _contentLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_contentLabel];
        
        _noPushImg = [[UIImageView alloc] initWithFrame:CGRectMake(290.0f, 37.0f, 15.0f, 15.0f)];
        _noPushImg.image = [UIImage imageNamed:@"chat_group_notpush"];
        [self.contentView addSubview:_noPushImg];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.session.isAt) {
        _atLabel.hidden = NO;
        CGRect frame = _contentLabel.frame;
        frame.origin.x = CGRectGetMaxX(_atLabel.frame);
        frame.size.width = self.frame.size.width-140-_atLabel.frame.size.width;
        _contentLabel.frame = frame;
    } else {
        [_atLabel setHidden:YES];
        CGRect frame = _contentLabel.frame;
        frame.origin.x = CGRectGetMinX(_nameLabel.frame);
        frame.size.width = self.frame.size.width-140;
        _contentLabel.frame = frame;
    }
}
@end
