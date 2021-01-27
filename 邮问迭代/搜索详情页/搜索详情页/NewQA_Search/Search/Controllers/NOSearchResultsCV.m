//
//  NOSearchResultsCV.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/8.
//

#import <Masonry.h>
#import <MBProgressHUD.h>                //Hud提示框
#import "NOSearchResultsCV.h"
#import "SearchTopView.h"               //顶部的搜索视图
#import "SearchBeginningViewModel.h"    //搜索首页的VM
#import "SearchEndCV.h"                 //搜索有结果页
#import "ReleaseDynamicCV.h"            //发布动态页面
@interface NOSearchResultsCV ()<SearchTopViewDelegate,UITextFieldDelegate>
///最上方的搜索视图
@property (nonatomic, strong) SearchTopView *searchTopView;

@property (nonatomic, strong) SearchBeginningViewModel *viewModel;

/// 屏幕正中间的图片
@property (nonatomic, strong) UIImageView *centerImageView;

///无相关内容的label
@property (nonatomic, strong) UILabel *NoContentlabel;

/// 去提问的button
@property (nonatomic, strong) UIButton *askBtn;
@end

@implementation NOSearchResultsCV

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //设置导航栏不隐藏，后面几的修改
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    
    //初始化ViewModel
    _viewModel = [[SearchBeginningViewModel alloc] init];
    
    //添加顶部的搜索视图
    [self addSearchTopView];
    
    //添加屏幕正中间的imagView
    [self addCenterImageView];
    
    [self addlabelAndeBtn];
}

#pragma mark- 添加视图
/// 添加顶部的搜索视图
- (void)addSearchTopView{
    if ( !_searchTopView) {
        _searchTopView = [[SearchTopView alloc] initWithPlaceholders:_viewModel.searchTextFieldPlaceholdersArray];
        _searchTopView.delegate = self;             //设置代理
        [self.view addSubview:_searchTopView];
        [_searchTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(MAIN_SCREEN_H * 0.0352);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 0.0562));
        }];
    }
}

/// 添加屏幕正中间的imagView
- (void)addCenterImageView{
    //屏幕中间的imageView
    if (!_centerImageView) {
        self.centerImageView = [[UIImageView alloc] init];
        _centerImageView.image = [UIImage imageNamed:@"人在手机里"];
        [self.view addSubview:_centerImageView];
        [_centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.2227);
            make.top.equalTo(self.view).offset(MAIN_SCREEN_H * 0.2631);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.5387, MAIN_SCREEN_H * 0.1964));
        }];
    }
}

/// 添加提示框和去提问的按钮
- (void)addlabelAndeBtn{
    
    //提示内容
    if (!_NoContentlabel) {
        _NoContentlabel = [[UILabel alloc] init];
        _NoContentlabel.text = @"没有相关内容";
        _NoContentlabel.textColor = [UIColor colorWithRed:85/255.0 green:108/255.0 blue:137/255.0 alpha:1.0];
        _NoContentlabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        [self.view addSubview:self.NoContentlabel];
        [self.NoContentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerImageView);
            make.top.equalTo(self.centerImageView.mas_bottom).offset(MAIN_SCREEN_H * 0.0495);
            make.height.mas_equalTo(11.5);
        }];
    }
    
    //添加去提问的按钮
    if (!_askBtn) {
        _askBtn = [[UIButton alloc] init];
        [_askBtn setBackgroundImage:[UIImage imageNamed:@"去提问按钮的背景图片"] forState:UIControlStateNormal];
        [_askBtn setTitle:@"去提问" forState:UIControlStateNormal];
        _askBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Bold" size:15];
        _askBtn.titleLabel.textColor = [UIColor whiteColor];
        [_askBtn addTarget:self action:@selector(goAskPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.askBtn];
        [self.askBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.3453);
            make.top.equalTo(self.centerImageView.mas_bottom).offset(MAIN_SCREEN_H * 0.1364);
        }];
        
       
    }
}
#pragma mark- 顶部搜索框的代理方法
//跳回到上个界面
- (void)jumpBack{
    [self.navigationController popViewControllerAnimated:YES];
}
/// 自定义toolBar
/// @param textField textField 显示的内容是这个文本输入框的内容
- (void)addKeyBoardToolBarforTextField:(UITextField *)textField{
    //设置return类型为search，这样键盘上就会有一个搜索按钮
    [textField setReturnKeyType:UIReturnKeySearch];
    textField.delegate = self;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 44)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MAIN_SCREEN_W-60, 0, 50, 44)];
    [toolBar addSubview:btn];
    [btn setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    
    //点击完成后调用方法
    [btn addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];

    UILabel *placeHolderLabel = [[UILabel alloc] init];
//    UITextField *placeHolderLabel = [[UITextField alloc] init];
    [toolBar addSubview:placeHolderLabel];
    placeHolderLabel.text = textField.placeholder;
//    placeHolderLabel.text = textField.text;
    placeHolderLabel.font = [UIFont systemFontOfSize:13];
    placeHolderLabel.alpha = 0.8;
    placeHolderLabel.textColor = [UIColor systemGrayColor];
    [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(toolBar);
        make.top.equalTo(toolBar);
        make.bottom.equalTo(toolBar);
    }];
    textField.inputAccessoryView = toolBar;
}


