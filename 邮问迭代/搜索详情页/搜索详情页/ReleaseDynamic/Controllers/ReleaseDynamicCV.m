//
//  ReleaseDynamicCV.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/8.
//

#import <Masonry.h>
#import <PhotosUI/PhotosUI.h>           //用于使用PHPicker
#import <MBProgressHUD.h>               //HUD提示

#import "ReleaseDynamicCV.h"
#import "RelaeseDynamicView.h"              //界面
#import "AddPhotosBtn.h"
#import "PhotoImageView.h"
#import "CircleLabelView.h"                 //底部的圈子标签的View
@interface ReleaseDynamicCV ()<UITextViewDelegate,UINavigationControllerDelegate,PHPickerViewControllerDelegate,PhotoImageViewDelegate,CircleLabelViewDelegate,ReleaseDynamicViewDelegate>

@property (nonatomic, strong) RelaeseDynamicView *releaseDynamicView;
/// 从相册中获取到的图片
@property (nonatomic, strong) NSMutableArray <UIImage *>* imagesAry;
@property (nonatomic, strong) NSMutableArray <UIImageView *>*imageViewArray;

/// 添加照片的按钮
@property (nonatomic, strong) AddPhotosBtn *addPhotosBtn;

/// 底部的圈子标签的View
@property (nonatomic, strong) CircleLabelView *circleLabelView;

/// 添加的文本标签
@property (nonatomic, copy) NSString *circleLabelText;

/// 点击发布按钮的次数
@property int clickReleaseDynamicBtnNumber;

@end

@implementation ReleaseDynamicCV
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:226/255.0 green:232/255.0 blue:238/255.0 alpha:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //添加主页面
    self.releaseDynamicView = [[RelaeseDynamicView alloc] init];
    self.releaseDynamicView.frame = self.view.frame;
    [self.view addSubview:self.releaseDynamicView];
    self.releaseDynamicView.delegate = self;        //主页面的view代理
    
        //设置TextView的代理
    self.releaseDynamicView.releaseTextView.delegate = self;
    
    //关于发布按钮的一些设置
    self.clickReleaseDynamicBtnNumber = 0;
    self.circleLabelText = @"未添加标签";
    
    //添加照片按钮和底部的分割View
    [self addPhotosBtnAndSparationView];
    
}

/// 添加照片按钮和底部圈子标签View
- (void)addPhotosBtnAndSparationView{
    //初始化图片和图片框数组
    self.imagesAry = [NSMutableArray array];
    self.imageViewArray = [NSMutableArray array];
    
    //添加图片按钮
    self.addPhotosBtn = [[AddPhotosBtn alloc] init];
    [self.view addSubview:self.addPhotosBtn];
    [self.addPhotosBtn addTarget:self action:@selector(addPhotos) forControlEvents:UIControlEventTouchUpInside];
    [self.addPhotosBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.releaseDynamicView.releaseTextView.mas_bottom).offset(7);
        make.left.equalTo(self.view).offset(16);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.296, MAIN_SCREEN_W * 0.296));
    }];
    
    //圈子标签View
    NSArray *titlearray = @[@"校园周边",@"海底捞",@"学习",@"运动",@"兴趣",@"问答",@"其他",@"123"];
    self.circleLabelView = [[CircleLabelView alloc] initWithArrays:titlearray];
    [self.view addSubview:self.circleLabelView];
    [self.circleLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.addPhotosBtn.mas_bottom).offset(MAIN_SCREEN_H * 0.0569);
    }];
    self.circleLabelView.delegate = self;
}

/// 添加图片
- (void)addPhotos{
    
    
    //配置PhPickerConfiguration
    PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
    
    //设置当前的选择模式
//    configuration.preferredAssetRepresentationMode = PHPickerConfigurationAssetRepresentationModeAutomatic;
    
    //设置最多只能选九张图片 如果设置为0，则是无限制选择。默认为1
    configuration.selectionLimit = 9;
    //设定只能选择图片  //设定为nil的时候图片、livePhoto、视频都可以选择
    configuration.filter = nil;
    
    //设置PHPickerController
    PHPickerViewController *pickerCV = [[PHPickerViewController alloc] initWithConfiguration:configuration];
    pickerCV.delegate = self;       //设置代理
    
    //弹出图片选择器
    [self presentViewController:pickerCV animated:YES completion:nil];
}

- (void)clearPhotoImageView:(UIImageView *)imageView{
    
    UIImage *image = imageView.image;
    //1.先删除照片组中的照片
    NSMutableArray *array = [self.imagesAry mutableCopy];
    for (UIImage *resultImage in array) {
        if ([resultImage isEqual:image]) {
            [array removeObject:resultImage];
            self.imagesAry = array;
            break;;
        }
    }
//    //2.再移除照片框
    [imageView removeFromSuperview];
    
    //3.重新布局
        //判断添加图片框是否还存在，不存在就创建
    [self imageViewsConstraint];
}

