//
//  SearchBeginningTopView.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/11/29.
//

#import "SearchBeginningTopView.h"
#import "SearchBeginningViewModel.h"
#import <Masonry.h>
@interface SearchBeginningTopView()
/// 搜索视图的ViewMoldel
@property (nonatomic, strong) SearchBeginningViewModel *viewModel;

/// 分界线
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation SearchBeginningTopView
- (instancetype)init{
    self = [super init];
    if (self) {
        //设置背景颜色
        self.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
        self.viewModel = [[SearchBeginningViewModel alloc] init];
        
        //添加顶部的搜索
        [self addSearchTopView];
        
        //添加热门搜索界面
        [self addHotSearchView];
        
        self.bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithRed:226/255.0 green:232/255.0 blue:238/255.0 alpha:1.0];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_hotSearchView.mas_bottom);
            make.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, 1));
        }];
    }
    return self;
}

/// 添加顶部的搜索视图和返回按钮
- (void)addSearchTopView{
    self.searchTopView = [[SearchTopView alloc] initWithPlaceholders:_viewModel.searchTextFieldPlaceholdersArray];
    [self addSubview:_searchTopView];
    [_searchTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.mas_top).offset(MAIN_SCREEN_H * 0.0352);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 0.0562));
    }];
}

/// 添加热门搜索界面
- (void)addHotSearchView{
    self.hotSearchView = [[KnowledegView alloc] initWithBtnTextAry:_viewModel.hotSearchBtnsText andStr:_viewModel.hotSearchLabelStr];
    [self addSubview:_hotSearchView];
    [_hotSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchTopView.mas_bottom).offset(MAIN_SCREEN_H * 0.0449);
        make.left.equalTo(self.mas_left).offset(MAIN_SCREEN_W * 0.0426);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.8506, MAIN_SCREEN_H * 0.1874));
//        make.width.mas_equalTo(MAIN_SCREEN_W * 0.8506);
    }];
}
@end
