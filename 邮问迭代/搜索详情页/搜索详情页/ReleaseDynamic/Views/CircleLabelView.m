//
//  CircleLabelView.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/22.
//
#import <Masonry.h>
#import "CircleLabelView.h"
//屏幕宽高
#define MAIN_SCREEN_H [UIScreen mainScreen].bounds.size.height
#define MAIN_SCREEN_W [UIScreen mainScreen].bounds.size.width

@interface CircleLabelView()
@property int split;    //行、列间距

@end
@implementation CircleLabelView

- (instancetype)initWithArrays:(NSArray *)array{
    self = [super init];
    if (self) {
        self.split = MAIN_SCREEN_W * 0.032;
        [self addLabelAndView];
        
        [self addButtonsWithArray:array];
        
        [self btnsAddConstraints];
    }
    return self;
}

/// 添加label和分割view
- (void)addLabelAndView{
    //分割view
    self.topSeparationView = [[UIView alloc] init];
    self.topSeparationView.backgroundColor = [UIColor colorWithRed:226/255.0 green:232/255.0 blue:238/255.0 alpha:1.0];
//    self.topSeparationView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.topSeparationView];
    [self.topSeparationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
//        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, 1));
    }];
    
    //标题alebl
    self.tittleLbl = [[UILabel alloc] init];
    self.tittleLbl.text = @"请选择圈子";
    self.tittleLbl.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    self.tittleLbl.font = [UIFont fontWithName:@"PingFangSC-Bold" size:15];
    [self addSubview:self.tittleLbl];
    [self.tittleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.0427);
        make.top.equalTo(self.topSeparationView.mas_bottom).offset(MAIN_SCREEN_H * 0.0292);
    }];
}

/// 添加按钮
- (void)addButtonsWithArray:(NSArray *)array{
    self.buttonArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        //设置文本
        [button setTitle:[NSString stringWithFormat:@"# %@",array[i]] forState:UIControlStateNormal];
        //设置button宽度随title文本长度自适应
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        //设置button的字体颜色、字体字号
//        button.titleLabel.textColor = [UIColor colorWithRed:85/255.0 green:108/255.0 blue:137/255.0 alpha:1.0];
        [button setTitleColor:[UIColor colorWithRed:85/255.0 green:108/255.0 blue:137/255.0 alpha:1.0] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        button.tag = 100 + i;      //设置每个button的tag
        //设置未选中时的背景
        [button setBackgroundImage:[UIImage imageNamed:@"圈子标签未选中背景"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
        [self addSubview:button];
    }
}

///为btns添加约束，让它自动换行等等
- (void)btnsAddConstraints{
    if (self.buttonArray.count == 0) return;
    __block int k = 0;
    [self.buttonArray[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tittleLbl.mas_bottom).offset(MAIN_SCREEN_W * 0.0413);
        make.left.equalTo(self.tittleLbl);
        make.height.mas_equalTo(MAIN_SCREEN_H * 0.0382);
    }];
    __block float lastBtnW,lastBtnX;
    for (int i = 1; i < self.buttonArray.count; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self layoutIfNeeded];
            lastBtnW = self.buttonArray[i-1].frame.size.width;
            lastBtnX = self.buttonArray[i-1].frame.origin.x;
            if(lastBtnX + lastBtnW*2 > self.frame.size.width) {
                k++;
                [self.buttonArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.tittleLbl.mas_bottom).offset(k * MAIN_SCREEN_W*0.1147 + self.split);
                    make.left.equalTo(self.tittleLbl);
                }];
            }else {
                [self.buttonArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.tittleLbl).offset(self.split + lastBtnW + lastBtnX);
                    make.top.equalTo(self.tittleLbl.mas_bottom).offset(k * MAIN_SCREEN_W*0.1147 + MAIN_SCREEN_W * 0.0413);
                }];
            }
        });
    }
}

- (void)select:(UIButton *)sender{
    [self.delegate clickACirleBtn:sender];
}
@end
