//
//  HistoryCell_Search.m
//  点击删除该条cell的demo
//
//  Created by 石子涵 on 2020/11/25.
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
        
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

///添加label
- (void)addLabelWithString{
    
    self.textLbl = [[UILabel alloc] init];
    self.textLbl.text = _string;
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
