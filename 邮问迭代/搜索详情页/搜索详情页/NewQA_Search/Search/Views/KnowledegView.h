//
//  KnowledegView.h
//  搜索详情页
//
//  Created by 石子涵 on 2020/11/29.
//

/**重游知识库/热门搜索的View*/
#import <UIKit/UIKit.h>
#import "HotSearchBtn.h"

NS_ASSUME_NONNULL_BEGIN
@protocol KnowledgeDelegate <NSObject>

@optional
/// 点击热门搜索item会调用的方法
- (void)touchHotSearchBtnsThroughBtn:(UIButton *)btn;

/// 点击重邮知识库item会调用的方法
- (void)touchCQUPTKonwledge;

@end

@interface KnowledegView : UIView

@property (nonatomic, weak) id <KnowledgeDelegate>delegate;

/// “邮问知识库”、“热门搜索的按钮”
@property (nonatomic, strong) UILabel *hotSearch_KnowledgeLabel;

///历史记录或者邮问知识库的button,可自动换行(仿造课表historyView逻辑)
@property (nonatomic, strong) NSMutableArray <UIButton*>*buttonArray;//每一个button

- (instancetype)initWithBtnTextAry:(NSArray *)array andStr:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
