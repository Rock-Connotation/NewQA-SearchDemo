//
//  KnowledgeView.m
//  QA_Search
//
//  Created by 石子涵 on 2020/11/23.
//

#import "KnowledgeView.h"
#import "HotSearchBtn.h"
#import <Masonry.h>
#import <Foundation/Foundation.h>

#define MAIN_SCREEN_H [UIScreen mainScreen].bounds.size.height
#define MAIN_SCREEN_W [UIScreen mainScreen].bounds.size.width

#define SPLIT 7//item间距
#define LINESPLIT 10//行间距

@interface KnowledgeView()
@property (nonatomic, assign) ViewType viewType;

@end
@implementation KnowledgeView
- (instancetype)initWithLabelString:(NSString *)string ButtonArry:(NSArray *)array andViewType:(ViewType)viewType{
    self = [super init];
    if (self) {
        self.viewType = viewType;
        //添加标题label
        [self addHotSearch_KnowledgeLabel:string];
        //添加下面的按钮
        [self addBtns:array];
        //排列按钮，使其自动换行
        [self btnsAddConstraints];
    }
    return  self;
}

/// 添加“邮问知识库”或“热门搜索”标题的文字
/// @param string 标题文本内容
- (void)addHotSearch_KnowledgeLabel:(NSString *)string{
    self.hotSearch_KnowledgeLabel = [[UILabel alloc] init];
    self.hotSearch_KnowledgeLabel.text = string;            //赋值文字
        //设置字体
    self.hotSearch_KnowledgeLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        //设置字体颜色
    self.hotSearch_KnowledgeLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    [self addSubview:self.hotSearch_KnowledgeLabel];
        //此处不需要约束宽与高，自适应
    [self.hotSearch_KnowledgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
    }];
}


/// 添加下面的热门搜索或者重邮知识库
/// @param btnTextAry btn的title数组
- (void)addBtns:(NSArray *)btnTextAry{
    for (NSString *text in btnTextAry) {
        HotSearchBtn *button = [[HotSearchBtn alloc] init];
        [button setTitle:text forState:UIControlStateNormal];   //设置btn的标题文本
        
        //判断创建的是哪一个页面，决定按钮触碰后会执行什么方法
        if (self.viewType == ViewTypeHotSearch) {
            [button addTarget:self.delegate action:@selector(touchHotSearchBtns) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [button addTarget:self.delegate action:@selector(touchCQUPTKonwledge) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self addSubview:button];
        
        //将创建的buttons保存起来
        [self.buttonArray addObject:button];
    }
}

///为btns添加约束，让它自动换行等等
- (void)btnsAddConstraints{
    if (self.buttonArray.count == 0) return;
    __block int k = 0;
    [self.buttonArray[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hotSearch_KnowledgeLabel.mas_bottom).offset(LINESPLIT);
            make.left.equalTo(self);
    }];
    __block float lastBtnW,lastBtnX;
    for (int i = 1; i < self.buttonArray.count; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self layoutIfNeeded];
            lastBtnW = self.buttonArray[i-1].frame.size.width;
            lastBtnX = self.buttonArray[i-1].frame.origin.x;
            if(lastBtnX + lastBtnW*2 > self.frame.size.width) {
                k++;
                [self.buttonArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.hotSearch_KnowledgeLabel.mas_bottom).offset(k*MAIN_SCREEN_W*0.1147+LINESPLIT);
                    make.left.equalTo(self);
                }];
            }else {
                [self.buttonArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(SPLIT+lastBtnW+lastBtnX);
                    make.top.equalTo(self.hotSearch_KnowledgeLabel.mas_bottom).offset(k*MAIN_SCREEN_W*0.1147+LINESPLIT);
                }];
            }
        });
    }
}
@end
