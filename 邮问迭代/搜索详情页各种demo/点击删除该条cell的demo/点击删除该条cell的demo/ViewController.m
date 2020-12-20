//
//  ViewController.m
//  点击删除该条cell的demo
//
//  Created by 石子涵 on 2020/11/25.
//
#import <Masonry.h>
#import "ViewController.h"
#import "HistoryCell_Search.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,HistoryCell_Searh>
@property (nonatomic, strong) UITableView *historyTabel;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *Ary =  @[@"校庆",@"半期考试",@"数模比赛",@"重庆邮电大学计算机",@"红岩网校",@"123"];
    self.array = [[NSMutableArray alloc] initWithArray:Ary];
    
    self.historyTabel = [[UITableView alloc] init];
    [self.historyTabel setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    self.historyTabel.showsHorizontalScrollIndicator = NO;
    self.historyTabel.showsVerticalScrollIndicator = NO;
    self.historyTabel.allowsSelection = NO;
    self.historyTabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.historyTabel];
    [self.historyTabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.frame.size.height * 0.8);
    }];
    self.historyTabel.delegate = self;
    self.historyTabel.dataSource = self;
    
}

#pragma mark- TabelView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = self.array[indexPath.row];
    HistoryCell_Search *cell = [[HistoryCell_Search alloc] initWithString:string];
    cell.delegate = self;
    return cell;
}
//代理方法，删除选中的cell
- (void)deleteHistoryCellThroughString:(NSString *)string{
    /**
        注意边循环边删除有三种方式不会出错
     1.for(int i = 0; i < arry.count; i++)的形式
     2.for in 的话一种是先copy
     3.还有一种是反向遍历
     */
    NSMutableArray *copyarray = [self.array mutableCopy];
    for ( NSString *cellString in copyarray) {
        if ([string isEqualToString:cellString]) {
            [copyarray removeObject:cellString];
//            NSLog(@"%@",copyarray);
            self.array = copyarray;
            [self.historyTabel reloadData];
            break;
        }
    }
}


@end
