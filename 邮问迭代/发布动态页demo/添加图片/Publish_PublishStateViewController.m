//
//  Publish_PublishStateViewController.m
//  CyVOD
//
//  Created by mac on 2018/1/19.
//  Copyright © 2018年 Bob. All rights reserved.
//

#import "Publish_PublishStateViewController.h"
#import "YYKit.h"
#import "Publish_SelectCommunityViewController.h"
#import "addCase_PhotoCollectionViewCell.h"
#import "User.h"
#import "Networking.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "NSString+BobStr.h"
#import "appendixSelectViewController.h"
#import <WebKit/WebKit.h>

//#import "CheckBox.h"

@interface Publish_PublishStateViewController ()<CommunitySelectDelegate,UICollectionViewDelegate,UICollectionViewDataSource,addCase_PhotoCollectionViewCelldelegate,TZImagePickerControllerDelegate,YYTextViewDelegate,UIDocumentPickerDelegate,WKNavigationDelegate,WKUIDelegate>
{
    bool isEditing;
    NSString* _responseImagePaths;
    NSString* _responseAppendixPath;
}
///动态输入
@property(nonatomic,strong)YYTextView *stateInputTextView;

///动态输入和图片选择之间的分割线
@property(nonatomic,strong)UIView *seperatorView;

///图片选择
@property (retain, nonatomic)  UICollectionView *photoCollectionView;

///圈子选择标题
@property(nonatomic,strong)UILabel *communitySelectTitleLable;
///圈子选择
@property(nonatomic,strong)UILabel *communitySelectLable;
///分割线
@property(nonatomic,strong)UIView *seperatorView1;
@property(nonatomic,strong)UIView *seperatorView2;
@property(nonatomic,strong)UIView *seperatorView3;
@property(nonatomic,strong)Community *community;


@property(nonatomic,strong)NSMutableArray *photoArray;

//缩放图片
@property(nonatomic,strong)UIImageView *fullImageView;
//附件选择标题
@property(nonatomic,strong)UILabel *appendixSelectTitleLable;
//附件选择
@property(nonatomic,strong)UILabel *appendixSelectLable;

@property (nonatomic,strong) WKWebView * myWebView;

//时间控制label
//@property(nonatomic,strong)UILabel *timeLabel;
//@property(nonatomic,strong)UILabel *spaceLabel;
//@property (nonatomic,strong) CheckBox * timeBox;
//@property (nonatomic,strong) CheckBox * spaceBox;
//@property (nonatomic,strong) CheckBox * timeControllerBox;//时效控制，1，3，5天
//@property (nonatomic,strong) NSString * isDeleAfterRead;//是否阅后即焚 1是 0 否
//@property (nonatomic,strong) NSString * DeleTime;//删除日期 无代表没有
//@property (nonatomic,strong) NSString * city;//选择t同城可见的时候有值

@end

static const int maxPhotoNum = 9;

@implementation Publish_PublishStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //925
//      if (@available(iOS 13.0, *) )  {
//             self.overrideUserInterfaceStyle=UIBlurEffectStyleLight;
//         }
    _photoArray=[[NSMutableArray alloc]init];
    [_photoArray addObject:[UIImage imageNamed:@"jia"]];
    isEditing = NO;
    
    [self setNavi];
    [self createUI];
    [self setConstraints];
    [self addAction];
    //新增代码
    self.myWebView.navigationDelegate=self;
    self.myWebView.UIDelegate=self;
     //侧滑返回上层
  self.myWebView.allowsBackForwardNavigationGestures = YES;
    
}

#pragma mark-----UI-----

- (void)setNavi {
    self.navigationItem.title = @"发布科技动态";
    self.navigationController.navigationBar.barTintColor = RGB(MAIN_COLOR);
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 48, 24);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    
     UIButton *publishStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    publishStateButton.frame = CGRectMake(0, 0, 48, 24);
    publishStateButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [publishStateButton setTitle:@"发表" forState:UIControlStateNormal];
    publishStateButton.titleLabel.font = [UIFont systemFontOfSize:16];
     [publishStateButton addTarget:self action:@selector(doPublishState) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:publishStateButton];
}

