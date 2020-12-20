//
//  PhotoImageView.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/21.
//

#import "PhotoImageView.h"
#import <Masonry.h>

@implementation PhotoImageView

- (instancetype)init{
    self = [super init];
    if (self) {
        //设置图片框可与用户进行交互，如果不设置，那么button无法被点击
        self.userInteractionEnabled = YES;
        self.clearBtn = [[UIButton alloc] init];
        [self.clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
        [self.clearBtn setBackgroundImage:[UIImage imageNamed:@"小红叉"] forState:UIControlStateNormal];
        [self addSubview:self.clearBtn];
        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
    }
    return self;
}

- (void)clear{
    [self.delegate clearPhotoImageView:self];
}
@end
