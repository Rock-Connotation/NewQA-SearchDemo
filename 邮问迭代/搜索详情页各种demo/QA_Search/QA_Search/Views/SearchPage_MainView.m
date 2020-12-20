//
//  SearchPage_MainView.m
//  QA_Search
//
//  Created by 石子涵 on 2020/11/19.
//

#import "SearchPage_MainView.h"
#import "SearchTopView.h"
#import "KnowledgeView.h"
//在这里面的属性是固定的需要展示给用户看的内容
@interface SearchPage_MainView()
///顶部的view
@property (nonatomic, strong) SearchTopView *searchTopView;

/// 搜索的视图
@property (nonatomic, strong) KnowledgeView *knowledgeView;

@end

@implementation SearchPage_MainView

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
//添加顶部搜索的视图
- (void)addSearchTopView{
    
}
@end