- (void)doBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)doPublishState {
    [self.view endEditing:YES];
    
    if (self.stateInputTextView.text.length == 0 && self.photoArray.count==1) {
        [HHAlertView showAlertAndMessage:@"动态内容和图片至少有一项不能为空"];
        return;
    }
    if (_community == nil) {
        [HHAlertView showAlertAndMessage:@"还未选择要发布的圈子"];
        return;
    }
   
//    if (_community.communityId == @"183") {
//        [HHAlertView showAlertAndMessage:@"不可选择供给需求圈子"];
//        return;
//    }
//    if (self.photoArray.count>1) {
//        NSMutableArray * dataArray = [NSMutableArray array];
//        for (int i=0; i<self.photoArray.count-1; i++) {
//            [dataArray addObject:[self imageData:self.photoArray[i]]];
//        }
//        [self uploadImage:dataArray];
//
//    }else {
//        if (self.stateInputTextView.text.length>0)
//            [self commitState:nil];
//    }
////    if (self.photoArray.count>1 || self.appendixName) {
//       dispatch_group_t group =  dispatch_group_create();
       if (self.photoArray.count>1) {

         NSMutableArray * dataArray = [NSMutableArray array];
        for (int i=0; i<self.photoArray.count-1; i++) {
            [dataArray addObject:[self imageData:self.photoArray[i]]];
        }
           [self uploadImage:dataArray];
        }else if (self.appendixData) {
            [self uploadAppendix];
        }else {
        [self commitState:nil];
    }
    }
    
    
- (void)createUI {
    _stateInputTextView = [[YYTextView alloc]init];
    _stateInputTextView.delegate = self;
    _stateInputTextView.textContainerInset=UIEdgeInsetsMake(10, 10, 0, 10);
    _stateInputTextView.placeholderText = @"这一刻的想法";
    _stateInputTextView.font = [UIFont systemFontOfSize:14];
    _stateInputTextView.tintColor = [UIColor blackColor];
    [self.view addSubview:_stateInputTextView];
    
    _seperatorView = [[UIView alloc]init];
    _seperatorView.backgroundColor = RGB(0xf5f5f5);
    [self.view addSubview:_seperatorView];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumLineSpacing = 5;//每行中，item的间距
    layout.minimumInteritemSpacing = 5;//两列之间的间距
    layout.itemSize=CGSizeMake((kScreenWidth-25)/4,(kScreenWidth-25)/4);
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    _photoCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 202, kScreenWidth, 128) collectionViewLayout: layout];
    _photoCollectionView.backgroundColor=[UIColor whiteColor];
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"addCase_PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"photoId"];
    [self.view addSubview:_photoCollectionView];
    
    _seperatorView1 = [[UIView alloc]init];
    _seperatorView1.backgroundColor = RGB(0xf5f5f5);
    [self.view addSubview:_seperatorView1];
    
    
    _communitySelectTitleLable = [[UILabel alloc]init];
    _communitySelectTitleLable.font = [UIFont systemFontOfSize:14];
    _communitySelectTitleLable.text = @"选择圈子";
    [self.view addSubview:_communitySelectTitleLable];
    
    _communitySelectLable = [[UILabel alloc]init];
    _communitySelectLable.font = [UIFont systemFontOfSize:14];
    //_communitySelectLable.textColor = _stateInputTextView.placeholderTextColor;
    _communitySelectLable.text = @"请选择";
    [self.view addSubview:_communitySelectLable];
    
   
    
    _appendixSelectTitleLable = [[UILabel alloc]init];
    _appendixSelectTitleLable.font = [UIFont systemFontOfSize:14];
    _appendixSelectTitleLable.text = @"添加附件";
    [self.view addSubview:_appendixSelectTitleLable];
    
    _appendixSelectLable = [[UILabel alloc]init];
     _appendixSelectLable.font = [UIFont systemFontOfSize:14];
    _appendixSelectLable.text = self.appendixName?self.appendixName:@"可选择一个附件";
    
    _appendixSelectLable.textColor=RGB(MAIN_COLOR);
    [self.view addSubview:_appendixSelectLable];
    
    _seperatorView3 = [[UIView alloc]init];
    _seperatorView3.backgroundColor = RGB(0xf5f5f5);
    [self.view addSubview:_seperatorView3];
    
    //设置默认圈子
