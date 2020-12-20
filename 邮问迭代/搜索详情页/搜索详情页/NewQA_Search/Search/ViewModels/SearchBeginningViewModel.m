//
//  SearchBeginningViewModel.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/11/29.
//

#import "SearchBeginningViewModel.h"

@implementation SearchBeginningViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        
        // 搜索初始页搜索框内的提示文字合集
        [self addSearchTextFieldPlaceholdersArray];
        
        //添加labelStr
        [self addLabelStr];
        
        //获取热门搜索按钮的文本数组
        [self addHotSearchBtnsTextAray];
        
    }
    return self;
}
/// 获取热门搜索按钮的文本数组
- (void)addHotSearchBtnsTextAray{
#warning 此时自定义，后面需要进行网络请求获取
    self.hotSearchBtnsText = @[@"红岩网校",@"校庆",@"啦啦操比赛",@"话剧表演",@"奖学金",@"建模"];
}

/// 搜索初始页搜索框内的提示文字合集
- (void)addSearchTextFieldPlaceholdersArray{
    self.searchTextFieldPlaceholdersArray = @[@"红岩网校工作站",@"奖学金",@"校庆"];
}

/// 添加labelStr
- (void)addLabelStr{
    self.hotSearchLabelStr = @"热门搜索";
    self.CQKnowledgeLabelStr = @"重邮知识库";
}

@end
