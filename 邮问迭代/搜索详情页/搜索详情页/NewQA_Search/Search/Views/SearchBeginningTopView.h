//
//  SearchBeginningTopView.h
//  搜索详情页
//
//  Created by 石子涵 on 2020/11/29.
//
/**搜索初始页的上班部分View*/
#import <UIKit/UIKit.h>
#import "SearchTopView.h"
#import "KnowledegView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SearchBeginningTopView : UIView

/// 顶部搜索的视图
@property (nonatomic, strong) SearchTopView *searchTopView;

/// 添加热门搜索的视图
@property (nonatomic, strong) KnowledegView *hotSearchView;
- (instancetype)init;
@end

NS_ASSUME_NONNULL_END
