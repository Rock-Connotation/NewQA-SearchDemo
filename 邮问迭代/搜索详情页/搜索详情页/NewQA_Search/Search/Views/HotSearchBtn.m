//
//  HotSearchBtn.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/1.
//

#import "HotSearchBtn.h"
#import <Masonry.h>
#define MAIN_SCREEN_H [UIScreen mainScreen].bounds.size.height
#define MAIN_SCREEN_W [UIScreen mainScreen].bounds.size.width
@implementation HotSearchBtn

- (instancetype)init{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        [self setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        //设置button宽度随title文本长度自适应
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        /**约束会报警告，但是不影响显示*/
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(MAIN_SCREEN_W*0.03467);
            make.right.equalTo(self).offset(-MAIN_SCREEN_W*0.04267);
        }];
        
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 10;   //圆角
        //边框宽度，不设置边框宽度就无法看到边框，以及边框颜色
        self.layer.borderWidth = 1;
        //设置边框颜色
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){12 /255, 53/255, 115/255, 1 });
        self.layer.borderColor = colorref;
    }
    return  self;
}
@end
