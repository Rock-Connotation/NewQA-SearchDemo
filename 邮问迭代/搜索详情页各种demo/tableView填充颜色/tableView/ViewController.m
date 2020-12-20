//
//  ViewController.m
//  tableView
//
//  Created by 石子涵 on 2020/11/26.
//

#import "ViewController.h"
#import "TableViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    // Do any additional setup after loading the view.
    
    self.table = [[UITableView alloc] init];
    //表格格式为为只读属性，只能在初始化的时候去设置
//    self.table = [[UITableView alloc] initWithFrame: CGRectMake(50, 200, 300, 400) style:UITableViewStylePlain];
    self.table = [[UITableView alloc] initWithFrame: CGRectMake(50, 200, 300, 400) style:UITableViewStyleGrouped]; //分组的
    
    self.table.dataSource = self;
    self.table.delegate = self;
    
    //消除表格之间的线
//    [self.table setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
//    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    //去除横、纵向的小滑块
//    self.table.showsHorizontalScrollIndicator = NO;
//    self.table.showsVerticalScrollIndicator = NO;
    
//    self.table.backgroundColor = [UIColor clearColor];
    self.table.frame = CGRectMake(50, 200, 300, 400);
    [self.view addSubview:self.table];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    TableViewCell *cell = [[TableViewCell alloc] init];
//    cell.label.text =[NSString stringWithFormat: @"第%ld分区，第%ld行",(long)indexPath.section, (long)indexPath.row ];
    NSString *ID = @"id";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.textLabel.text =[NSString stringWithFormat: @"第%ld分区",(long)indexPath.section];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
//    cell.detailTextLabel.backgroundColor = [UIColor redColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"已经点击");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
        //头、尾部视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
//    return view;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor blueColor];
//    return view;
//}
@end
