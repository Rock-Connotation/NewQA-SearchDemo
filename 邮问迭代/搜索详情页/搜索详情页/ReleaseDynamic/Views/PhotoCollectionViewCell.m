//
//  PhotoCollectionViewCell.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/20.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell
- (instancetype)init{
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        //设置相片框可与用户交互，不然右上角的按钮无法点击
        self.imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageView];
        
        self.clearBtn = [[UIButton alloc] init];
        [self.clearBtn setBackgroundImage:[UIImage imageNamed:@"小红叉"] forState:UIControlStateNormal];
        [self.clearBtn addTarget:self.delegate action:@selector(clearPhotoCell) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.clearBtn];
    }
    return self;
}
@end
