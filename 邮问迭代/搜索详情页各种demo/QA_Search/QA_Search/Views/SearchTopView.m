//
//  SearchTopView.m
//  QA_Search
//
//  Created by 石子涵 on 2020/11/19.
//

#import "SearchTopView.h"
#import <Masonry.h>
@interface SearchTopView()
/// 计时器
@property (nonatomic, strong) NSTimer *timer;

/// 用于秒数计时
@property (nonatomic) int second;

@property (nonatomic, strong) NSArray *placeholderArray;
@end
@implementation SearchTopView
- (void)initWithPlaceholders:(NSArray *)placeholderArray{
    if (self == [super init]) {
        //设置关于本身的属性
#warning  设置自身的背景颜色，此处暂时没有，记得添加
            
        
        //添加返回按钮
        self.backBtn = [[UIButton alloc] init];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];        //设置图片
        [self addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(MAIN_SCREEN_W * 0.0427);
            make.top.equalTo(self.mas_top).offset(MAIN_SCREEN_H * 0.0217);
        }];
            //添加方法，跳回到返回界面
        [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        //搜索框
            //添加搜索框
        [self addSearchTextfieldView];
            //设置placeholder轮播
        self.placeholderArray = placeholderArray;
        self.second = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cycle:) userInfo:nil repeats:YES];
        
    }
}


///添加搜索框
- (void)addSearchTextfieldView{
    //添加背景view
    UIView *searchFieldBackgroundView = [[UIView alloc] init];
    searchFieldBackgroundView.backgroundColor = [UIColor whiteColor];             //背景色为白色
    searchFieldBackgroundView.layer.cornerRadius = MAIN_SCREEN_H*0.0271;          //设置圆角
    [self addSubview:searchFieldBackgroundView];
    [searchFieldBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.backBtn.mas_right).offset(MAIN_SCREEN_W * 0.0693);
        make.width.mas_equalTo(MAIN_SCREEN_W * 0.8267);
    }];
    
    //添加搜索图标
    self.searchIcon = [[UIImageView alloc] init];
#warning 设置searchIcon的背景图片
        
    
    [searchFieldBackgroundView addSubview:self.searchIcon];
    [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchFieldBackgroundView.mas_left).offset(MAIN_SCREEN_W * 0.0453);
        make.top.equalTo(searchFieldBackgroundView.mas_top).offset(MAIN_SCREEN_H * 0.0134);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.0533, MAIN_SCREEN_W * 0.0533));
    }];
    
    //添加搜索框
    self.searchTextfield = [[UITextField alloc] init];
    [searchFieldBackgroundView addSubview:self.searchTextfield];
    [self.searchTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchIcon.mas_right).offset(MAIN_SCREEN_W * 0.0386);
        make.centerX.equalTo(searchFieldBackgroundView);
        make.right.equalTo(searchFieldBackgroundView.mas_right);
        make.height.mas_equalTo(MAIN_SCREEN_H *0.0202);
    }];
    self.searchTextfield.font = [UIFont fontWithName:@".PingFang SC" size:14];       //设置字体
    self.searchTextfield.backgroundColor = [UIColor clearColor];
    
    //为UITextField自定义键盘上的toolBar
    [self.delegate addKeyBoardToolBarforTextField:self.searchTextfield];
}

/// 让代理跳回到上一个页面
- (void)back{
    [self.delegate jumpBack];
}

/// 时间循环设置搜索框的提示内容
- (void)cycle:(NSArray *)array{
    self.second++;      //开始计时
    array = self.placeholderArray;
    if (self.second % 5 == 0) {     //每五秒轮播一次内容
        for (int i = 0; i < array.count; i++) {
            self.searchTextfield.placeholder = array[i];
            //以此不断循环轮播内容
            if (i == 2) {
                i = 0;
            }
        }
    }
}
@end
