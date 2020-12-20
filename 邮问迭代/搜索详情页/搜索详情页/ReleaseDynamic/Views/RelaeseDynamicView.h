//
//  RelaeseDynamicView.h
//  搜索详情页
//
//  Created by 石子涵 on 2020/12/20.
//

#import <UIKit/UIKit.h>
//屏幕宽高
#define MAIN_SCREEN_H [UIScreen mainScreen].bounds.size.height
#define MAIN_SCREEN_W [UIScreen mainScreen].bounds.size.width

NS_ASSUME_NONNULL_BEGIN
@protocol ReleaseDynamicViewDelegate <NSObject>

/// 返回到上一个界面
- (void)pop;

/// 发布动态
- (void)releaseDynamic;
@end

@interface RelaeseDynamicView : UIView
/// 代理
@property (nonatomic, weak) id<ReleaseDynamicViewDelegate> delegate;

/// 发布动态的按钮
@property (nonatomic, strong) UIButton *releaseBtn;

/// 发布动态文本内容输入框
@property (nonatomic, strong) UITextView *releaseTextView;
@property (nonatomic, strong) UILabel *numberOfTextLbl; //显示字数的label
@end

NS_ASSUME_NONNULL_END
