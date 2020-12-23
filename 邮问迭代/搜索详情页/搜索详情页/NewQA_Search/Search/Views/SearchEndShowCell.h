//
//  SearchEndShowCell.h
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/22.
//
/**搜索结果页展示相关动态的cell*/
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchEndShowCell : UITableViewCell
/// 展示头像的图片框
@property (nonatomic, strong) UIImageView *iconImageView;

/// 用户名
@property (nonatomic, strong) UILabel *userLabel;

/// 发布时间
@property (nonatomic, strong) UILabel *timeLaebl;

/// 展示内容的label
@property (nonatomic, strong) UILabel *contentLabel;

/// 保存图片的数组
@property (nonatomic, strong) NSArray <UIImage *>*imagesAry;

/// 圈子标签
@property (nonatomic, strong) UILabel *circleLbel;

@end

NS_ASSUME_NONNULL_END
