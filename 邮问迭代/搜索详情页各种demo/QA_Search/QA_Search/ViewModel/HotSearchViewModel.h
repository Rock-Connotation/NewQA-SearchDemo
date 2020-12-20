//
//  HotSearchViewModel.h
//  QA_Search
//
//  Created by 石子涵 on 2020/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotSearchViewModel : NSObject
///标题label的Str
@property (nonatomic, strong) NSString *titeStr;

/// button的文本内容
@property (nonatomic, strong) NSArray *btnTextsAry;

#waring 此处应该使用网络请求得到btnsArray;

@end

NS_ASSUME_NONNULL_END
