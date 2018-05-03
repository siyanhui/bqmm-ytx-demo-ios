# 说明：
- 本Demo使用的是 版本号为v5.3r 云通讯官方IMDemo
- 下载Demo后解压/bqmm-ytx-demo-ios/ECSDKDemo_OC/ECSDKDemo_OC/Yuntx_IMLib_SDK下的`lib.zip`
- 将appDelegate中[[MMEmotionCentre defaultCentre] setAppId:@“your app id” secret:@“your secret”]设置成分配到的`id`和`secret`。
- 本Demo在云通讯官方Demo的基础上集成了BQMM2.1,在修改的地方我们都加上了“BQMM集成"的注释，可在项目中全局搜索查看。


# 表情云SDK接入文档

接入**SDK**，有以下必要步骤：

1. 下载与安装
2. 获取必要的接入信息  
3. 开始集成  

##第一步：下载与安装

目前有两种方式安装SDK：

* 通过`CocoaPods`管理依赖。
* 手动导入`SDK`并管理依赖。

###1. 使用 CocoaPods 导入SDK

在终端中运行以下命令：

```
pod search BQMM
```

如果运行以上命令，没有搜到SDK，或者搜不到最新的 SDK 版本，您可以运行以下命令，更新您本地的 CocoaPods 源列表。

```
pod repo update
```

在您工程的 Podfile中添加最新版本的SDK（在此以2.1版本为例）：

```
pod 'BQMM', '2.1'
```

然后在工程的根目录下运行以下命令：

```
pod install
```

