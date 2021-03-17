//
//  ViewController.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/11/29.
//

#import "ViewController.h"
#import "SearchBenginningCV.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:btn];
    // Do any additional setup after loading the view.
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSLog(@"获取当前的日期为-------%@",dateTime);
}

- (void)jump{
    SearchBenginningCV *cv = [[SearchBenginningCV alloc] init];
    [self.navigationController pushViewController:cv animated:YES];
}

@end
