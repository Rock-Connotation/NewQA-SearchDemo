//
//  HotSearchBtn.m
//  QA_Search
//
//  Created by 石子涵 on 2020/11/19.
//

#import "HotSearchBtn.h"
#import <Masonry.h>
#define MAIN_SCREEN_H [UIScreen mainScreen].bounds.size.height              //屏幕高度
#define MAIN_SCREEN_W [UIScreen mainScreen].bounds.size.width               //屏幕宽度
@implementation HotSearchBtn

- (instancetype)init{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 20;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(MAIN_SCREEN_W*0.03467);
            make.right.equalTo(self).offset(-MAIN_SCREEN_W*0.04267);
        }];
    }
    return  self;
}

@end