/// 添加的图片框的约束
- (void)imageViewsConstraint{
    //如果图片数组为0，则添加按钮回到初始的位置
    if (self.imagesAry.count == 0) {
        [self.addPhotosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.releaseDynamicView.releaseTextView.mas_bottom).offset(7);
            make.left.equalTo(self.view).offset(16);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.296, MAIN_SCREEN_W * 0.296));
        }];

        return;
    }
    
    // 清除之前所有的图片框
    if (self.imageViewArray.count > 0) {
        for (int i = 0; i < self.imageViewArray.count; i++) {
            UIImageView *imageView = self.imageViewArray[i];
            [imageView removeFromSuperview];
        }
        [self.imageViewArray removeAllObjects];
    }
    
    //清除图片数组里面大于9的的那些图片
    for (int i = 0; i < self.imagesAry.count; i++){
        if (i > 8) {
            UIImage *image = self.imagesAry[i];
            [self.imagesAry removeObject:image];
        }
    }
    
    //遍历图片数组，创建imageView,并对其进行约束
    for (int i = 0; i < self.imagesAry.count; i++) {
        PhotoImageView *imageView = [[PhotoImageView alloc] init];
        imageView.delegate = self;
        imageView.image = self.imagesAry[i];
        [self.imageViewArray addObject:imageView];
        [self.view addSubview:imageView];
        
        //约束图片框
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset( 15 + i%3 * (6 + MAIN_SCREEN_W * 0.296));
            make.top.equalTo(self.releaseDynamicView.releaseTextView.mas_bottom).offset(7 + i/3 * (MAIN_SCREEN_W * 0.296 + 5.5));
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.296, MAIN_SCREEN_W * 0.296));
        }];
    }
    
    //设置添加照片按钮的约束
    [self.addPhotosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15 + self.imageViewArray.count%3 * (6 + MAIN_SCREEN_W * 0.296));
        make.top.equalTo(self.releaseDynamicView.releaseTextView.mas_bottom).offset(7 + self.imageViewArray.count/3 * (MAIN_SCREEN_W * 0.296 + 5.5));
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.296, MAIN_SCREEN_W * 0.296));
    }];
    
    //如果图片框为9时，使添加图片按钮透明度为0,同时更新圈子标签view的约束
    if (self.imagesAry.count == 9) {
 //如果设置为去除的话，程序会崩溃
        self.addPhotosBtn.alpha = 0;
        
        //更新圈子标签view的约束
        [self.circleLabelView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo([self.imageViewArray lastObject].mas_bottom).offset(MAIN_SCREEN_H * 0.0569);;
        }];
    }else{
        self.addPhotosBtn.alpha = 1;
        //更新圈子标签view的约束
        [self.circleLabelView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.addPhotosBtn.mas_bottom).offset(MAIN_SCREEN_H * 0.0569);
        }];
    }
}

//设置点击空白处收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark- 代理相关
//MARK: UITextView的代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.releaseDynamicView.placeHolderLabel setHidden:YES];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];  //键盘的输入模式
    //当输入模式为简体中文时，进行限制字数
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectRange = [textView markedTextRange];
            //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectRange.start offset:0];
            //没有高亮选择的字，就对已经输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 500) {
                //此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
                NSRange finalRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 500)];
                textView.text = [toBeString substringWithRange:finalRange];

                /*
                 也可以直接使用以下方法显示最后的文本，但是这样可能会遇到emoji无法正常显示的问题.旧版邮问就有这样的问题
                 textField.text = [toBeString substringToIndex:MastNumber];
                 */
            }
            //如果没有文本就显示提示label,否则不显示
            if (toBeString.length == 0) {
                [self.releaseDynamicView.placeHolderLabel setHidden:NO];
            }else{
                [self.releaseDynamicView.placeHolderLabel setHidden:YES];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    //中文输入法以外就直接进行统计限制
    else{
        if (toBeString.length > 500) {
            NSRange finalRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 500)];
            textView.text = [toBeString substringWithRange:finalRange];
        }
    }
    //实时统计字数
    self.releaseDynamicView.numberOfTextLbl.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)textView.text.length, 500];
    
    //如果有文字则按钮可以使用，否则就是禁用
    if (toBeString.length > 0) {
        self.releaseDynamicView.releaseBtn.enabled = YES;
    }else{
        self.releaseDynamicView.releaseBtn.enabled = NO;
    }
    
    return YES;
}


