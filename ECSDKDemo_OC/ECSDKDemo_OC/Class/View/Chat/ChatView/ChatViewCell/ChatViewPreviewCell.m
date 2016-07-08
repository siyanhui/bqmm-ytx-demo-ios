//
//  ChatViewPreviewCell.m
//  ECSDKDemo_OC
//
//  Created by admin on 16/3/22.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import "ChatViewPreviewCell.h"
#import "ECPreviewMessageBody.h"
#import "UIImage+MultiFormat.h"
#import "UIImageView+WebCache.h"

#define CellH 110.0f
#define CellW 205.0f
#define margin 10.0f
#define titleH 20.0f
#define margin1 5.0f

@interface ChatViewPreviewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation ChatViewPreviewCell

- (instancetype)initWithIsSender:(BOOL)isSender reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithIsSender:isSender reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        UIImage *image = [UIImage imageNamed:@"attachment"];
        _imgView = [[UIImageView alloc] initWithImage:image];
        _imgView.contentMode = UIViewContentModeScaleToFill;
        _imgView.userInteractionEnabled = NO;
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.numberOfLines = 0;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.font = [UIFont systemFontOfSize:13.0f];
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.textAlignment = NSTextAlignmentJustified;
        
        CGFloat imgViewWH = CellH-titleH-3*margin-margin1;
        if (isSender) {
            self.bubbleView.frame = CGRectMake(CGRectGetMinX(self.portraitImg.frame)-CellW-10, self.portraitImg.frame.origin.y, CellW, CellH);
            self.bubleimg.image =
            [[UIImage imageNamed:@"chat_sender_preView"] stretchableImageWithLeftCapWidth:33 topCapHeight:33];
            
            _titleLabel.frame = CGRectMake(margin+margin, margin, CellW-4*margin, titleH);
            _imgView.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)+margin1,imgViewWH , imgViewWH);
            _detailLabel.frame = CGRectMake(CGRectGetMaxX(_imgView.frame)+margin1, CGRectGetMaxY(_titleLabel.frame)+margin1, CellW-imgViewWH-4*margin-margin1, imgViewWH);
            
        } else {
            _titleLabel.frame = CGRectMake(margin+10, margin, CellW-3*margin, titleH);
            _imgView.frame = CGRectMake(margin+10, CGRectGetMaxY(_titleLabel.frame)+margin1, imgViewWH, imgViewWH);
            _detailLabel.frame = CGRectMake(CGRectGetMaxX(_imgView.frame), CGRectGetMaxY(_titleLabel.frame)+margin1,CellW-imgViewWH-margin*4 -margin1, imgViewWH);
            
            self.bubbleView.frame = CGRectMake(CGRectGetMaxX(self.portraitImg.frame)+10.0f, self.portraitImg.frame.origin.y, CellW, CellH);
        }

        [self.bubbleView addSubview:_titleLabel];
        [self.bubbleView addSubview:_imgView];
        [self.bubbleView addSubview:_detailLabel];
    }
    return self;
}

+(CGFloat)getHightOfCellViewWith:(ECMessageBody *)message {
    return 150.0f;
}

NSString *const KResponderCustomChatViewPreviewCellBubbleViewEvent = @"KResponderCustomChatViewPreviewCellBubbleViewEvent";

- (void)bubbleViewTapGesture:(id)sender {
    [self dispatchCustomEventWithName:KResponderCustomChatViewPreviewCellBubbleViewEvent userInfo:@{KResponderCustomECMessageKey:self.displayMessage}];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    ECMessage *message = self.displayMessage;
    ECPreviewMessageBody *body = (ECPreviewMessageBody *)message.messageBody;
    _titleLabel.text = body.title;
    _detailLabel.text = body.desc;

    if (body.thumbnailLocalPath.length>0 && ([[NSFileManager defaultManager] fileExistsAtPath:body.thumbnailLocalPath]) && (message.messageState != ECMessageState_Receive || body.mediaDownloadStatus==ECMediaDownloadSuccessed)) {
        _imgView.image = [UIImage imageWithContentsOfFile:body.thumbnailLocalPath];
        
    } else if (message.messageState ==ECMessageState_Receive && body.thumbnailRemotePath.length>0) {
        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:body.thumbnailRemotePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                _imgView.image = image;
            }
        }];
    }
    [super updateMessageSendStatus:message.messageState];
}
@end
