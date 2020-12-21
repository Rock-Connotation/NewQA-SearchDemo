//
//  ViewController.m
//  button只选中一个
//
//  Created by 石子涵 on 2020/12/21.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray <UIButton *>* buttonArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@"校园周边",@"海底捞",@"学习",@"运动",@"兴趣"];
    self.buttonArray = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = 100 + i;
        button.frame = CGRectMake(64*i+3, 100, 58, 25);
        [button addTarget:self action:@selector(doButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //默认在第一个
        if (button.tag == 100) {
            [button setBackgroundColor:[UIColor blueColor]];
        }else{
            button.backgroundColor = [UIColor redColor];
        }
        [self.buttonArray addObject:button];
        //将循环创建的button都添加到view上面
        [self.view addSubview:button];
    }
   
}
- (void)doButtonAction:(UIButton *)sender{
    for (UIButton *button in self.buttonArray) {
        if (button.tag != sender.tag) {
            button.backgroundColor = [UIColor redColor];
        } else {
            button.backgroundColor = [UIColor blueColor];
        }
    }
}

@end
