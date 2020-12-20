//
//  ViewController.m
//  给键盘上添加完成按钮
//
//  Created by 石子涵 on 2020/11/18.
//

#import "ViewController.h"

@interface ViewController ()
///计时器 最后记得释放
@property (nonatomic, strong) NSTimer *timer;

///用于计时，每隔三秒钟搜索框里的三个内容轮转播放
@property int second;

///搜索输入框
@property (nonatomic, strong) UITextField *searchTextField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
