//
//  SearchBeginningViewModel.h
//  搜索详情页
//
//  Created by 石子涵 on 2020/11/29.
//

/**搜索初始页的ViewModel*/
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchBeginningViewModel : NSObject

/// 热门搜索的str
@property (nonatomic, strong) NSString *hotSearchLabelStr;

/// 重游知识库的Str
@property (nonatomic, strong) NSString *CQKnowledgeLabelStr;

/// 搜索初始页搜索框内的提示文字合集
@property (nonatomic, strong) NSArray *searchTextFieldPlaceholdersArray;

/// 热门搜索按钮的文本数组，应用网络请求获取
@property (nonatomic, strong) NSArray *hotSearchBtnsText;

/// 重构init
- (instancetype)init;
@end

NS_ASSUME_NONNULL_END