//    _community = [[Community alloc]init];
//    _community.communityId=@"60";
//    _community.communityName = @"晒我的";
//
    _communitySelectLable.textColor = RGB(MAIN_COLOR);
    //_communitySelectLable.text = @"晒我的";
    
    _seperatorView2 = [[UIView alloc]init];
    _seperatorView2.backgroundColor = RGB(0xf5f5f5);
    [self.view addSubview:_seperatorView2];
//    _timeLabel=[[UILabel alloc]init];
//    _timeLabel.text=@"时间控制";
//    _timeLabel.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:_timeLabel];
//        CheckBox *timeBox=[[CheckBox alloc]initWithItemTitleArray:@[@"始终可见",@"阅后即焚",@"时效控制"] columns:1];
//    [self.view addSubview:timeBox];
//    [timeBox setFrame:CGRectMake(self.timeLabel.frame.size.width+60, KSCREEN_HEIGHT/2+40, 100,80)];
//    [timeBox setTextFont:[UIFont systemFontOfSize:14]];
//    [timeBox setTextColor:[UIColor redColor]];
//    [timeBox setNormalImage:[UIImage imageNamed:@"icon_check_n"]];
//    [timeBox setSelectedImage:[UIImage imageNamed:@"icon_check_s"]];
//   timeBox.delegate = self;
//      _timeBox = timeBox;
//    _spaceLabel=[[UILabel alloc]init];
//    _spaceLabel.text=@"空间控制";
//    _spaceLabel.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:_spaceLabel];
//    _spaceBox = [[CheckBox alloc]initWithItemTitleArray:@[@"全网可见",@"同城可见"] columns:1];
//      [self.view addSubview:_spaceBox];
//    [_spaceBox setFrame:CGRectMake(self.timeBox.frame.origin.x, KSCREEN_HEIGHT/2+130, 100,80)];
//    [_spaceBox setTextColor:[UIColor redColor]];
//    [_spaceBox setTextFont:[UIFont systemFontOfSize:14]];
//    [_spaceBox setNormalImage:[UIImage imageNamed:@"icon_check_n"]];
//    [_spaceBox setSelectedImage:[UIImage imageNamed:@"icon_check_s"]];
//    _spaceBox.delegate = self;
//     _timeControllerBox = [[CheckBox alloc]initWithItemTitleArray:@[@"1天",@"3天",@"5天"] columns:3];
//       [self.view addSubview:_timeControllerBox];
//       [_timeControllerBox setFrame:CGRectMake(self.timeBox.frame.origin.x + 100, (self.timeBox.frame.origin.y+25), 200,80)];
//       [_timeControllerBox setTextColor:[UIColor redColor]];
//       [_timeControllerBox setTextFont:[UIFont systemFontOfSize:14]];
//       [_timeControllerBox setNormalImage:[UIImage imageNamed:@"icon_check_n"]];
//       [_timeControllerBox setSelectedImage:[UIImage imageNamed:@"icon_check_s"]];
//       _timeControllerBox.delegate = self;
//       _timeControllerBox.hidden = YES;
    
}

- (void)setConstraints {
    [_stateInputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT(150));
    }];
    
    [_seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_stateInputTextView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [_photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_seperatorView.mas_bottom);
        make.height.mas_equalTo(128);
        //make.height.mas_equalTo(0);
    }];
    
    [_seperatorView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_photoCollectionView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [_communitySelectTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(self.view).with.mas_offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(WIDTH(80));
        make.top.equalTo(self.seperatorView1.mas_bottom).with.mas_offset(8);
    }];
    
    [_communitySelectLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(_communitySelectTitleLable.mas_right).with.mas_offset(WIDTH(15));
        make.height.top.equalTo(_communitySelectTitleLable);
        make.right.equalTo(self.view).with.mas_offset(-WIDTH(15));
    }];
    
    [_seperatorView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_communitySelectTitleLable.mas_bottom).with.mas_offset(8);
        make.height.mas_equalTo(1);
    }];
    
    [_appendixSelectTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.mas_offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(WIDTH(80));
        make.top.equalTo(self.seperatorView2.mas_bottom).mas_offset(8);
    }];
    
    [_appendixSelectLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_appendixSelectTitleLable.mas_right).with.mas_offset(WIDTH(15));
        make.height.top.equalTo(_appendixSelectTitleLable);
        make.right.equalTo(self.view).with.mas_offset(-WIDTH(15));
    }];
    
    [_seperatorView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_appendixSelectTitleLable.mas_bottom).with.mas_offset(8);
        make.height.mas_equalTo(1);
    }];
