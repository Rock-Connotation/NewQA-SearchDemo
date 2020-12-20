//
//  ViewController.m
//  搜索demo
//
//  Created by 石子涵 on 2020/11/30.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *textField;

@property (nonatomic, strong)UILabel *label;

@property int i;

/// 计时器
@property (nonatomic, strong) NSTimer *timer;

/// 用于秒数计时
@property (nonatomic) int second;

/// 轮播的palceholder数组，里面有三个元素，网络请求获取
@property (nonatomic, strong) NSArray *placeholderArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textField = [[UITextField alloc]init];
    
    _textField.frame = CGRectMake(50, 300, 100, 300);
    _textField.placeholder = @"红岩网校";
    _textField.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:_textField];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%d",_second];
    label.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:label];
    _label = label;
    
    self.placeholderArray = @[@"红岩网校",@"校庆",@"数模"];
    self.second = 0;
    _i = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cycle) userInfo:nil repeats:YES];
}
- (void)cycle{
    self.second++;
    _label.text = [NSString stringWithFormat:@"%d",_second];
    if (_second % 5 == 0) {
        _i++;
        self.textField.placeholder = self.placeholderArray[_i];
        if (_i == 2) {
            _i = -1;
        }
    }
}

@end
