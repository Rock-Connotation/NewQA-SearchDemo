//
//  PhotoCollectionViewCell.h
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PhotoCollectionViewCellDelegate <NSObject>

/// 清除当前的图片cell
- (void)clearPhotoCell;

@end

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
/// 清除此cell的按钮
@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, weak) id<PhotoCollectionViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
