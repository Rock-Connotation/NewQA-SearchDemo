//
//  TableViewCell.h
//  tableView
//
//  Created by 石子涵 on 2020/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UILabel *label;

- (instancetype)init;
@end

NS_ASSUME_NONNULL_END