//MARK:圈子标签的代理
- (void)clickACirleBtn:(UIButton *)sender{
    for (UIButton *button in self.circleLabelView.buttonArray) {
        if (button.tag != sender.tag) {
            [button setBackgroundImage:[UIImage imageNamed:@"圈子标签未选中背景"] forState:UIControlStateNormal];
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"圈子标签选中背景"] forState:UIControlStateNormal];
            self.circleLabelText = sender.titleLabel.text;
        }
//        NSLog(@"%@",sender.titleLabel.text);
    }
}

//MARK:PHPicker的代理方法
/// 选择器调用完之后会使用这个方法
/// @param picker 当前使用的图片选择器
/// @param results 选中的图片数组
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results{
    //使图片选择器消失
    [picker dismissViewControllerAnimated:YES completion:nil];
    for (int i = 0; i < results.count; i++) {
        //获取返回的对象
        PHPickerResult *result = results[i];
        //获取图片
        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            if ([object isKindOfClass:[UIImage class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    __weak typeof(self) weakSelf = self;
                    //如果图片大于九张，就删除掉前面选择的
                    if (weakSelf.imagesAry.count <= 9) {
//                        [weakSelf.imagesAry removeObjectAtIndex:0];
                        [weakSelf.imagesAry addObject:(UIImage *)object];
                    }
                    
                    
                    //遍历循环到最后一个时进行图片框的添加约束
                    dispatch_async(dispatch_get_main_queue(),^{
                        if (i == results.count - 1) {
                            [weakSelf imageViewsConstraint];
                        }
                    });
                });
            }
        }];
    }
}

//MARK:发布动态的View的代理 ReleaseDynamicViewDelegate
//为UItextView添加自定义toolBar
- (void)addKeyBoardToolBarforTextView:(UITextView *)textView{
//    [textView setKeyboardType:UIKeyboardTypeDefault];       //键盘样式为默认
    
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
    placeHolderLabel.text = self.releaseDynamicView.placeHolderLabel.text;
//    placeHolderLabel.text = textField.text;
    placeHolderLabel.font = [UIFont systemFontOfSize:13];
    placeHolderLabel.alpha = 0.8;
    placeHolderLabel.textColor = [UIColor systemGrayColor];
    [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(toolBar);
        make.top.equalTo(toolBar);
        make.bottom.equalTo(toolBar);
    }];
    
    textView.inputAccessoryView = toolBar;
}

- (void)doneClicked{
    [self.view endEditing:YES];             //键盘收回
}
//如果无内容，返回到上个界面，如果有内容就提示保存
- (void)pop{
   
    //1.无内容，返回到上个界面
    if (self.releaseDynamicView.releaseTextView.text.length == 0) {
        //跳回到邮圈
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    //2.有内容点击提示保存内容
    else{
        [self.view endEditing:YES];
        //遮罩层
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        view.backgroundColor = [UIColor blackColor];
        view.userInteractionEnabled = NO;               //设置禁用
        view.alpha = 0.5;
        [self.view addSubview:view];
        
        //警告提示列表 是否需要保存草稿
        UIAlertController *alertCv = [UIAlertController alertControllerWithTitle:@"是否保存草稿" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        //定义警告活动列表的按钮方法
            //发送网络请求，保存草稿，并且回到上一个界面
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [view removeFromSuperview];     //移除遮罩层
            NSLog(@"%@",self.releaseDynamicView.releaseTextView.text);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
            //不保存草稿，回到“圈子”界面
        UIAlertAction *noSaveAction = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
            //取消
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [view removeFromSuperview];     //移除遮罩层
        }];
        
        //为警告活动列表添加方法
        [alertCv addAction:saveAction];
        [alertCv addAction:noSaveAction];
        [alertCv addAction:cancelAction];
        
        //弹出警告活动列表
        [self presentViewController:alertCv animated:YES completion:nil];
    }
}

//发布动态
/**
 1.如果选择标签，就提示没有选择标签，如果不选择就归类到其他
 2.无网络连接提示无网络连接
 3.
 */
- (void)releaseDynamic{
    //如果未添加标签，则第一次提示未添加标签，第二次就直接归类到其他
    if ([self.circleLabelText isEqualToString:@"未添加标签"]) {
        self.clickReleaseDynamicBtnNumber++;
        //显示提示
        if (self.clickReleaseDynamicBtnNumber == 1) {
            //显示提示框
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud setMode:(MBProgressHUDModeText)];
            hud.label.text = @"未添加标签";
            [hud hideAnimated:YES afterDelay:1];    //延迟一秒后消失
        }else{
            self.circleLabelText = @"# 其他";
            [self updateDynamic];
        }
    }else{
        [self updateDynamic];
    }
//    NSLog(@"已经发布");
}

/// 网络上传动态
- (void)updateDynamic{
    NSLog(@"上传标签 %@",self.circleLabelText);
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
