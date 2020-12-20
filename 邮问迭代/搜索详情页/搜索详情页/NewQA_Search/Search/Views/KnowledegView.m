//
//  KnowledegView.m
//  搜索详情页
//
//  Created by 石子涵 on 2020/11/29.
//

#import <Masonry.h>
#import "KnowledegView.h"

#define SPLIT 7//item间距
#define LINESPLIT 10//行间距

#define MAIN_SCREEN_H [UIScreen mainScreen].bounds.size.height
#define MAIN_SCREEN_W [UIScreen mainScreen].bounds.size.width

@interface KnowledegView()
@property (nonatomic, strong) NSString *labelStr;

/// 热门搜索按钮的文本数组
@property (nonatomic, strong) NSArray *btnsTextAry;

@end

@implementation KnowledegView
- (instancetype)initWithBtnTextAry:(NSArray *)array andStr:(nonnull NSString *)string{
    self = [super init];
    if (self) {
        _labelStr = string;
        _btnsTextAry = array;
//        self.buttonArray = [[NSArray alloc] init];
        //设置背景色
        self.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
        
        //添加标题
        [self addHotSearch_KnowledgeLabel];
        
        //添加下面的热门搜索或者重邮知识库item
        [self addBtns];
        
        [self btnsAddConstraints];
        
    }
    return self;
}

/// 添加label
- (void)addHotSearch_KnowledgeLabel{
    self.hotSearch_KnowledgeLabel = [[UILabel alloc] init];
    self.hotSearch_KnowledgeLabel.text = _labelStr;
    //设置字体
    self.hotSearch_KnowledgeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    //设置字体颜色
    self.hotSearch_KnowledgeLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    [self addSubview:self.hotSearch_KnowledgeLabel];
        //此处不需要约束宽与高，自适应
    [self.hotSearch_KnowledgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
    }];
}

/// 添加下面的热门搜索或者重邮知识库item
- (void)addBtns{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *text in _btnsTextAry) {
        HotSearchBtn *button = [[HotSearchBtn alloc] init];
        [button setTitle:text forState:UIControlStateNormal];   //设置btn的标题文本
        
        //判断创建的是哪一个页面，决定按钮触碰后会执行什么方法
        if ([_labelStr isEqualToString:@"热门搜索"]) {
            [button addTarget:self.delegate action:@selector(touchHotSearchBtnsThroughBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([_labelStr isEqualToString:@"重邮知识库"]){
            [button addTarget:self.delegate action:@selector(touchCQUPTKonwledge) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self addSubview:button];
        
        
        //将创建的buttons保存起来
        [array addObject:button];
    }
    self.buttonArray = array;
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