说明：pod中不包含gif表情的UI模块，可在官网[下载](http://7xl6jm.com2.z0.glb.qiniucdn.com/release/android-sdk/BQMM_Lib_V2.0.zip)，手动导入`BQMM_GIF`


###2. 手动导入SDK

下载当前最新版本，解压缩后获得3个文件夹

* `BQMM`
* `BQMM_EXT`
* `BQMM_GIF`

`BQMM`中包含SDK所需的资源文件`BQMM.bundle`和库文件`BQMM.framework`;`BQMM_EXT`提供了SDK的默认消息显示控件和消息默认格式的开源代码，开发者们导入后可按需修改;`BQMM_GIF`中包含gif表情的UI模块，开发者导入后可按需修改。

###3. 添加系统库依赖

您除了在工程中导入 SDK 之外，还需要添加libz动态链接库。


##第二步：获取必要的接入信息

开发者将应用与SDK进行对接时,必要接入信息如下

* `appId` - 应用的App ID
* `appSecret` - 应用的App Secret


如您暂未获得以上接入信息，可以在此[申请](http://open.biaoqingmm.com/open/register/index.html)


##第三步：开始集成

###0. 注册AppId&AppSecret、设置SDK语言和区域

在 `AppDelegate` 的 `-application:didFinishLaunchingWithOptions:` 中添加：

```objectivec
// 初始化SDK
[[MMEmotionCentre defaultCentre] setAppId:@“your app id” secret:@“your secret”]

//设置SDK语言和区域
[MMEmotionCentre defaultCentre].sdkLanguage = MMLanguageEnglish;
[MMEmotionCentre defaultCentre].sdkRegion = MMRegionChina;

```

###1. 在App重新打开时清空session

在 `AppDelegate` 的 `- (void)applicationWillEnterForeground:` 中添加：

```objectivec
[[MMEmotionCentre defaultCentre] clearSession];
```

###2. 使用表情键盘和GIF搜索模块

####设置SDK代理 

`ChatViewController`
```objectivec
-(void)viewWillAppear:(BOOL)animated {
    ....
    //BQMM集成
    [MMEmotionCentre defaultCentre].delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
	...
	[MMEmotionCentre defaultCentre].delegate = nil;
}
```



####配置GIF搜索模块

`ChatViewController`
```objectivec
-(void)viewDidLoad {
    ....
    //BQMM集成   设置gif搜索相关
    [[MMGifManager defaultManager] setSearchModeEnabled:true withInputView:_inputTextView.internalTextView];
    [[MMGifManager defaultManager] setSearchUiVisible:true withAttatchedView:_inputTextView];
    __weak typeof(self) weakSelf = self;
    [MMGifManager defaultManager].selectedHandler = ^(MMGif * _Nullable gif) {
        __strong typeof(weakSelf) tempSelf = weakSelf;
        if (tempSelf) {
            [tempSelf didSendGifMessage:gif];
        }
    };
}

-(void)didSendGifMessage:(MMGif *)gif {
    NSDictionary *msgData = @{WEBSTICKER_URL: gif.mainImage, WEBSTICKER_IS_GIF: (gif.isAnimated ? @"1" : @"0"), WEBSTICKER_ID: gif.imageId,WEBSTICKER_WIDTH: @((float)gif.size.width), WEBSTICKER_HEIGHT: @((float)gif.size.height)};
    NSDictionary *extDic = @{TEXT_MESG_TYPE:TEXT_MESG_WEB_TYPE,
                             TEXT_MESG_DATA:msgData
                             };
    NSString *extString = nil;
    if (extDic) {
        NSError *parseError = nil;
        NSData  *extData = [NSJSONSerialization dataWithJSONObject:extDic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError];
        extString = [[NSString alloc] initWithData:extData encoding:NSUTF8StringEncoding];
        extString = [extString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    NSString *sendStr = [@"[" stringByAppendingFormat:@"%@]", gif.text];
    ECMessage* message;
    message = [[DeviceChatHelper sharedInstance] sendTextMessage:sendStr to:self.sessionId withUserData:extString atArray:nil];
    [[DemoGlobalClass sharedInstance].AtPersonArray removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onMesssageChanged object:message];
}
```

####实现SDK代理方法

`ChatViewController` 实现了SDK的代理方法

```objectivec
//点击键盘中大表情的代理
- (void)didSelectEmoji:(MMEmoji *)emoji
{
    [self sendMMFace:emoji];
}

//点击联想表情的代理 （`deprecated`）
- (void)didSelectTipEmoji:(MMEmoji *)emoji
{
    [self sendMMFace:emoji];
    _inputTextView.text = @"";
}

//点击小表情键盘上发送按钮的代理
- (void)didSendWithInput:(UIResponder<UITextInput> *)input
{
    [self sendTextMessage];
    _inputTextView.text = @"";
}

//点击输入框切换表情按钮状态
- (void)tapOverlay
{
    toolbarDisplay = ToolbarDisplay_None;
    [_switchVoiceBtn setImage:[UIImage imageNamed:@"voice_icon"] forState:UIControlStateNormal];
    [_switchVoiceBtn setImage:[UIImage imageNamed:@"voice_icon_on"] forState:UIControlStateHighlighted];
    [_emojiBtn setImage:[UIImage imageNamed:@"facial_expression_icon"] forState:UIControlStateNormal];
    [_emojiBtn setImage:[UIImage imageNamed:@"facial_expression_icon_on"] forState:UIControlStateHighlighted];
}

//点击gifTab
- (void)didClickGifTab {
    toolbarDisplay = ToolbarDisplay_None;
    [_switchVoiceBtn setImage:[UIImage imageNamed:@"voice_icon"] forState:UIControlStateNormal];
    [_switchVoiceBtn setImage:[UIImage imageNamed:@"voice_icon_on"] forState:UIControlStateHighlighted];
    [_emojiBtn setImage:[UIImage imageNamed:@"facial_expression_icon"] forState:UIControlStateNormal];
    [_emojiBtn setImage:[UIImage imageNamed:@"facial_expression_icon_on"] forState:UIControlStateHighlighted];
    //点击gif tab 后应该保证搜索模式是打开的 搜索UI是允许显示的
    [[MMGifManager defaultManager] setSearchModeEnabled:true withInputView:_inputTextView.internalTextView];
    [[MMGifManager defaultManager] setSearchUiVisible:true withAttatchedView:_inputTextView];
    [[MMGifManager defaultManager] showTrending];
}

```

####表情键盘和普通键盘的切换

`ChatViewController`

```objectivec
-(void)switchToolbarDisplay:(id)sender {
    ...
    if (toolbarDisplay == button.tag) {
        toolbarDisplay = ToolbarDisplay_None;
        [_inputTextView becomeFirstResponder];
        //切换成系统键盘
        [[MMEmotionCentre defaultCentre] switchToDefaultKeyboard];
        ...
    }else{
        CGFloat framey = self.view.frame.size.height-ToolbarInputViewHeight;
        switch (button.tag) {
            ... 
            case ToolbarDisplay_Emoji:
            {
                framey = viewHeight-_containerView.frame.size.height-93.0f-ToolbarInputViewHeight;
                _inputTextView.selectedRange = NSMakeRange(_inputTextView.text.length,0);
                //切换成表情键盘
                [[MMEmotionCentre defaultCentre] attachEmotionKeyboardToInput:_inputTextView.internalTextView];
                [_inputTextView becomeFirstResponder];
                [_switchVoiceBtn setImage:[UIImage imageNamed:@"voice_icon"] forState:UIControlStateNormal];
                [_switchVoiceBtn setImage:[UIImage imageNamed:@"voice_icon_on"] forState:UIControlStateHighlighted];
                [_emojiBtn setImage:[UIImage imageNamed:@"keyboard_icon"] forState:UIControlStateNormal];
                [_emojiBtn setImage:[UIImage imageNamed:@"keyboard_icon_on"] forState:UIControlStateHighlighted];
                toolbarDisplay = (ToolbarDisplay)button.tag;
                return; //现在的表情键盘是完全依附在键盘上的，所以布局的逻辑不需要再走
            }
                
            ...
                
        }
        ...
    }
}
```


###3. 使用表情消息编辑控件
SDK提供`UITextView+BQMM`作为表情编辑控件的扩展实现，可以以图文混排方式编辑，并提取编辑内容。
消息编辑框需要使用此控件，在适当位置引入头文件 

```objectivec
#import <BQMM/BQMM.h>
```

###4.消息的编码及发送

表情相关的消息需要编码成`extData`放入IM的普通文字消息的扩展字段，发送到接收方进行解析。
`extData`是SDK推荐的用于解析的表情消息发送格式，格式是一个二维数组，内容为拆分完成的`text`和`emojiCode`，并且说明这段内容是否是一个`emojiCode`。

#####图文混排消息
`ChatViewController`
```objectivec
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self sendTextMessage];
        growingTextView.text = @"";
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    ...
}

-(void)sendTextMessage {
    ...
    NSString *sendStr = _inputTextView.internalTextView.characterMMText;
    NSArray *textImgArray = _inputTextView.internalTextView.textImgArray;
    NSDictionary *mmExt = @{@"txt_msgType":@"emojitype",
                            @"msg_data":[MMTextParser extDataWithTextImageArray:textImgArray]};;
    if (sendStr.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"不能发送空白消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    

    NSString *extString = nil;
    if (mmExt) {
        NSError *parseError = nil;
        NSData  *extData = [NSJSONSerialization dataWithJSONObject:mmExt
                                                           options:NSJSONWritingPrettyPrinted error:&parseError];
        extString = [[NSString alloc] initWithData:extData encoding:NSUTF8StringEncoding];
        extString = [extString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    ECMessage* message;
    if ([self.sessionId hasPrefix:@"g"] && [sendStr myContainsString:_deleteAtStr]) {
        NSMutableArray *personArray = [DemoGlobalClass sharedInstance].AtPersonArray;
        NSArray *array = [sendStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"@%@",_deleteAtStr]]];
        for (NSString *str in array) {
            NSArray *bookArray = [DemoGlobalClass sharedInstance].groupMemberArray;
            for (AddressBook *book in bookArray) {
                if ([str isEqualToString:book.name]) {
                    [personArray addObject:book.phones.allValues.firstObject];
                    NSSet *set = [NSSet setWithArray:personArray];
                    personArray = [NSMutableArray arrayWithObject:set.allObjects];
                }
            }
        }
        message = [[DeviceChatHelper sharedInstance] sendTextMessage:sendStr to:self.sessionId withUserData:extString atArray:personArray];
    } else {
        message = [[DeviceChatHelper sharedInstance] sendTextMessage:sendStr to:self.sessionId withUserData:extString atArray:nil];
    }
    ...
}
```

#####大表情消息

`ChatViewController`
```objectivec
-(void)sendMMFace:(MMEmoji *)emoji 
{
    NSDictionary *mmExt = @{@"txt_msgType":@"facetype",
                            @"msg_data":@[@[emoji.emojiCode, [NSString stringWithFormat:@"%d", emoji.isEmoji ? 1 : 2]]]};
    NSString *extString = nil;
    if (mmExt) {
        NSError *parseError = nil;
        NSData  *extData = [NSJSONSerialization dataWithJSONObject:mmExt
                                                           options:NSJSONWritingPrettyPrinted error:&parseError];
        extString = [[NSString alloc] initWithData:extData encoding:NSUTF8StringEncoding];
        extString = [extString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    NSString *sendStr = [NSString stringWithFormat:@"[%@]", emoji.emojiName];
    ECMessage* message;
    message = [[DeviceChatHelper sharedInstance] sendTextMessage:sendStr to:self.sessionId withUserData:extString atArray:nil];
    ...
}
```

#####Gif表情消息

`ChatViewController`
```objectivec
-(void)didSendGifMessage:(MMGif *)gif {
    NSDictionary *msgData = @{WEBSTICKER_URL: gif.mainImage, WEBSTICKER_IS_GIF: (gif.isAnimated ? @"1" : @"0"), WEBSTICKER_ID: gif.imageId,WEBSTICKER_WIDTH: @((float)gif.size.width), WEBSTICKER_HEIGHT: @((float)gif.size.height)};
    NSDictionary *extDic = @{TEXT_MESG_TYPE:TEXT_MESG_WEB_TYPE,
                             TEXT_MESG_DATA:msgData
                             };
    NSString *extString = nil;
    if (extDic) {
        NSError *parseError = nil;
        NSData  *extData = [NSJSONSerialization dataWithJSONObject:extDic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError];
        extString = [[NSString alloc] initWithData:extData encoding:NSUTF8StringEncoding];
        extString = [extString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    NSString *sendStr = [@"[" stringByAppendingFormat:@"%@]", gif.text];
    ECMessage* message;
    message = [[DeviceChatHelper sharedInstance] sendTextMessage:sendStr to:self.sessionId withUserData:extString atArray:nil];
    ...
}
```


###5. 表情消息的解析

消息的扩展解析
```objectivec
NSString *extString = message.userData;
NSDictionary *extDic = nil;
if (extString != nil) {
    NSData *extData = [extString dataUsingEncoding:NSUTF8StringEncoding];
    extDic = [NSJSONSerialization JSONObjectWithData:extData options:NSJSONReadingMutableLeaves error:nil];
}
```


#### 混排消息的解析

从消息的扩展中解析出`extData`
```objectivec
NSString *extString = message.userData;
NSDictionary *extDic = nil;
if (extString != nil) {
    NSData *extData = [extString dataUsingEncoding:NSUTF8StringEncoding];
    extDic = [NSJSONSerialization JSONObjectWithData:extData options:NSJSONReadingMutableLeaves error:nil];

    if (extDic != nil && [extDic[@"txt_msgType"] isEqualToString:@"emojitype"]) {
    	NSArray *extData = extDic[@"msg_data"];
	}
}
```

#### 单个大表情解析

从消息的扩展中解析出大表情（MMEmoji）的emojiCode

`ChatViewImageCell`
```objectivec
- (void)setdata:(ECMessage *)message {
	...
    //解析消息扩展
    NSString *extString = message.userData;
    NSDictionary *extDic = nil;
    if (extString != nil) {
        NSData *extData = [extString dataUsingEncoding:NSUTF8StringEncoding];
        extDic = [NSJSONSerialization JSONObjectWithData:extData options:NSJSONReadingMutableLeaves error:nil];
    }
    if (extDic != nil && [extDic[@"txt_msgType"] isEqualToString: @"facetype"]) { //大表情消息
        self.bubleimg.hidden = YES;
        [self getImageWithwidth:120 andgetImageWithhight:120];
        _displayImage.image = [UIImage imageNamed:@"mm_emoji_loading"];
        
        NSString *emojiCode = nil;
        if (extDic[TEXT_MESG_DATA]) {
            emojiCode = extDic[TEXT_MESG_DATA][0][0];
        }
        ...
    }
    ...
}
```

#### Gif表情解析

从消息的扩展中解析出Gif表情（MMGif）的imageId和mainImage

`ChatViewImageCell`
```objectivec
- (void)setdata:(ECMessage *)message {
	...
    //解析消息扩展
    NSString *extString = message.userData;
    NSDictionary *extDic = nil;
    if (extString != nil) {
        NSData *extData = [extString dataUsingEncoding:NSUTF8StringEncoding];
        extDic = [NSJSONSerialization JSONObjectWithData:extData options:NSJSONReadingMutableLeaves error:nil];
    }
    ...
    else if (extDic != nil && [extDic[@"txt_msgType"] isEqualToString: @"webtype"]) { //gif消息
        ...
        NSDictionary *msgData = extDic[@"msg_data"];
        NSString *webStickerUrl = msgData[WEBSTICKER_URL];
        NSString *webStickerId = msgData[WEBSTICKER_ID];
        ...
    }
    ...
}
```


###6. 表情消息显示

#### 混排消息
SDK提供`MMTextView`作为显示图文混排表情消息的展示
`ChatViewTextCell`
```objectivec
@implementation ChatViewTextCell
{
    UILabel *_label;
    MMTextView *_textView; //BQMM集成
}

...
_textView = [[MMTextView alloc] initWithFrame:CGRectMake(5.0f, 2.0f, self.bubbleView.frame.size.width-15.0f, 
														self.bubbleView.frame.size.height-6.0f)];
...
```

设置数据：
`ChatViewTextCell`
```objectivec
[_textView setMmTextData:extDic[@"msg_data"]];
```

布局：
`ChatViewTextCell`
```objectivec
-(void)layoutSubviews{
	...
    //解析消息扩展
    NSString *extString = self.displayMessage.userData;
    NSDictionary *extDic = nil;
    if (extString != nil) {
        NSData *extData = [extString dataUsingEncoding:NSUTF8StringEncoding];
        extDic = [NSJSONSerialization JSONObjectWithData:extData options:NSJSONReadingMutableLeaves error:nil];
    }
    CGSize contentSize = CGSizeZero;
    if (extDic != nil && [extDic[@"txt_msgType"] isEqualToString: @"emojitype"]) { //混排消息
        contentSize = [MMTextParser sizeForMMTextWithExtData:extDic[@"msg_data"] font:LabelFont maximumTextWidth:BubbleMaxSize.width];
        [_textView setMmTextData:extDic[@"msg_data"]];
    }else{
        contentSize = [MMTextParser sizeForTextWithText:body.text font:LabelFont maximumTextWidth:BubbleMaxSize.width];
    }
    
    if (contentSize.height<40.0f) {
        contentSize.height=40.0f;
    }
    
    [_textView setURLAttributes];
	...
    
    [super updateMessageSendStatus:self.displayMessage.messageState];
}
```

复制消息内容：
`ChatViewController`
```objectivec
- (void)copyMenuAction:(id)sender {
    [_menuController setMenuItems:nil];
    //复制
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_longPressIndexPath.row < self.messageArray.count) {
        ECMessage *message = [self.messageArray objectAtIndex:_longPressIndexPath.row];
        ECTextMessageBody *body = (ECTextMessageBody*)message.messageBody;
        //BQMM集成
        NSString *extString = message.userData;
        NSDictionary *extDic = nil;
        if (extString != nil) {
            NSData *extData = [extString dataUsingEncoding:NSUTF8StringEncoding];
            extDic = [NSJSONSerialization JSONObjectWithData:extData options:NSJSONReadingMutableLeaves error:nil];
        }
        if (extDic != nil && [extDic[@"txt_msgType"] isEqualToString:@"emojitype"]) {
            pasteboard.string = [MMTextParser stringWithExtData:extDic[@"msg_data"]];
        }else{
            pasteboard.string = body.text;
        }
    }
    _longPressIndexPath = nil;
}
```

另外，开发者可参照`MMTextView`中的`updateAttributeTextWithData:completionHandler:`方法定义自己的表情消息显示方式。参数<a name="extData">`extData`</a>是拆分过的文本和`emojiCode`。


#### 大表情消息 && gif表情消息
SDK 提供 `MMImageView` 来显示单个大表情及gif表情

`ChatViewImageCell`中的`UIImageView`相应的改成了`MMImageView`

`ChatViewImageCell`
```objectivec
- (void)setdata:(ECMessage *)message 
{
	...
	//解析消息扩展
    NSString *extString = message.userData;
    NSDictionary *extDic = nil;
    if (extString != nil) {
        NSData *extData = [extString dataUsingEncoding:NSUTF8StringEncoding];
        extDic = [NSJSONSerialization JSONObjectWithData:extData options:NSJSONReadingMutableLeaves error:nil];
    }
    if (extDic != nil && [extDic[@"txt_msgType"] isEqualToString: @"facetype"]) { //大表情消息
        self.bubleimg.hidden = YES;
        [self getImageWithwidth:120 andgetImageWithhight:120];
        _displayImage.image = [UIImage imageNamed:@"mm_emoji_loading"];
        
        NSString *emojiCode = nil;
        if (extDic[TEXT_MESG_DATA]) {
            emojiCode = extDic[TEXT_MESG_DATA][0][0];
        }
        
        if (emojiCode != nil && emojiCode.length > 0) {
            _displayImage.errorImage = [UIImage imageNamed:@"mm_emoji_error"];
            _displayImage.image = [UIImage imageNamed:@"mm_emoji_loading"];
            [_displayImage setImageWithEmojiCode:emojiCode];
        }else {
            _displayImage.image = [UIImage imageNamed:@"mm_emoji_error"];
        }
        return;
    }else if (extDic != nil && [extDic[@"txt_msgType"] isEqualToString: @"webtype"]) { //gif消息
        _displayImage.image = [UIImage imageNamed:@"mm_emoji_loading"];
        _displayImage.errorImage = [UIImage imageNamed:@"mm_emoji_error"];
        NSDictionary *msgData = extDic[@"msg_data"];
        NSString *webStickerUrl = msgData[WEBSTICKER_URL];
        NSString *webStickerId = msgData[WEBSTICKER_ID];
        
        
        float height = [msgData[WEBSTICKER_HEIGHT] floatValue];
        float width = [msgData[WEBSTICKER_WIDTH] floatValue];
        [self getImageWithwidth:width andgetImageWithhight:height];
        
        [_displayImage setImageWithUrl:webStickerUrl gifId:webStickerId];
        return;
    }
	...
}
```

布局：
`ChatViewImageCell`
```objectivec
-(void)getImageWithwidth:(CGFloat)width andgetImageWithhight:(CGFloat)height {
    if (width > 200) {
        height = 200.0 / width * height;
        width = 200;
    }
    
    if(height > 150) {
        width = 150.0 / height * width;
        height = 150;
    }
    
	...
    if (self.isSender) {
        _displayImage.frame = CGRectMake(5, 5, width, height);
        self.bubbleView.frame = CGRectMake(self.portraitImg.frame.origin.x-width-30, self.portraitImg.frame.origin.y, width+20, height+10);
        
    } else {
        _displayImage.frame = CGRectMake(15, 5, width, height);
        
        CGFloat imageFrameY = self.portraitImg.frame.origin.y;
        self.bubbleView.frame = CGRectMake(self.portraitImg.frame.origin.x+10.0f+self.portraitImg.frame.size.width, imageFrameY, width+20, height+10);
    }
    
    ECMessage *message = self.displayMessage;
    ECImageMessageBody *mediaBody = (ECImageMessageBody*)message.messageBody;
	...
    [super updateMessageSendStatus:self.displayMessage.messageState];
}
```


###7. demo中的其他修改
0. 相应的类中引用头文件。

1. `MainViewController` 设置 navigationBar
```objectivec
self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
```

2. 布局相关
```objectivec
//ChatViewTextCell 计算消息cell的高度
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

//ChatViewImageCell 计算消息cell的高度
+(CGFloat)getHightOfCellViewWithMessage:(ECMessage *)message {
    NSString *extString = message.userData;
    NSDictionary *extDic = nil;
    if (extString != nil) {
        NSData *extData = [extString dataUsingEncoding:NSUTF8StringEncoding];
        extDic = [NSJSONSerialization JSONObjectWithData:extData options:NSJSONReadingMutableLeaves error:nil];
    }
    if (extDic != nil && [extDic[@"txt_msgType"] isEqualToString: @"webtype"]) {
        NSDictionary *msgData = extDic[TEXT_MESG_DATA];
        float height = [msgData[WEBSTICKER_HEIGHT] floatValue];
        float width = [msgData[WEBSTICKER_WIDTH] floatValue];
        //宽最大200 高最大 150
        if (width > 200) {
            height = 200.0 / width * height;
            width = 200;
        }
        
        if(height > 150) {
            width = 150.0 / height * width;
            height = 150;
        }
        return height + 30;
    }
    return 150.0f;
}
```

3. 输入框结束编辑，恢复初始状态

`ChatViewController`
```objectivec
//BQMM集成
-(void)endEditing {
    [self.view endEditing:YES];
    toolbarDisplay = ToolbarDisplay_None;
    [_switchVoiceBtn setImage:[UIImage imageNamed:@"voice_icon"] forState:UIControlStateNormal];
    [_switchVoiceBtn setImage:[UIImage imageNamed:@"voice_icon_on"] forState:UIControlStateHighlighted];
    [_emojiBtn setImage:[UIImage imageNamed:@"facial_expression_icon"] forState:UIControlStateNormal];
    [_emojiBtn setImage:[UIImage imageNamed:@"facial_expression_icon_on"] forState:UIControlStateHighlighted];
}
```


###8. gif搜索模块UI定制

`BQMM_GIF`是一整套gif搜索UI模块的实现源码，可用于直接使用或用于参考实现gif搜索，及gif消息的发送解析。
####gif搜索源码说明
gif相关的功能由`MMGifManager`集中管理:

1.设置搜索模式的开启和关闭；指定输入控件
```objectivec
- (void)setSearchModeEnabled:(BOOL)enabled withInputView:(UIResponder<UITextInput> *_Nullable)input;
```

2.设置是否显示搜索出的表情内容；指定表情内容的显示位置
```objectivec
- (void)setSearchUiVisible:(BOOL)visible withAttatchedView:(UIView *_Nullable)attachedView;
```

3.通过`MMSearchModeStatus`管理搜索模式的开启和关闭及搜索内容的展示和收起（MMSearchModeStatus可自由调整）
```objectivec
typedef NS_OPTIONS (NSInteger, MMSearchModeStatus) {
    MMSearchModeStatusKeyboardHide = 1 << 0,         //收起键盘
    MMSearchModeStatusInputEndEditing = 1 << 1,         //收起键盘
    MMSearchModeStatusInputBecomeEmpty = 1 << 2,     //输入框清空
    MMSearchModeStatusInputTextChange = 1 << 3,      //输入框内容变化
    MMSearchModeStatusGifMessageSent = 1 << 4,       //发送了gif消息
    MMSearchModeStatusShowTrendingTriggered = 1 << 5,//触发流行表情
    MMSearchModeStatusGifsDataReceivedWithResult = 1 << 6,     //收到gif数据
    MMSearchModeStatusGifsDataReceivedWithEmptyResult = 1 << 7,     //搜索结果为空
};
- (void)updateSearchModeAndSearchUIWithStatus:(MMSearchModeStatus)status;
```

###9. UI定制

 SDK通过`MMTheme`提供一定程度的UI定制。具体参考类说明[MMTheme](../class_reference/README.md)。

创建一个`MMTheme`对象，设置相关属性， 然后[[MMEmotionCentre defaultCentre] setTheme:]即可修改商店和键盘样式。


###10. 清除缓存

调用`clearCache`方法清除缓存，此操作会删除所有临时的表情缓存，已下载的表情包不会被删除。建议在`- (void)applicationWillTerminate:(UIApplication *)application `方法中调用。

###11. 设置APP UserId

开发者可以用`setUserId`方法设置App UserId，以便在后台统计时跟踪追溯单个用户的表情使用情况。

