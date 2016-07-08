//
//  ChatViewTextCell.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/8.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "ChatViewTextCell.h"

//BQMM集成
#import "MMTextView.h"
#import "MMTextParser+ExtData.h"


NSString *const KResponderCustomChatViewTextCellBubbleViewEvent = @"KResponderCustomChatViewTextCellBubbleViewEvent";
NSString *const KResponderCustomChatViewTextLnkCellBubbleViewEvent = @"KResponderCustomChatViewTextLnkCellBubbleViewEvent";
#define LabelFont [UIFont systemFontOfSize:15.0f]
#define BubbleMaxSize CGSizeMake(180.0f, 10000.0f)
@interface ChatViewTextCell()<MMTextViewDelegate, MMTextViewDelegate>  //BQMM集成
@property (nonatomic, strong)NSDataDetector *detector;
@property (nonatomic, strong) NSArray *urlMatches;
@property (nonatomic, copy) NSString *url;
@end
@implementation ChatViewTextCell
{
    UILabel *_label;
    MMTextView *_textView; //BQMM集成
}

-(instancetype) initWithIsSender:(BOOL)isSender reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithIsSender:isSender reuseIdentifier:reuseIdentifier]) {
        if (isSender) {
            _label = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 2.0f, self.bubbleView.frame.size.width-15.0f, self.bubbleView.frame.size.height-6.0f)];
            
            _textView = [[MMTextView alloc] initWithFrame:CGRectMake(5.0f, 2.0f, self.bubbleView.frame.size.width-15.0f, self.bubbleView.frame.size.height-6.0f)];
        }
        else{
            _label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 2.0f, self.bubbleView.frame.size.width-15.0f, self.bubbleView.frame.size.height-6.0f)];
            
            _textView = [[MMTextView alloc] initWithFrame:CGRectMake(10.0f, 2.0f, self.bubbleView.frame.size.width-15.0f, self.bubbleView.frame.size.height-6.0f)];
        }
        self.detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        _label.numberOfLines = 0;
        _label.font = LabelFont;
        _label.lineBreakMode = NSLineBreakByCharWrapping;
        _label.backgroundColor = [UIColor clearColor];
        [self.bubbleView addSubview:_label];
        
        //BQMM集成
        _label.hidden = true;
        
        _textView.mmFont = LabelFont;
        _textView.mmTextColor = [UIColor blackColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.selectable = NO;
        _textView.clickActionDelegate = self;
        [self.bubbleView addSubview:_textView];
    }
    return self;
}

-(void)bubbleViewTapGesture:(id)sender{
    
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    CGPoint point = [tap locationInView:_label];
    CFIndex charIndex = [self characterIndexAtPoint:point];
    
    [self highlightLinksWithIndex:NSNotFound];
    
    for (NSTextCheckingResult *match in self.urlMatches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            if ([self isIndex:charIndex inRange:matchRange]) {
//                [[UIApplication sharedApplication] openURL:match.URL];
//                break;
                _url = [NSString stringWithFormat:@"%@",match.URL];
            }
        }
    }
    if (_url.length>0) {
        [self dispatchCustomEventWithName:KResponderCustomChatViewTextLnkCellBubbleViewEvent userInfo:@{KResponderCustomECMessageKey:self.displayMessage,@"url":_url}];
    } else {
        [self dispatchCustomEventWithName:KResponderCustomChatViewTextCellBubbleViewEvent userInfo:@{KResponderCustomECMessageKey:self.displayMessage}];
    }
}

//BQMM集成
+(CGFloat)getHightOfCellViewWithMessage:(ECMessage *)message {
    CGFloat height = 65.0f;
    //解析消息扩展
    NSString *extString = message.userData;
    NSDictionary *extDic = nil;
    if (extString != nil) {
        NSData *extData = [extString dataUsingEncoding:NSUTF8StringEncoding];
        extDic = [NSJSONSerialization JSONObjectWithData:extData options:NSJSONReadingMutableLeaves error:nil];
    }
    CGSize contentSize = CGSizeZero;
    if (extDic != nil && [extDic[@"txt_msgType"] isEqualToString: @"emojitype"]) { //大表情消息
        contentSize = [MMTextParser sizeForMMTextWithExtData:extDic[@"msg_data"] font:LabelFont maximumTextWidth:BubbleMaxSize.width];
    }else{
        ECTextMessageBody *body = (ECTextMessageBody*)message.messageBody;
        contentSize = [MMTextParser sizeForTextWithText:body.text font:LabelFont maximumTextWidth:BubbleMaxSize.width];
    }
    
    if (contentSize.height>45.0f) {
        height = contentSize.height+20.0f;
    }
    return height;
    
}

