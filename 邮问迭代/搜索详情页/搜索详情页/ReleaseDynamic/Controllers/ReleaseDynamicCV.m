//
//  ReleaseDynamicCV.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/8.
//

#import <Masonry.h>
#import <PhotosUI/PhotosUI.h>           //用于使用PHPicker
    
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
    self.releaseDynamicView.delegate = self;
        //设置TextView的代理
    self.releaseDynamicView.releaseTextView.delegate = self;
    
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
//        [self.addPhotosBtn removeFromSuperview];  //如果设置为去除的话，程序会崩溃
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
//如果无内容，返回到上个界面，如果有内容就提示保存
- (void)pop{
    //1.有内容，返回到上个界面
    if (self.releaseDynamicView.releaseTextView.text.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //2.无内容第一次点击提示保存内容，第二次就直接返回，并且将内容保存
}

//发布动态
/**
 1.如果选择标签，就提示没有选择标签，如果不选择就归类到其他
 2.无网络连接提示
 3.
 */
- (void)releaseDynamic{
    NSLog(@"已经发布");
}
@end
