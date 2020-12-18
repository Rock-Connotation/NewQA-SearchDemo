//
//  ViewController.m
//  输入框限制字数及实时统计字数
//
//  Created by 石子涵 on 2020/12/18.
//

#import "ViewController.h"

static const int  MastNumber = 100;          //限制的最大输入字数
@interface ViewController ()<UITextFieldDelegate,UITextViewDelegate>

/// 文本输入框
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UITextView *textView;

/// 显示输入框内字数的label
@property (nonatomic, strong) UILabel *stringNumberLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加文本输入框
    [self addTextfieldAndLabel];
}

/// 添加文本输入框和实时字数的label
- (void)addTextfieldAndLabel{
//    //文本输入框
//    self.textField = [[UITextField alloc] init];
//    self.textField.frame = CGRectMake(50, 50, 300, 200);
//    self.textField.backgroundColor = [UIColor redColor];
//    [self.textField addTarget:self action:@selector(textFielEditChanged:) forControlEvents:UIControlEventEditingChanged];
//    [self.view addSubview:self.textField];
    //使用UITextView为文本输入框
    self.textView = [[UITextView alloc] init];
    self.textView.frame = CGRectMake(50, 50, 300, 300);
    
    
    //显示实时字数的label
    self.stringNumberLabel = [[UILabel alloc] init];
    self.stringNumberLabel.text = [NSString stringWithFormat:@"0/%d",MastNumber];
    self.stringNumberLabel.textAlignment = NSTextAlignmentRight;
    self.stringNumberLabel.frame = CGRectMake(250, 150, 50, 50);
    self.stringNumberLabel.backgroundColor = [UIColor blackColor];
    self.stringNumberLabel.textColor = [UIColor whiteColor];
//    [self.textField addSubview:self.stringNumberLabel];
    [self.textView addSubview:_stringNumberLabel];
    self.textView.backgroundColor = [UIColor redColor];
//    [self.textView addTarget:self action:@selector(textViewEditChanged:) forControlEvents:UIControlEventEditingChanged];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:self.textView];
}

#pragma mark- UITextViewDelegate
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
            if (toBeString.length > MastNumber) {
                //此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
                NSRange finalRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MastNumber)];
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
        if (toBeString.length > MastNumber) {
            NSRange finalRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MastNumber)];
            textView.text = [toBeString substringWithRange:finalRange];
        }
    }
    //实时统计字数
    self.stringNumberLabel.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)textView.text.length, MastNumber];
    return YES;
}


//- (void)textFielEditChanged:(UITextField *)textField{
//    NSString *toBeString = textField.text;                          //输入的文本内容
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];  //键盘的输入模式
//    //当输入模式为简体中文时，进行限制字数
//    if ([lang isEqualToString:@"zh-Hans"]) {
//        UITextRange *selectRange = [textField markedTextRange];
//            //获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectRange.start offset:0];
//            //没有高亮选择的字，就对已经输入的文字进行字数统计和限制
//        if (!position) {
//            if (toBeString.length > MastNumber) {
//                //此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
//                NSRange finalRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MastNumber)];
//                textField.text = [toBeString substringWithRange:finalRange];
//
//                /*
//                 也可以直接使用以下方法显示最后的文本，但是这样可能会遇到emoji无法正常显示的问题
//                 textField.text = [toBeString substringToIndex:MastNumber];
//                 */
//            }
//        }
//        //有高亮选择的字符串，则暂不对文字进行统计和限制
//        else{
//
//        }
//    }
//    //中文输入法以外就直接进行统计限制
//    else{
//        if (toBeString.length > MastNumber) {
//            NSRange finalRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MastNumber)];
//            textField.text = [toBeString substringWithRange:finalRange];
//        }
//    }
//
//    //显示实时的字数
//    self.stringNumberLabel.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)self.textField.text.length, MastNumber];
//}

@end

