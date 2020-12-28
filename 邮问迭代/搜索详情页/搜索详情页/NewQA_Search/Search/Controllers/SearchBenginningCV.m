//
//  SearchBenginningCV.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/11/29.
//
#import <Masonry.h>
#import <MBProgressHUD.h>

#import "SearchBenginningCV.h"
#import "SearchBeginningTopView.h"      //搜索页的上半部分View
#import "HistoryCell_Search.h"          //自定义的历史记录cell
#import "SearchBeginningViewModel.h"    //热门搜索的View的ViewModel
#import "SearchEndCV.h"                 //搜索结果页
#import "NOSearchResultsCV.h"           //搜索无结果页面
@interface SearchBenginningCV ()<SearchTopViewDelegate,UITextFieldDelegate,KnowledgeDelegate,UITableViewDelegate,UITableViewDataSource,HistoryCell_Searh>

@property (nonatomic, strong) SearchBeginningViewModel *viewModel;

/// 上半部分视图
@property (nonatomic, strong) SearchBeginningTopView *searchBeginningTopView;

/// 历史记录的label
@property (nonatomic, strong) UILabel *historyLabel;

/// 清除所有历史记录的按钮
@property (nonatomic, strong) UIButton *clearAllHistoryRecordbtn;

/// 显示历史记录
@property (nonatomic, strong) UITableView *historyTable;

/// 保存的历史记录
@property (nonatomic, strong) NSMutableArray *historyRecordsAry;

@end

@implementation SearchBenginningCV

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //关于一些初始化
    self.viewModel = [[SearchBeginningViewModel alloc] init];
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"historyRecords"] mutableCopy];
    if (array != nil) {
        _historyRecordsAry = array;
    }else{
        self.historyRecordsAry = [NSMutableArray array];
    }
    
    
    //1.添加上半部分的视图
    _searchBeginningTopView = [[SearchBeginningTopView alloc] init];
    _searchBeginningTopView.frame = self.view.frame;
    [self.view addSubview:_searchBeginningTopView];
        //1.1设置顶部搜索框的相关
    self.searchBeginningTopView.searchTopView.delegate = self;
        //1.2设置热门搜索的相关
    self.searchBeginningTopView.hotSearchView.delegate = self;
    
    //2.如果有历史记录就添加下半部分视图，否则就不添加
    if (_historyRecordsAry.count != 0) {
        [self addSearchBottomView];
    }
    
    //接收到搜索无结果页的通知，刷新历史记录的table
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHistoryRecord) name:@"reloadHistory" object:nil];
}

//设置点击空白处收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark- 搜索框视图的代理方法
- (void)jumpBack{
    [self.navigationController popViewControllerAnimated:YES];
}

/// 自定义toolBar
/// @param textField 显示的内容是这个文本输入框的内容
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
    [self.view endEditing:YES];                 //键盘收下去
    [self searchWithString:self.searchBeginningTopView.searchTopView.searchTextfield.text];
}


///点击搜索后执行操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];                 //收回键盘
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
        //1.进行网络请求获取数据
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
        //3.1跳转到搜索结果
//    SearchEndCV *cv = [[SearchEndCV alloc] init];
//    [self.navigationController pushViewController:cv animated:YES];
    
        //3.2添加历史记录
    [self wirteHistoryRecord:searchString];
    
    
   
    
//    //跳转到搜索无结果界面
    NOSearchResultsCV *cv = [[NOSearchResultsCV alloc] init];
    [self.navigationController pushViewController:cv animated:YES];
}

/// 将搜索的内容添加到历史记录
/// @param string 搜索的内容
- (void)wirteHistoryRecord:(NSString *)string{
        //如果是第一次，直接添加到UserDefaults里面
    if (_historyRecordsAry.count == 0) {
        [_historyRecordsAry addObject:string];
        NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
        [defaluts setObject:_historyRecordsAry forKey:@"historyRecords"];
        
        //此时已经有历史记录，添加下半部分视图
            //延迟一秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addSearchBottomView];
        });
    }
    else{
        //1.如果不是第一次，那么先获取到之前的数组
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //2.从缓存取出来后要mutableCopy一下，不然会崩
        NSMutableArray *array = [[defaults objectForKey:@"historyRecords"] mutableCopy];
        //3.判断是否和以前的搜索内容一样，如果一样就移除旧的历史记录
        for (NSString *historyStr in array) {
            if ([historyStr isEqualToString:string]) {
                [array removeObject:historyStr];
                break;
            }
        }
        [array insertObject:string atIndex:0];
        
        //3.如果超出了最大容纳量（10）,则清除掉最后一条数据
        if (array.count > 10) {
            [array removeLastObject];
        }
        //5.重新添加到UserDefalut里面
        _historyRecordsAry = array;
        [defaults setObject:_historyRecordsAry forKey:@"historyRecords"];
        
        //6.刷新table
        [_historyTable reloadData];
        NSLog(@"%@",array);
    }
}