+(CGFloat)getHightOfCellViewWith:(ECMessageBody *)message{
    CGFloat height = 65.0f;
    ECTextMessageBody *body = (ECTextMessageBody*)message;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize bubbleSize = [body.text sizeWithFont:LabelFont constrainedToSize:BubbleMaxSize lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    
    if (bubbleSize.height>45.0f) {
        height = bubbleSize.height+20.0f;
    }
    return height;
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point {
    NSMutableAttributedString* optimizedAttributedText = [_label.attributedText mutableCopy];
    
    // use label's font and lineBreakMode properties in case the attributedText does not contain such attributes
    [_label.attributedText enumerateAttributesInRange:NSMakeRange(0, [_label.attributedText length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if (!attrs[(NSString*)kCTFontAttributeName]) {
            [optimizedAttributedText addAttribute:(NSString*)kCTFontAttributeName value:_label.font range:NSMakeRange(0, [_label.attributedText length])];
        }
        
        if (!attrs[(NSString*)kCTParagraphStyleAttributeName]) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:_label.lineBreakMode];
            
            [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }];
    
    // modify kCTLineBreakByTruncatingTail lineBreakMode to kCTLineBreakByWordWrapping
    [optimizedAttributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
         NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
         
         if ([paragraphStyle lineBreakMode] == NSLineBreakByTruncatingTail) {
             [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
         }
         
         [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
         [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
     }];
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = _label.frame;
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [_label.attributedText length]), path, NULL);
    CFRelease(framesetter);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = _label.numberOfLines > 0 ? MIN(_label.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range {
    return index > range.location && index < range.location+range.length;
}

- (void)highlightLinksWithIndex:(CFIndex)index {
    
    NSMutableAttributedString* attributedString = [_label.attributedText mutableCopy];
    
    for (NSTextCheckingResult *match in self.urlMatches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            if ([self isIndex:index inRange:matchRange]) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:matchRange];
            } else {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:matchRange];
            }
            
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
        }
    }
    
    _label.attributedText = attributedString;
}

//BQMM集成
-(void)layoutSubviews{
    
    [super layoutSubviews];
    ECTextMessageBody *body = (ECTextMessageBody*)self.displayMessage.messageBody;
    
    if (body.text==nil) {
        body.text=@"";
    }

    //解析消息扩展
    NSString *extString = self.displayMessage.userData;
    NSDictionary *extDic = nil;
    if (extString != nil) {
        NSData *extData = [extString dataUsingEncoding:NSUTF8StringEncoding];
        extDic = [NSJSONSerialization JSONObjectWithData:extData options:NSJSONReadingMutableLeaves error:nil];
    }
    CGSize contentSize = CGSizeZero;
    if (extDic != nil && [extDic[@"txt_msgType"] isEqualToString: @"emojitype"]) { //大表情消息
        contentSize = [MMTextParser sizeForMMTextWithExtData:extDic[@"msg_data"] font:LabelFont maximumTextWidth:BubbleMaxSize.width];
        [_textView setMmTextData:extDic[@"msg_data"]];
    }else{
        contentSize = [MMTextParser sizeForTextWithText:body.text font:LabelFont maximumTextWidth:BubbleMaxSize.width];
        
        _textView.mmText = body.text;
    }
    
    if (contentSize.height<40.0f) {
        contentSize.height=40.0f;
    }
    
    [_textView setURLAttributes];

//    self.urlMatches = [self.detector matchesInString:body.text options:0 range:NSMakeRange(0, body.text.length)];
//    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]
//                                                    initWithString:body.text];
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
//    [attributedString addAttribute:NSParagraphStyleAttributeName
//                             value:paragraphStyle
//                             range:NSMakeRange(0, [body.text length])];
//    [attributedString addAttribute:NSFontAttributeName value:LabelFont range:NSMakeRange(0, [body.text length])];
//    
//    [_label setAttributedText:attributedString];
//    [self highlightLinksWithIndex:NSNotFound];
    
//    _label.text = body.text;
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    CGSize bubbleSize = [body.text sizeWithFont:LabelFont constrainedToSize:BubbleMaxSize lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
//    if (bubbleSize.height<40.0f) {
//        bubbleSize.height=40.0f;
//    }
    
    if (self.isSender) {
//        _label.frame = CGRectMake(9.0f, 2.0f, bubbleSize.width, bubbleSize.height);
//        self.bubbleView.frame = CGRectMake(self.portraitImg.frame.origin.x-bubbleSize.width-25.0f-10.0f, self.portraitImg.frame.origin.y, bubbleSize.width+25.0f, bubbleSize.height+6.0f);
        
        self.bubbleView.frame = CGRectMake(self.portraitImg.frame.origin.x-contentSize.width-25.0f-10.0f, self.portraitImg.frame.origin.y, contentSize.width+25.0f, contentSize.height+6.0f);
        
        _textView.frame = CGRectMake(9.0f, (self.bubbleView.frame.size.height - contentSize.height) / 2, contentSize.width, contentSize.height);
    } else {
//        _label.frame = CGRectMake(16.0f, 2.0f, bubbleSize.width, bubbleSize.height);
//        self.bubbleView.frame = CGRectMake(self.portraitImg.frame.origin.x+self.portraitImg.frame.size.width+10.0f, self.portraitImg.frame.origin.y, bubbleSize.width+25.0f, bubbleSize.height+6.0f);
        
        self.bubbleView.frame = CGRectMake(self.portraitImg.frame.origin.x+self.portraitImg.frame.size.width+10.0f, self.portraitImg.frame.origin.y, contentSize.width+25.0f, contentSize.height+6.0f);
        _textView.frame = CGRectMake(16.0f, (self.bubbleView.frame.size.height - contentSize.height) / 2, contentSize.width, contentSize.height);

    }
    
    [super updateMessageSendStatus:self.displayMessage.messageState];
}


//BQMM集成
#pragma mark MMTextViewDelegate
- (void)mmTextView:(MMTextView *)textView didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    NSString *number = [@"tel://" stringByAppendingString:phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}

- (void)mmTextView:(MMTextView *)textView didSelectLinkWithURL:(NSURL *)url {
    NSString *urlString=[url absoluteString];
    if (![urlString hasPrefix:@"http"]) {
        urlString = [@"http://" stringByAppendingString:urlString];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

@end