//     [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.view).with.mas_offset(10);
//         make.top.equalTo(self.seperatorView3.mas_bottom).with.mas_offset(40);
//           make.height.mas_equalTo(30);
//       }];
//    [_spaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.timeLabel.mas_left);
//        make.top.equalTo(self.timeLabel.mas_bottom).with.mas_offset(60);
//        make.height.mas_equalTo(30);
//    }];
}

- (void)addAction {
    
    __weak typeof(self) weakSelf = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf.view endEditing:YES];
        Publish_SelectCommunityViewController *selectCommunityVC = [[Publish_SelectCommunityViewController alloc]init];
        selectCommunityVC.delegate = weakSelf;
       NSLog(@"info3=%@,id3=%@",[User sharedInstance].info,[User sharedInstance].userId);
        selectCommunityVC.modalPresentationStyle=UIModalPresentationFullScreen;
//       [weakSelf.navigationController presentViewController:selectCommunityVC animated:YES completion:nil];
     [weakSelf.navigationController pushViewController:selectCommunityVC animated:YES];
    }];
    _communitySelectLable.userInteractionEnabled = YES;
    [_communitySelectLable addGestureRecognizer:tapGesture];
    
    //对附件显示的webview进行设置
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf.view endEditing:YES];
//     appendixSelectViewController *appendixSelectVC = [[appendixSelectViewController alloc]init];
//       appendixSelectVC.delegate = weakSelf;
//       appendixSelectVC.modalPresentationStyle=UIModalPresentationFullScreen;
//        [weakSelf.navigationController pushViewController:appendixSelectVC animated:YES];
        [weakSelf presentDocumentPicker];
    }];
    _appendixSelectLable.userInteractionEnabled = YES;
    [_appendixSelectLable addGestureRecognizer:tapGesture1];
    

    //对图片显示的collectionview进行设置
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
  action:@selector(respondsToGesture:)];
    // photoCollectionView.modalPresentationStyle=UIModalPresentationFullScreen;
    [self.photoCollectionView addGestureRecognizer:longGesture];
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isContainsTwoEmoji]) {
        return NO;
    }
    return YES;
}