#pragma mark- 热门搜索的代理
//点击热门搜索时去搜索里面的内容
- (void)touchHotSearchBtnsThroughBtn:(UIButton *)btn{
    NSString *string = btn.titleLabel.text;
    [self searchWithString:string];

    
//    NSLog(@"%@",btn.titleLabel.text);
}

#pragma mark- 关于下半部分
/// 添加下半部分视图，如果有历史记录就展示，否则就不展示
- (void)addSearchBottomView{
    //历史记录按钮
    self.historyLabel = [[UILabel alloc] init];
    self.historyLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.historyLabel.text = @"历史记录";
    self.historyLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    [self.view addSubview:_historyLabel];
    [_historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_searchBeginningTopView.mas_bottom).offset(MAIN_SCREEN_H * 0.0374);
        make.top.equalTo(self.view).offset(MAIN_SCREEN_H * 0.3613);
        make.left.equalTo(_searchBeginningTopView.hotSearchView.hotSearch_KnowledgeLabel);
//        make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.0426);
        make.height.mas_equalTo(17);
    }];
    
    //清除历史记录按钮
    self.clearAllHistoryRecordbtn = [[UIButton alloc] init];
    [self.clearAllHistoryRecordbtn setTitle:@"清除全部" forState:UIControlStateNormal];
    [self.clearAllHistoryRecordbtn setTitleColor:[UIColor colorWithRed:147/255.0 green:163/255.0 blue:191/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.clearAllHistoryRecordbtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.clearAllHistoryRecordbtn addTarget:self action:@selector(clearAllrecords) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearAllHistoryRecordbtn];
        //button宽度随title字数自适应
    _clearAllHistoryRecordbtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_clearAllHistoryRecordbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-MAIN_SCREEN_W * 0.0426);
        make.bottom.equalTo(_historyLabel);
//        make.size.mas_equalTo(CGSizeMake(, 15.5));
        make.height.mas_equalTo(15.5);
    }];
    
    //显示历史记录的table
    self.historyTable = [[UITableView alloc] init];
    self.historyTable.backgroundColor = [UIColor clearColor];
    [self.historyTable setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    self.historyTable.showsHorizontalScrollIndicator = NO;
    self.historyTable.showsVerticalScrollIndicator = NO;
    self.historyTable.allowsSelection = NO;
    [self.view addSubview:self.historyTable];
    [_historyTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.historyLabel);
        make.top.equalTo(_historyLabel.mas_bottom).offset(MAIN_SCREEN_H * 0.0449);
        make.right.equalTo(_clearAllHistoryRecordbtn);
        make.bottom.equalTo(self.view);
    }];
    _historyTable.delegate = self;
    _historyTable.dataSource = self;
    //设置tableView可以被选中，如果不设置的话，点击cell无反应
    _historyTable.allowsSelection = YES;
//    _historyTable setStyle
    
}

/// 点击清除全部按钮调用的方法
- (void)clearAllrecords{
    //1.先清除历史数组
    [_historyRecordsAry removeAllObjects];
    
    //2；再清除缓存数组
    NSUserDefaults *dfl = [NSUserDefaults standardUserDefaults];
    [dfl setObject:_historyRecordsAry forKey:@"historyRecords"];
    
    //3.移除表格
    [_historyTable removeFromSuperview];
    NSLog(@"已经点击清除按钮");
    
}


//MARK:table的数据源以及代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _historyRecordsAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryCell_Search *cell = [[HistoryCell_Search alloc] initWithString:_historyRecordsAry[indexPath.row]];
    //设置cell的选中样式为无
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
//    }
}

//当历史记录cell被点中时，进行数据请求
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //
//    HistoryCell_Search *cell = (HistoryCell_Search *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    [self searchWithString:_historyRecordsAry[indexPath.row]];
}

/// 删除当前cell
/// @param string 当前cell的string
- (void)deleteHistoryCellThroughString:(NSString *)string{
//    NSLog(@"删除该cell %@",string);
    //1.删除历史记录数组中的数据
    NSMutableArray *copyarray = [_historyRecordsAry mutableCopy];
    for ( NSString *cellString in copyarray) {
        if ([string isEqualToString:cellString]) {
            [copyarray removeObject:cellString];
            _historyRecordsAry = copyarray;
            [self.historyTable reloadData];
            break;
        }
    }
    //2.删除储存在本地的历史记录
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:_historyRecordsAry forKey:@"historyRecords"];
    
    NSLog(@"删除该cell");
}

/// 刷新历史记录表格
- (void)reloadHistoryRecord{
    _historyRecordsAry = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyRecords"];
    [self.historyTable reloadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
