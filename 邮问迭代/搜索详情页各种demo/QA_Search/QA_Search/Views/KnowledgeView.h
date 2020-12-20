//
//  KnowledgeView.h
//  QA_Search
//
//  Created by 石子涵 on 2020/11/23.
//
/*
 热门搜索和搜索结果页面的邮问知识库都是此页面的View
 */
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ViewType) {
    /**热门搜索的类型*/
    ViewTypeHotSearch,
    /**重邮知识库的类型*/
    ViewTypeKnowedge,
};

NS_ASSUME_NONNULL_BEGIN
@protocol touchBtns <NSObject>

@optional
/// 点击热门搜索会调用的方法
- (void)touchHotSearchBtns;

/// 点击重邮知识库会调用的方法
- (void)touchCQUPTKonwledge;

@end

///该View接受一个数组，将数组中的所有数据以一个一个Item的形式展示出来，自动换行
@interface KnowledgeView : UIView
/// “邮问知识库”、“热门搜索的按钮”
@property (nonatomic, strong) UILabel *hotSearch_KnowledgeLabel;

///历史记录或者邮问知识库的button
@property (nonatomic, strong)NSMutableArray <UIButton*>*buttonArray;//每一个button

/// 这个view的代理
@property (nonatomic, strong) id <touchBtns> delegate;

/// 创建视图
/// @param string 标题的文字“邮问知识库”或“热门搜索
/// @param array 创建热门搜索按钮或者邮问的文字数组,通过一个一个btn展示，自动换行
- (instancetype)initWithLabelString:(NSString *)string ButtonArry:(NSArray *)array andViewType:(ViewType)viewType;

@end

NS_ASSUME_NONNULL_END
