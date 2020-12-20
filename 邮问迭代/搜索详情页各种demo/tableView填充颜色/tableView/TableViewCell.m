//
//  TableViewCell.m
//  tableView
//
//  Created by 石子涵 on 2020/11/26.
//

#import "TableViewCell.h"

@implementation TableViewCell
- (instancetype)init{
    self = [super init];
    if (self) {
//        self.contentView.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
        
        self.view = [[UIView alloc] init];
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.frame = CGRectMake(20, 12.5, 250, 20);
        //设置圆角
        self.view.layer.cornerRadius = 15;
        [self.contentView addSubview:self.view];
        
        
        self.label = [[UILabel alloc] init];
//        self.label.text = @"123";
//        self.label.backgroundColor = [UIColor whiteColor];
        self.label.textColor = [UIColor blackColor];
//        self.label.layer.cornerRadius = 5;
//        self.label.frame = self.contentView.frame;
//        self.label.backgroundColor = [UIColor redColor];
        self.label.frame = CGRectMake(30, 2, 200, 20);
//        [self.contentView addSubview:self.label];
        [self.view addSubview:self.label];
    }
    return self;
}


@end
