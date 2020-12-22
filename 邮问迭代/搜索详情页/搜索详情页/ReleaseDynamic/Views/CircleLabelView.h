//
//  CircleLabelView.h
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/22.
//
/**圈子标签的view*/
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CircleLabelViewDelegate <NSObject>

/// 选中一个按钮
- (void)clickACirleBtn:(UIButton *)sender;

@end
@interface CircleLabelView : UIView
/// 顶部的分割条
@property (nonatomic, strong) UIView *topSeparationView;

@property (nonatomic, strong) UILabel *tittleLbl;

/// button数组
@property (nonatomic, strong) NSMutableArray <UIButton*>*buttonArray;

@property (nonatomic, weak) id<CircleLabelViewDelegate> delegate;
/// 通过一个数组初始化
/// @param array 里面包含着button的文字
- (instancetype)initWithArrays:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
