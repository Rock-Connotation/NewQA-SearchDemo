//
//  SearchTopView.h
//  QA_Search
//
//  Created by 石子涵 on 2020/11/19.
//
/**
 这个view是最顶层，返回btn和搜索框的视图,可在“搜索首页”、“搜索结果页”两个界面复用
 */
#import <UIKit/UIKit.h>

#define MAIN_SCREEN_H [UIScreen mainScreen].bounds.size.height              //屏幕高度
#define MAIN_SCREEN_W [UIScreen mainScreen].bounds.size.width               //屏幕宽度

NS_ASSUME_NONNULL_BEGIN
@protocol SearchTopViewDelegate <NSObject>

/// 为UITextField自定义键盘上的toolBar
/// @param textField 需要自定义toolBar的UITextField
- (void)addKeyBoardToolBarforTextField:(UITextField*)textField;

/// 返回按钮跳回到“邮圈界面”
- (void)jumpBack;
@end

@interface SearchTopView : UIView
/// 代理
@property (nonatomic, strong) id<SearchTopViewDelegate>delegate;

/// 点击返回到“邮圈界面”的按钮
@property (nonatomic, strong) UIButton *backBtn;

/// 搜索框内的放大镜图标
@property (nonatomic, strong) UIImageView *searchIcon;

/// 搜索输入框
@property (nonatomic, strong) UITextField *searchTextfield;

/// 初始化方法
/// @param placeholderArray 传入提示搜索的内容，三个内容，每5秒轮转播放
- (void)initWithPlaceholders:(NSArray *)placeholderArray;

@end

NS_ASSUME_NONNULL_END
