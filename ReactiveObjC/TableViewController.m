//
//  TableViewController.m
//  ReactiveObjC
//
//  Created by chaiweiwei on 2017/4/19.
//  Copyright © 2017年 chaiweiwei. All rights reserved.
//

#import "TableViewController.h"
#import "ViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dic = @{@"title":@"simple",@"type":@(ActionTypeSimply)};
    [self.dataSource addObject:dic];
    dic = @{@"title":@"filterSimple",@"type":@(ActionTypeFilterSimply)};
    [self.dataSource addObject:dic];
    dic = @{@"title":@"bindingSimple",@"type":@(ActionTypeBinding)};
    [self.dataSource addObject:dic];
    dic = @{@"title":@"buttonPress",@"type":@(ActionTypeButtonPress)};
    [self.dataSource addObject:dic];
    dic = @{@"title":@"map",@"type":@(ActionTypeMap)};
    [self.dataSource addObject:dic];
    dic = @{@"title":@"flattenMap",@"type":@(ActionTypeFlattenMap)};
    [self.dataSource addObject:dic];
    dic = @{@"title":@"deliverOn",@"type":@(ActionTypeDeliverOn)};
    [self.dataSource addObject:dic];
    dic = @{@"title":@"Serial",@"type":@(ActionTypeSerial)};
    [self.dataSource addObject:dic];
    dic = @{@"title":@"Sequence",@"type":@(ActionTypeSequence)};
    [self.dataSource addObject:dic];
}

- (NSMutableArray *)dataSource {
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.detailTextLabel.text = dic[@"detail"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.row];
    ViewController *VC = [[ViewController alloc] init];
    VC.actionType = [dic[@"type"] integerValue];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
