//
//  HistoryCell_Search.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/1.
//

#import "HistoryCell_Search.h"
#import <Masonry.h>

@implementation HistoryCell_Search
- (instancetype)initWithString:(NSString *)string{
    self = [super init];
    if (self) {
        self.string = string;
        
        [self addLabelWithString];
        
        [self addClearBtn];
        
        self.backgroundColor = self.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    }
    return self;
}

///添加label
- (void)addLabelWithString{
    
    self.textLbl = [[UILabel alloc] init];
    self.textLbl.text = self.string;
    self.textLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    self.textLbl.textColor = [UIColor colorWithRed:96/255.0 green:113/255.0 blue:141/255.0 alpha:1.0];
    [self.contentView addSubview:self.textLbl];
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(6);
    }];
}

///添加清除按钮
- (void)addClearBtn{
    self.clearBtn = [[UIButton alloc] init];
    [self.clearBtn setImage:[UIImage imageNamed:@"垃圾箱图标"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.clearBtn];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.contentView);
        make.width.mas_equalTo(20);
    }];
    [self.clearBtn addTarget:self action:@selector(touchDleteBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchDleteBtn{
    [self.delegate deleteHistoryCellThroughString:self.string];
}


@end