#pragma mark *** Gestures ***
- (void)respondsToGesture:(UIGestureRecognizer *)gesture {
    if (!isEditing) {
        isEditing=YES;
        [self.photoCollectionView reloadData];
    }
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // 监听手势状态
    switch (gesture.state) {
            // 1、手势开始
        case UIGestureRecognizerStateBegan: {
            // 获取手势长按位置
            NSIndexPath *indexPath = [self.photoCollectionView indexPathForItemAtPoint:[gesture locationInView:self.photoCollectionView]];
            // 开始在特定的索引路径上对cell（单元）进行Interactive Movement（交互式移动工作）
            [self.photoCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            
        }
            break;
            // 2、手势变换
        case UIGestureRecognizerStateChanged: {
            // 在手势作用期间更新交互移动的目标位置。
            NSIndexPath *path=[self.photoCollectionView indexPathForItemAtPoint:[gesture locationInView:self.photoCollectionView]];
            if (path.row!=_photoArray.count-1) {
                [self.photoCollectionView updateInteractiveMovementTargetPosition:[gesture locationInView:self.photoCollectionView]];
            }
        }
            break;
            // 3、手势结束
        case UIGestureRecognizerStateEnded: {
            // 在完成手势动作后，结束交互式移动
            [self.photoCollectionView endInteractiveMovement];
        }
            break;
        default: {
            // 4、默认状态下，取消Interactive Movement。
            [self.photoCollectionView cancelInteractiveMovement];
        }
            break;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellId=@"photoId";
    addCase_PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.delegate=self;
    cell.indexPath=indexPath;
    
    cell.image=[_photoArray objectAtIndex:indexPath.item];
    
    if (isEditing&&(indexPath.item!=_photoArray.count-1)) {
        NSLog(@"------%ld--",indexPath.item);
        cell.deleteButton.hidden = NO;
    }else
    {
        cell.deleteButton.hidden = YES;
    }
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_photoArray.count-1 == maxPhotoNum) {
        [HHAlertView showAlertAndMessage:[NSString stringWithFormat:@"最多可选择%d张照片",maxPhotoNum]];
        return;
    }
    if (indexPath.row==_photoArray.count-1) {
        [self doClickPhotoButton];
    }else{
        //缩放图片
        CGRect frame = [collectionView convertRect:[collectionView cellForItemAtIndexPath:indexPath].frame toView:collectionView];
        frame = [collectionView convertRect:frame toView:[UIApplication sharedApplication].keyWindow];
        self.fullImageView = [[UIImageView alloc]initWithFrame:frame];
        self.fullImageView.image = [_photoArray objectAtIndex:indexPath.item];
        self.fullImageView.backgroundColor = [UIColor blackColor];
        self.fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.fullImageView.userInteractionEnabled = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.fullImageView];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
           
            [UIView animateWithDuration:0.2 animations:^{
                self.fullImageView.frame = frame;
            }completion:^(BOOL finished) {
                [self.fullImageView removeFromSuperview];
                self.fullImageView = nil;
            }];
        }];
        
        [self.fullImageView addGestureRecognizer:tapGes];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.fullImageView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT);
        }];
    }
    
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.row==_photoArray.count-1) {
        return NO;
    }
    return  YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
    [_photoArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

- (void)doClickPhotoButton {
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    imagePickerVC.naviBgColor = RGB(MAIN_COLOR);
    imagePickerVC.allowPickingOriginalPhoto = NO;
    imagePickerVC.allowPickingImage = YES;
    imagePickerVC.allowPickingVideo = NO;
    imagePickerVC.maxImagesCount = maxPhotoNum - (self.photoArray.count -1);
    imagePickerVC.autoDismiss = NO;
    imagePickerVC.pickerDelegate = self;
    imagePickerVC.sortAscendingByModificationDate = NO;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

-(void)loadDocument:(NSString *)documentName inView:(WKWebView *)webView
{
    //新增代码
//    self.myWebView.navigationDelegate=self;
//    self.myWebView.UIDelegate=self;
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    for (UIImage *img in photos) {
            [_photoArray insertObject:img atIndex:_photoArray.count-1];
            [self.photoCollectionView reloadData];
     
        [picker dismissViewControllerAnimated:YES completion:^{
            [self.photoCollectionView reloadData];
        }];
    }
    [self.photoCollectionView reloadData];
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark--addCase_PhotoCollectionViewCelldelegate的代理方法--
-(void)deleteCollectionCell:(NSIndexPath *)indexPath
{
    [_photoArray removeObjectAtIndex:indexPath.item];
    //[self.photoCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    [self.photoCollectionView reloadData];
}

#pragma mark-----数据-----
- (void)SelectCommunity:(Community *)community {
    _community = community;
    _communitySelectLable.textColor = RGB(MAIN_COLOR);
    _communitySelectLable.text = community.communityName;
    
}

#pragma mark压缩图片
-(NSData *)imageData:(UIImage *)myimage{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);    if (data.length>100*1024) {
        if (data.length>1024*1024) {
            data=UIImageJPEGRepresentation(myimage, 0.3);       }else if (data.length>512*1024) {//0.5M-1M
                data=UIImageJPEGRepresentation(myimage, 0.5);
            }else if (data.length>200*1024) {//0.25M-0.5M
                data=UIImageJPEGRepresentation(myimage, 0.9);
            }
    }
    return data;
}

#pragma mark-----网络-----

#pragma mark 上传动态图片

-(void)uploadImage:(NSArray *)imageArray {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.color = RGB(MAIN_COLOR);
    hud.detailsLabelText = @"正在上传";
    [Networking httpUpdateRequestWithUrlSting:[NSString stringWithFormat:@"%@%@",BASEURL,@"UploadQuanZi"] withParameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSData *data in imageArray) {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:date];
            [formData appendPartWithFileData:data name:@"" fileName:[NSString stringWithFormat:@"%@_%d.jpg",dateString, arc4random() % 100] mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [hud hide:YES];
         _responseImagePaths = [responseObject substringFromIndex:8];
        if (self.appendixData) {
            [self uploadAppendix];
        }else {
           [self commitState:nil];
        }
       
      //  [self commitState:[responseObject substringFromIndex:8]];
//        [self commitState:[responseObject substringFromIndex:8]];
        
        
    } failure:^(NSError * _Nullable error) {
        [hud hide:YES];
    } isShowHUD:NO];
}


-(void)uploadAppendix {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.color = RGB(MAIN_COLOR);
    hud.detailsLabelText = @"正在上传";
    [Networking httpUpdateRequestWithUrlSting:[NSString stringWithFormat:@"%@%@",BASEURL,@"UploadFujian"] withParameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:self.appendixData name:@"" fileName:self.appendixName mimeType:@"application/pdf"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [hud hide:YES];
        _responseAppendixPath = [responseObject substringFromIndex:8];
        //[self commitState:[responseObject substringFromIndex:8]];
        [self commitState:nil];
        
    } failure:^(NSError * _Nullable error) {
        
    } isShowHUD:NO];
    }


