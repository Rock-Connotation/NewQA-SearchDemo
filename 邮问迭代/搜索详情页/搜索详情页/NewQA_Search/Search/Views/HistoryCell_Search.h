//
//  HistoryCell_Search.h
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HistoryCell_Searh <NSObject>

/// 删除选中的cell
/// @param string cell中的string
- (void)deleteHistoryCellThroughString:(NSString *)string;

@end

@interface HistoryCell_Search : UITableViewCell
/// 显示文本的cell
@property (nonatomic, strong) UILabel *textLbl;

/// 清除该条记录的按钮
@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) NSString *string;
@property (nonatomic, assign) id <HistoryCell_Searh>delegate;
- (instancetype)initWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
