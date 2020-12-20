//
//  RelaeseDynamicView.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/20.
//
#import <Masonry.h>
#import "RelaeseDynamicView.h"

@interface RelaeseDynamicView()
/// 顶部的分割条
@property (nonatomic, strong)UIView *topSeparationView;
@end

@implementation RelaeseDynamicView
- (instancetype)init{
    self = [super init];
    if (self) {
        //添加顶部的标题、按钮等
        [self addTopTitleView];
        
        [self addReleaseTextView];
    }
    return self;
}

/// 添加顶部的标题、按钮等
- (void)addTopTitleView{
    //左边返回的按钮
    UIButton *leftPopBtn = [[UIButton alloc] init];
    [leftPopBtn setBackgroundImage:[UIImage imageNamed:@"返回的小箭头"] forState:UIControlStateNormal];
        //让代理跳回到上一个界面
    [leftPopBtn addTarget:self.delegate action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftPopBtn];
    [leftPopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.0427);
        make.top.equalTo(self).offset(MAIN_SCREEN_H * 0.0572);
        make.size.mas_equalTo(CGSizeMake(7, 14));
    }];
    
    
    //中间的title
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = @"发布动态";
    titleLbl.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    titleLbl.font = [UIFont fontWithName:@"PingFang-SC-Heavy" size:21];
    [self addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(leftPopBtn);
//        make.size.mas_equalTo(CGSizeMake(83, 20));
        make.height.mas_equalTo(20);
    }];
    
    //最右边的发布按钮
    UIButton *releaseBtn = [[UIButton alloc] init];
        //最开始文本内容为空时设置为禁用
    releaseBtn.enabled = NO;
    [releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
    [releaseBtn setTitle:@"发布" forState:UIControlStateDisabled];
    releaseBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:13];
    
    [releaseBtn setBackgroundImage:[UIImage imageNamed:@"禁用状态按钮背景图"] forState:UIControlStateDisabled];
    [releaseBtn setBackgroundImage:[UIImage imageNamed:@"去提问按钮的背景图片"] forState:UIControlStateNormal];
    [releaseBtn addTarget:self.delegate action:@selector(releaseDynamic) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:releaseBtn];
    [releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLbl);
        make.right.equalTo(self).offset(-MAIN_SCREEN_W *0.0413);
        make.size.mas_equalTo(CGSizeMake(59, 28));
    }];
    self.releaseBtn = releaseBtn;
    
    //下方的分割条
    UIView *topSeparationView = [[UIView alloc] init];
    topSeparationView.backgroundColor = [UIColor colorWithRed:226/255.0 green:232/255.0 blue:238/255.0 alpha:1.0];
    [self addSubview:topSeparationView];
    [topSeparationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(titleLbl.mas_bottom).offset(MAIN_SCREEN_H * 0.018);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, 1));
    }];
    self.topSeparationView = topSeparationView;
}

/// 添加输入的文本内容框
- (void)addReleaseTextView{
    //文本输入内容
    UITextView *textView = [[UITextView alloc] init];
    textView.text = @"分享你的新鲜事～";
    textView.textColor = [UIColor grayColor];
    textView.font = [UIFont fontWithName:@"PingFangSC-Bold" size:16];
    [self addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.topSeparationView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 0.1574));
    }];
    self.releaseTextView = textView;
    
    //显示字数的label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"0/500";
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10.92];
    label.textColor = [UIColor colorWithRed:85/255.0 green:108/255.0 blue:137/255.0 alpha:1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(textView);
        make.right.equalTo(self.releaseBtn);
        make.height.mas_equalTo(11);
    }];
    self.numberOfTextLbl = label;
    
}
@end
