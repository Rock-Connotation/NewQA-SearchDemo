//
//  AddPhotosBtn.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/21.
//
#import <Masonry.h>
#import "AddPhotosBtn.h"

@implementation AddPhotosBtn
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"添加图片背景"] forState:UIControlStateNormal];
        
        //添加中心的小图片框
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"相机"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        //下方的label
        UILabel *label = [[UILabel alloc] init];
        label.text = @"添加图片";
        label.textColor = [UIColor colorWithRed:171/255.0 green:188/255.0 blue:217/255.0 alpha:1.0];
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.top.equalTo(imageView.mas_bottom).offset(13.5);
            make.height.mas_equalTo(11.5);
        }];
    }
    return self;
}

@end
