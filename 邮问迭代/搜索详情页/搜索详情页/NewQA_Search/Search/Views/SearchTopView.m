//
//  SearchTopView.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/11/29.
//

#import "SearchTopView.h"
#import <Masonry.h>
@interface SearchTopView()
/// 计时器
@property (nonatomic, strong) NSTimer *timer;

/// 用于秒数计时
@property (nonatomic) int second;

/// 用于轮播的序数
@property (nonatomic, assign) int i;

/// 轮播的palceholder数组，里面有三个元素，网络请求获取
@property (nonatomic, strong) NSArray *placeholderArray;
@end

@implementation SearchTopView
- (instancetype)initWithPlaceholders:(NSArray *)placeholderArray{
    self = [super init];
    if (self) {
        //设置背景颜色
        self.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
        
        self.placeholderArray = placeholderArray;
        
        //添加返回按钮
        [self addBackBtn];
        
        //添加搜索框
        [self addSearchTextfieldView];
        
        //设置placeholder轮播
        self.second = 0;
        _i = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cycle) userInfo:nil repeats:YES];
        
        // 延迟0.5秒执行否则无法奏效,为UITextField自定义键盘上的toolBar
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate addKeyBoardToolBarforTextField:self.searchTextfield];
        });
       
    }
    return self;
}

/// 添加返回按钮
- (void)addBackBtn{
    self.backBtn = [[UIButton alloc] init];
        //设置图片
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"返回的小箭头"] forState:UIControlStateNormal];
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(MAIN_SCREEN_W * 0.0427);
        make.top.equalTo(self.mas_top).offset(MAIN_SCREEN_H * 0.0217);
                //高是宽的两倍
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.0186, 2 *MAIN_SCREEN_W * 0.0186 ));
    }];
    
    //添加方法，跳回返回界面
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

///添加搜索框
- (void)addSearchTextfieldView{
    //添加背景view
    UIView *searchFieldBackgroundView = [[UIView alloc] init];
        //设置背景色为白色
    searchFieldBackgroundView.backgroundColor = [UIColor whiteColor];
        //设置圆角
    searchFieldBackgroundView.layer.cornerRadius = MAIN_SCREEN_H*0.0271;
    [self addSubview:searchFieldBackgroundView];
    [searchFieldBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.backBtn.mas_right).offset(MAIN_SCREEN_W * 0.0693);
        make.right.equalTo(self.mas_right).offset(-MAIN_SCREEN_W * 0.0426);
    }];
    
    //添加搜索图标
    self.searchIcon = [[UIImageView alloc] init];
    self.searchIcon.image = [UIImage imageNamed:@"放大镜"];
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
        make.left.equalTo(self.searchIcon.mas_right).offset(MAIN_SCREEN_W * 0.032);
        make.right.equalTo(searchFieldBackgroundView.mas_right).offset(-10);
        make.centerY.equalTo(searchFieldBackgroundView);
    }];
        //设置字体
    self.searchTextfield.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    
        //字体颜色
    _searchTextfield.textColor = [UIColor colorWithRed:135/255.0 green:150/255.0 blue:171/255.0 alpha:1.0];
    
        //设置提示文字
    self.searchTextfield.placeholder = [NSString stringWithFormat:@"大家都在搜%@",_placeholderArray[_i]];
    
    self.searchTextfield.backgroundColor = [UIColor clearColor];
    
        //设置光标颜色
    self.searchTextfield.tintColor = [UIColor blackColor];
    
}

/// 让代理跳回到上一个页面
- (void)back{
    [self.delegate jumpBack];
}

/// 时间循环设置搜索框的提示内容
- (void)cycle{
    self.second++;      //开始计时
    if (self.second % 5 == 0) {     //每五秒轮播一次内容
        _i++;
        self.searchTextfield.placeholder = [NSString stringWithFormat:@"大家都在搜%@",_placeholderArray[_i]];
        //以此不断循环轮播内容
        if (_i == 2) {
            _i = -1;
        }
    }
}
@end