#pragma mark 发布动态
- (void)commitState:(NSString *)imagePathString {
    //NSString *content = [_stateInputTextView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary: @{@"UserId":[User sharedInstance].userId,@"CircleId":_community.communityId,@"Contents":_stateInputTextView.text}];
    if (_responseImagePaths) {
        [dic setValue:_responseImagePaths forKey:@"Images"];
    }
    if (_responseAppendixPath) {
         [dic setValue:_responseAppendixPath forKey:@"Fujian"];
    }
    
    [Networking httpPostRequestWithInterface:@"SetCircleDynamic" andParameter:@{@"info":dic} success:^(id responseObject) {
        if ([responseObject isEqualToString:@"True"]) {
            [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"发表成功" detail:nil cancelButton:nil Okbutton:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HHAlertView Hide];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
            //行为监控
                   
        //    [WUserStatistics sendEventToServer:@"71"];
        }else{
            [HHAlertView showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"发表失败" detail:nil cancelButton:nil Okbutton:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HHAlertView Hide];
            });
        }
    } failure:^(NSError *error) {
        
    } isShowProgress:NO];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    BOOL canAccessingResource = [url startAccessingSecurityScopedResource];
    if(canAccessingResource) {
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
          
            NSData *fileData = [NSData dataWithContentsOfURL:newURL];
            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath = [arr lastObject];
          NSString *desFileName = [documentPath stringByAppendingPathComponent:@"myFile"];
            self.appendixData = fileData;
            self.appendixName = [newURL lastPathComponent];
            self.appendixPath = documentPath;
//            NSString *fileName = [info objectForKey:@"fileName"];
            // /private/var/mobile/Containers/Data/Application/83643509-E90E-40A6-92EA-47A44B40CBBF/Documents/Inbox/jfkdfj123a.pdf
            //NSString *filePath = [info objectForKey:@"filePath"];
//            [fileData writeToFile:desFileName atomically:YES];
            //[self dismissViewControllerAnimated:YES completion:NULL];
        }];
        if (error) {
            // error handing
        }
    } else {
        // startAccessingSecurityScopedResource fail
    }
    [url stopAccessingSecurityScopedResource];
}
#pragma mark 上传附件
- (void)uploadData{
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.shareteches.com/WebService.asmx/"]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:20];
    NSDictionary * dataDic = @{@"key":@"value"};
    //把要上传的数据存到字典中
    NSData * data = [NSJSONSerialization dataWithJSONObject:dataDic
                                                    options:NSJSONWritingPrettyPrinted
                                                      error:nil];
    NSURLSessionUploadTask * uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            //NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        }else{
            NSLog(@"上传失败");
        }
    }];
    [uploadTask resume];
}




#pragma mark 上传动态图片
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    if (isEditing) {
        isEditing = YES;
        [self.photoCollectionView reloadData];
    }
}

- (void)presentDocumentPicker {
//    NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
        NSArray *documentTypes = @[@"com.adobe.pdf"];
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes
                                                                                                                          inMode:UIDocumentPickerModeOpen];
    documentPickerViewController.delegate = self;
    [self presentViewController:documentPickerViewController animated:YES completion:nil];
}

- (void)setAppendixName:(NSString *)appendixName {
    _appendixName= appendixName;
    _appendixSelectLable.text = appendixName;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
