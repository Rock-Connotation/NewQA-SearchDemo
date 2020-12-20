//
//  ReleaseDynamicCV.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/8.
//

#import <Masonry.h>
#import "ReleaseDynamicCV.h"
#import "RelaeseDynamicView.h"              //界面
@interface ReleaseDynamicCV ()<UITextViewDelegate>
@property (nonatomic, strong) RelaeseDynamicView *releaseDynamicView;

@end

@implementation ReleaseDynamicCV
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:226/255.0 green:232/255.0 blue:238/255.0 alpha:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //添加主页面
    self.releaseDynamicView = [[RelaeseDynamicView alloc] init];
    self.releaseDynamicView.frame = self.view.frame;
    [self.view addSubview:self.releaseDynamicView];
        //设置TextView的代理
    self.releaseDynamicView.releaseTextView.delegate = self;
}

/// 添加照片的collectionView
- (void)addPhotoCollectionView{
    
}

#pragma mark- UITextView代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];  //键盘的输入模式
    //当输入模式为简体中文时，进行限制字数
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectRange = [textView markedTextRange];
            //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectRange.start offset:0];
            //没有高亮选择的字，就对已经输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 500) {
                //此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
                NSRange finalRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 500)];
                textView.text = [toBeString substringWithRange:finalRange];

                /*
                 也可以直接使用以下方法显示最后的文本，但是这样可能会遇到emoji无法正常显示的问题.旧版邮问就有这样的问题
                 textField.text = [toBeString substringToIndex:MastNumber];
                 */
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    //中文输入法以外就直接进行统计限制
    else{
        if (toBeString.length > 500) {
            NSRange finalRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 500)];
            textView.text = [toBeString substringWithRange:finalRange];
        }
    }
    //实时统计字数
    self.releaseDynamicView.numberOfTextLbl.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)textView.text.length, 500];
    
    //如果有文字则按钮可以使用，否则就是禁用
    if (toBeString.length > 0) {
        self.releaseDynamicView.releaseBtn.enabled = YES;
    }else{
        self.releaseDynamicView.releaseBtn.enabled = NO;
    }
    return YES;
}

@end
