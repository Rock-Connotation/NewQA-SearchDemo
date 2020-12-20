//
//  PhotoImageView.h
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/21.
//
/**添加图片的UIImageView*/
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  PhotoImageViewDelegate <NSObject>

- (void)clearPhotoImageView:(UIImageView *)imageView;

@end
@interface PhotoImageView : UIImageView
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, weak) id<PhotoImageViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
