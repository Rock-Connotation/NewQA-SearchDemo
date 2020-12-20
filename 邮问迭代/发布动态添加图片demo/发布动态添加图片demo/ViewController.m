//
//  ViewController.m
//  发布动态添加图片demo
//
//  Created by 石子涵 on 2020/12/9.
//

/*参考文章： 从上到下看，更容易理解，包括developer上的官方视频讲解
 https://www.jianshu.com/p/989675debaf1  这个讲解的更全面，但是代码演示只有swift，也不全
 https://www.jianshu.com/p/5e7aacfa4374  这个讲解的没下面那个全面，但是有OC代码演示


 */
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "ViewController.h"

@interface ViewController ()<UINavigationControllerDelegate,PHPickerViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray <UIImage *>*imagesArray;

@property (nonatomic, strong) UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagesArray = [NSMutableArray array];
    
    //添加buttton
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(addImages) forControlEvents:UIControlEventTouchUpInside];
    
    //添加scrollerView
    
    
}
///// 从相册中获取图片,单张
//- (void)addImages{
//    UIImagePickerController *pickerCV= [[UIImagePickerController alloc] init];
//    //取出所有图片资源的相簿
//    pickerCV.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//
//    pickerCV.delegate = self;
//
//    [self presentViewController:pickerCV animated:YES completion:nil];
//}

///// 选择完毕执行的方法
///// @param picker 模态出的控制器
///// @param info 含有图片信息的字典
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
//    [picker dismissViewControllerAnimated:YES completion:nil];      //消失
//
//    //取出选中的图片
//    UIImageView *imgView = [[UIImageView alloc] init];
//    imgView.frame = CGRectMake(100, 100, 200, 200);
//    imgView.image = info[UIImagePickerControllerOriginalImage];
//    [self.view addSubview:imgView];
//
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    [self.imagesArray addObject:image];
////    for (UIImage *image in info[UIImagePickerControllerOriginalImage]) {
////        [self.imagesArray addObject:image];
////    }
//    NSLog(@"选中了%@",self.imagesArray);
//}



/// 从相册中获取图片,多张
- (void)addImages{
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
//    NSLog(@"点击button过后会有的方法%lu",(unsigned long)self.imagesArray.count);
}

//MARK:PHPicker的代理方法
/// 选择器调用完之后会使用这个方法
/// @param picker 当前使用的图片选择器
/// @param results 选中的图片数组
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results{
    //使图片选择器消失
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%lu",(unsigned long)results.count);
    
   //获取选中的图片
//    for (PHPickerResult *result in results) {
//        NSLog(@"选取后的每一个结果是%@",result);
//        //获取图片
//        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
//            if ([object isKindOfClass:[UIImage class]]) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //使用照片
//                    [self.imagesArray addObject:(UIImage *)object];
//                    NSLog(@"现在数组哪有%lu张图片,内容为%@",(unsigned long)self.imagesArray.count, self.imagesArray);
//                    UIImageView *imageView = [[UIImageView alloc] init];
//                    imageView.contentMode = UIViewContentModeScaleAspectFit;
//                    imageView.image = self.imagesArray.lastObject;
//                    imageView.frame = CGRectMake(100, 100, 200, 200);
//                    [self.view addSubview:imageView];
//                });
//            }
//        }];
//    }
    
    for (int i = 0; i < results.count; i++) {
        //获取返回的对象
        PHPickerResult *result = results[i];
        //获取图片
        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            if ([object isKindOfClass:[UIImage class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imagesArray addObject:(UIImage *)object];

                    if (i == results.count -1 ) {
                        dispatch_async(dispatch_get_main_queue(),^{
                            UIImageView *imageView = [[UIImageView alloc] init];
                            imageView.contentMode = UIViewContentModeScaleAspectFit;
                            imageView.image = self.imagesArray.lastObject;
                            imageView.frame = CGRectMake(100, 100, 200, 200);
                            [self.view addSubview:imageView];
                            
                            NSLog(@"选中的图片个数为%d",self.imagesArray.count);
                        });
                    }

                });
            }
        }];
    }
}

@end
