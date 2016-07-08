/*
 *  Copyright (c) 2013 The CCP project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a Beijing Speedtong Information Technology Co.,Ltd license
 *  that can be found in the LICENSE file in the root of the web site.
 *
 *                    http://www.yuntongxun.com
 *
 *  An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "CommonTools.h"
#import "EmojiConvertor.h"

EmojiConvertor *emojiConvert = nil;

@implementation CommonTools

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+(NSString*)getExpressionStrById:(NSInteger)idx
{
    NSString * str = [self getExpressionById:idx];
    if (emojiConvert == nil)
    {
        emojiConvert = [EmojiConvertor sharedInstance];
    }
    return str;
}

+(NSString*)getExpressionById:(NSInteger)idx
{
    switch(idx)
    {
        case 0: return @"\U0001F604";
        case 1: return @"\U0001F60A";
        case 2: return @"\U0001F603";
        case 3: return @"\u263A";
        case 4: return @"\U0001F609";
        case 5: return @"\U0001F60D";
        case 6: return @"\U0001F618";
        case 7: return @"\U0001F61A";
        case 8: return @"\U0001F633";
        case 9: return @"\U0001F60C";
        case 10: return @"\U0001F601";
        case 11: return @"\U0001F61C";
        case 12: return @"\U0001F61D";
        case 13: return @"\U0001F612";
        case 14: return @"\U0001F60F";
        case 15: return @"\U0001F613";
        case 16: return @"\U0001F614";
        case 17: return @"\U0001F61E";
        case 18: return @"\U0001F616";
        case 19: return @"\U0001F625";
        case 20: return @"\U0001F630";
        case 21: return @"\U0001F628";
        case 22: return @"\U0001F623";
        case 23: return @"\U0001F622";
        case 24: return @"\U0001F62D";
        case 25: return @"\U0001F602";
        case 26: return @"\U0001F632";
        case 27: return @"\U0001F631";
        case 28: return @"\U0001F620";
        case 29: return @"\U0001F621";
        case 30: return @"\U0001F62A";
        case 31: return @"\U0001F637";
        case 32: return @"\U0001F47F";
        case 33: return @"\U0001F47D";
        case 34: return @"\u2764";
        case 35: return @"\U0001F494";
        case 36: return @"\U0001F498";
        case 37: return @"\u2728";
        case 38: return @"\U0001F31F";
        case 39: return @"\u2755";
        case 40: return @"\u2754";
        case 41: return @"\U0001F4A4";
        case 42: return @"\U0001F4A6";
        case 43: return @"\U0001F3B5";
        case 44: return @"\U0001F525";
        case 45: return @"\U0001F4A9";
        case 46: return @"\U0001F44D";
        case 47: return @"\U0001F44E";
        case 48: return @"\U0001F44C";
        case 49: return @"\U0001F44A";
        case 50: return @"✊";
        case 51: return @"\u270C";
        case 52: return @"\U0001F446";
        case 53: return @"\U0001F447";
        case 54: return @"\U0001F449";
        case 55: return @"\U0001F448";
        case 56: return @"\u261D";
        case 57: return @"\U0001F4AA";
        case 58: return @"\U0001F48F";
        case 59: return @"\U0001F491";
        case 60: return @"\U0001F466";
        case 61: return @"\U0001F467";
        case 62: return @"\U0001F469";
        case 63: return @"\U0001F468";
        case 64: return @"\U0001F47C";
        case 65: return @"\U0001F480";
        case 66: return @"\U0001F48B";
        case 67: return @"\u2600";
        case 68: return @"\u2614";
        case 69: return @"\u2601";
        case 70: return @"\u26C4";
        case 71: return @"\U0001F319";
        case 72: return @"\u26A1";
        case 73: return @"\U0001F30A";
        case 74: return @"\U0001F431";
        case 75: return @"\U0001F436";
        case 76: return @"\U0001F42D";
        case 77: return @"\U0001F439";
        case 78: return @"\U0001F430";
        case 79: return @"\U0001F43A";
        case 80: return @"\U0001F438";
        case 81: return @"\U0001F42F";
        case 82: return @"\U0001F428";
        case 83: return @"\U0001F43B";
        case 84: return @"\U0001F437";
        case 85: return @"\U0001F42E";
        case 86: return @"\U0001F417";
        case 87: return @"\U0001F435";
        case 88: return @"\U0001F412";
        case 89: return @"\U0001F434";
        case 90: return @"\U0001F40D";
        case 91: return @"\U0001F426";
        case 92: return @"\U0001F414";
        case 93: return @"\U0001F427";
        case 94: return @"\U0001F41B";
        case 95: return @"\U0001F419";
        case 96: return @"\U0001F420";
        case 97: return @"\U0001F433";
        case 98: return @"\U0001F42C";
        case 99: return @"\U0001F339";
        case 100: return @"\U0001F33A";
        case 101: return @"\U0001F334";
        case 102: return @"\U0001F335";
        case 103: return @"\U0001F49D";
        case 104: return @"\U0001F383";
        case 105: return @"\U0001F47B";
        case 106: return @"\U0001F385";
        case 107: return @"\U0001F384";
        case 108: return @"\U0001F381";
        case 109: return @"\U0001F514";
        case 110: return @"\U0001F389";
        case 111: return @"\U0001F388";
        case 112: return @"\U0001F4BF";
        case 113: return @"\U0001F4F7";
        case 114: return @"\U0001F3A5";
        case 115: return @"\U0001F4BB";
        case 116: return @"\U0001F4FA";
        case 117: return @"\u260E";
        case 118: return @"\U0001F513";
        case 119: return @"\U0001F512";
        case 120: return @"\U0001F511";
        case 121: return @"\U0001F528";
        case 122: return @"\U0001F4A1";
        case 123: return @"\U0001F4EB";
        case 124: return @"\U0001F6C0";
        case 125: return @"\U0001F4B0";
        case 126: return @"\U0001F4A3";
        case 127: return @"\U0001F52B";
        case 128: return @"\U0001F48A";
        case 129: return @"\U0001F3C8";
        case 130: return @"\U0001F3C0";
        case 131: return @"\u26BD";
        case 132: return @"\u26BE";
        case 133: return @"\U0001F3BE";
        case 134: return @"\U0001F3C6";
        case 135: return @"\U0001F47E";
        case 136: return @"\U0001F3A4";
        case 137: return @"\U0001F3B8";
        case 138: return @"\U0001F459";
        case 139: return @"\U0001F451";
        case 140: return @"\U0001F302";
        case 141: return @"\U0001F45C";
        case 142: return @"\U0001F484";
        case 143: return @"\U0001F48D";
        case 144: return @"\U0001F48E";
        case 145: return @"\u2615";
        case 146: return @"\U0001F37A";
        case 147: return @"\U0001F37B";
        case 148: return @"\U0001F378";
        case 149: return @"\U0001F354";
        case 150: return @"\U0001F35F";
        case 151: return @"\U0001F35D";
        case 152: return @"\U0001F363";
        case 153: return @"\U0001F35C";
        case 154: return @"\U0001F373";
        case 155: return @"\U0001F366";
        case 156: return @"\U0001F382";
        case 157: return @"\U0001F34E";
        case 158: return @"\u2708";
        case 159: return @"\U0001F680";
        case 160: return @"\U0001F6B2";
        case 161: return @"\U0001F684";
        case 162: return @"\u26A0";
        case 163: return @"\U0001F3C1";
        case 164: return @"\U0001F6B9";
        case 165: return @"\U0001F6BA";
        case 166: return @"\u2B55";
        case 167: return @"\u274C";
        case 168: return @"\ue24e";
        case 169: return @"\ue24f";
        case 170: return @"\ue537";
    }
    return @"\ue056";
}


+ (Boolean)isNumberCharaterString:(NSString *)str
{
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm"] invertedSet];
    NSRange foundRange = [str rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location == NSNotFound) {
        NSLog(@"是数字和字母的集合");
        return YES;
    }
    return NO;
}

+ (Boolean)isCharaterString:(NSString *)str
{
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm"] invertedSet];
    NSRange foundRange = [str rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location == NSNotFound) {
        NSLog(@"字母的集合");
        return YES;
    }
    return NO;
}

+ (Boolean)isNumberString:(NSString *)str
{
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSRange foundRange = [str rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location == NSNotFound) {
        NSLog(@"是数字集合");
        return YES;
    }
    return NO;
}

+ (Boolean)hasillegalString:(NSString *)str
{
    if ( str.length == 0 )  //目前允许是空
    {
        return NO;
    }
    
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"/／!！@@#＃$￥%^……&&*＊(（)）——_++|“”:：｛{}｝《<>》?？~～、-；;"] invertedSet];
    NSRange foundRange = [str rangeOfCharacterFromSet:disallowedCharacters];
    
    NSLog( @"%@", str );
    
    if (foundRange.location == NSNotFound)
    {
        NSLog(@"含有非法字符");
        return YES;
    }
    
    return NO;
}

+ (Boolean)isValidSmsString:(NSString *)str
{
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789+"] invertedSet];
    NSRange foundRange = [str rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location == NSNotFound) {
        NSLog(@"是数字集合");
        return YES;
    }
    return NO;
}
+ (EImageType)getImageTypeByData:(NSData *)imageData
{
    unsigned char imageHeadBytes[8];
    [imageData getBytes:imageHeadBytes length:8];
    NSLog(@"%d", (int)imageHeadBytes[0]);
    NSLog(@"%d", (int)imageHeadBytes[1]);
    NSLog(@"%d", (int)imageHeadBytes[2]);
    NSLog(@"%d", (int)imageHeadBytes[3]);
    
    if(imageHeadBytes[0] == 0xFF)
    {
        
        if(imageHeadBytes[1] == 0xD8)
            return EImageJPG;
    }
    else if(imageHeadBytes[0] == 0x47)
    {
        if(imageHeadBytes[1] == 0x49
           && imageHeadBytes[2] == 0x46
           && imageHeadBytes[3] == 0x38
           && (imageHeadBytes[4] == 0x37 || imageHeadBytes[4] == 0x39)
           && imageHeadBytes[5] == 0x61
           )
            return EImageGIF;
    }
    else if(imageHeadBytes[0] == 0x42)
    {
        if(imageHeadBytes[1] == 0x4D)
            return EImageBMP;
    }
    else if(imageHeadBytes[0] == 0x89)
    {
        if(imageHeadBytes[1] == 0x50
           && imageHeadBytes[2] == 0x4E
           && imageHeadBytes[3] == 0x47
           && imageHeadBytes[4] == 0x0D
           && imageHeadBytes[5] == 0x0A
           && imageHeadBytes[6] == 0x1A
           && imageHeadBytes[7] == 0x0A
           )
            return EImagePNG;
    }
    
    return EImageInvalidType;
}
+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
        return NO;
    @try
    {
        NSData *imageData = nil;
        NSString *ext = [aPath pathExtension];
        if ([ext isEqualToString:@"png"])
        {
            // the rest, we write to jpeg
            // 0. best, 1. lost. about compress.
            imageData = UIImagePNGRepresentation(image);
        }
        else
        {
            imageData = UIImageJPEGRepresentation (image, 0.7);
        }
        if ((imageData == nil) || ([imageData length] <= 0))
            return NO;
        [imageData writeToFile:aPath atomically:YES];
        return YES;
    }
    @catch (NSException *e)
    
    {
        NSLog(@"create thumbnail exception.");
    }
    return NO;
}
+ (UIImage *)compressImage:(UIImage *)image withSize:(CGSize)viewsize
{
    CGFloat imgHWScale = image.size.height/image.size.width;
    CGFloat viewHWScale = viewsize.height/viewsize.width;
    CGRect rect = CGRectZero;
    if (imgHWScale>viewHWScale)
    {
        rect.size.height = viewsize.width*imgHWScale;
        rect.size.width = viewsize.width;
        rect.origin.x = 0.0f;
        rect.origin.y =  (viewsize.height - rect.size.height)*0.5f;
    }
    else
    {
        CGFloat imgWHScale = image.size.width/image.size.height;
        rect.size.width = viewsize.height*imgWHScale;
        rect.size.height = viewsize.height;
        rect.origin.y = 0.0f;
        rect.origin.x = (viewsize.width - rect.size.width)*0.5f;
    }
    
	UIGraphicsBeginImageContext(viewsize);
	[image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newimg;
}

+(BOOL)verifyEmail:(NSString*)email
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z0-9._%+-]+@[A-Za-z0-9._%+-]+\\.[A-Za-z0-9._%+-]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSInteger numberOfMatches = [regex numberOfMatchesInString:email options:0 range:NSMakeRange(0, [email length])];
    if (numberOfMatches != 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)verifyPhone:(NSString*)phone
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{3,}" options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    
    NSInteger numberOfMatches = [regex numberOfMatchesInString:phone options:0 range:NSMakeRange(0, [phone length])];
    if (numberOfMatches != 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)verifyMobilePhone:(NSString*)phone
{
    NSString *regex = @"1[0-9]{10}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:phone] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)getTimeString:(NSInteger)duration
{
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSInteger second = 0;
    
    hour = duration / 3600;
    minute = duration % 3600 / 60;
    second = duration % 3600 % 60;
    
    NSString *dateStr = nil;
    
    if ( hour > 0 )
    {
        dateStr = [NSString stringWithFormat:@"%02d小时%02d分%02d秒", (int)hour, (int)minute, (int)second];
    }
    else if ( minute > 0 )
    {
        dateStr = [NSString stringWithFormat:@"%02d分%02d秒", (int)minute, (int)second];
    }
    else
    {
        dateStr = [NSString stringWithFormat:@"%02d秒", (int)second];
    }
    
    return dateStr;
}

+ (NSString *)cleanPhone:(NSString *)beforeClean
{
    if ([beforeClean hasPrefix:@"+86"])
    {
        return [beforeClean substringFromIndex:3];
    }
    else if ([beforeClean hasPrefix:@"0086"])
    {
        return [beforeClean substringFromIndex:4];
    }
    else
        return beforeClean;
}


+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
@end