///点击键盘右上角的完成按钮后调用
- (void)doneClicked{
    [self.view endEditing:YES];
    [self searchWithString:_searchTopView.searchTextfield.text];
}

///点击搜索后执行操作(UITextFiedl的代理方法)
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchWithString:textField.text];
    return YES;
}

/// 点击搜索按钮之后去进行的逻辑操作
/// @param searchString 搜索的文本
- (void)searchWithString:(NSString *)searchString{
    //如果内容为空，提示
    if ([searchString isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:(MBProgressHUDModeText)];
        hud.label.text = @"输入为空";
        [hud hideAnimated:YES afterDelay:1];    //延迟一秒后消失
        return;                 //直接返回
    }
    
    //内容不为空则
        //进行网络请求获取数据
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    hud.label.text = @"加载中";
    [hud hideAnimated:YES afterDelay:1];
#warning 此处去得到网络请求的结果，三种情况：无网络连接，无结果，有结果
    
    //1.无网络连接：提示没有网络
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud setMode:(MBProgressHUDModeText)];
//    hud.label.text = @"请检查网络";
//    [hud hideAnimated:YES afterDelay:1];    //延迟一秒后消失
//    return;                 //直接返回
    
    //2.无结果，hud提示无结果
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud setMode:(MBProgressHUDModeText)];
//    hud.label.text = @"无搜索结果";
//    [hud hideAnimated:YES afterDelay:1];    //延迟一秒后消失
//    return;                 //直接返回
    
    //3.有结果,跳转到搜索结果页，并写入历史记录
        //3.1跳转到搜索结果页
//    SearchEndCV *cv = [[SearchEndCV alloc] init];
//    [self.navigationController pushViewController:cv animated:YES];
        
        //3.2写入历史记录
    [self wirteHistoryRecord:searchString];
    
}

/// 将搜索的内容添加到历史记录
/// @param string 搜索的内容
- (void)wirteHistoryRecord:(NSString *)string{
    //1.取出userDefault的历史数组
    NSUserDefaults *userdefaulte = [NSUserDefaults standardUserDefaults];
        //从缓存中取出数组的时候要mutablyCopy一下，不然会崩溃
    NSMutableArray *array = [[userdefaulte objectForKey:@"historyRecords"] mutableCopy];
    
    //2.判断当前搜素内容是否与历史记录重合，如果重合就删除历史记录中原存在的数组
    for (NSString *historyStr in array) {
        if ([historyStr isEqualToString:string]) {
            [array removeObject:historyStr];        //从数组中移除
            break;                                  //直接退出
        }
    }
    //3.将内容加入到历史记录数组里面
    [array insertObject:string atIndex:0];
    
    //4.将历史数组重新存入UserDefault
    [userdefaulte setObject:array forKey:@"historyRecords"];
    
    //发出通知，在搜索开始页去刷新历史记录（在willAppear里面调用）
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHistory" object:nil];
}

/// 挑战到去提问的界面
- (void)goAskPage{
    ReleaseDynamicCV *cv = [[ReleaseDynamicCV alloc] init];
    [self.navigationController pushViewController:cv animated:YES];
}
@end
