//
//  ShoppingCartContol.m
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/28.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import "ShoppingCartControl.h"
#import "ShoppingCartViewModel.h"
#import "YZShoppingCartGoodsCell.h"
#import "YZShoppingCartGoodsSectionHeaderView.h"
#import "ShoppingCartGoodsCellViewModel.h"
#import "ShoppingCartGoodsSectionHeaderViewModel.h"

@interface ShoppingCartControl()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, nullable, strong) ShoppingCartViewModel *viewModel;
@property (nonatomic, nullable, strong) UITableView *tableView;
@property (nonatomic, nullable, strong) RACCommand *fetchDataCommand;

@end

@implementation ShoppingCartControl

+ (instancetype)initWithViewModel:(ShoppingCartViewModel *)viewModel{
    return [[self alloc] initWithViewModel:viewModel];
}

- (instancetype)initWithViewModel:(ShoppingCartViewModel *)viewModel{
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self.viewModel.allSelectedCommand.executionSignals subscribeNext:^(id x) {
            [x subscribeNext:^(id x) {
                [self.tableView reloadData];
            }];
        }];
        
        @weakify(self);
        self.fetchDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
         
            @strongify(self);
            
            RACSubject *subject = [RACSubject subject];
            
            [self.viewModel.fetchDataSingal subscribeError:^(NSError *error) {
                [subject sendError:error];
            } completed:^{
                [self.tableView reloadData];
                [subject sendCompleted];
            }];
            return subject;
            
        }];
        
    }
    return self;
}

#pragma mark- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.viewModel.shops;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.viewModel goodsNumberOfSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.viewModel.shops > section) {
        ShoppingCartGoodsSectionHeaderViewModel *shopVM = [self.viewModel shopNumberOfSections:section];
        YZShoppingCartGoodsSectionHeaderView *headerView = [[YZShoppingCartGoodsSectionHeaderView alloc] init];
        headerView.viewModel = shopVM;
        headerView.viewModel.editStateSubject = [RACSubject subject];
        [headerView.viewModel.editStateSubject subscribeNext:^(NSDictionary *dic) {
            [self.viewModel shopEditOfDic:dic];
            [self.tableView beginUpdates];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
        headerView.viewModel.selectedStateSubject = [RACSubject subject];
        [headerView.viewModel.selectedStateSubject subscribeNext:^(NSDictionary *dic) {
            [self.viewModel shopSelectedOfDic:dic];
            [self.tableView beginUpdates];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"shoppingCartCell";
    YZShoppingCartGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YZShoppingCartGoodsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    if (self.viewModel.shops > indexPath.section) {
        
        NSArray *goods = [self.viewModel goodsOfSection:indexPath.section];
        if (goods.count > indexPath.row) {
            ShoppingCartGoodsCellViewModel *viewModel = goods[indexPath.row];
            cell.viewModel = viewModel;
            cell.viewModel.goodsSelectedSubject = [RACSubject subject];
            [cell.viewModel.goodsSelectedSubject subscribeNext:^(NSDictionary *dic) {
                [self.viewModel goodsSelectedOfDic:dic];
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [cell.viewModel.updateCartCountCommand.executionSignals subscribeNext:^(id x) {
                [x subscribeNext:^(id x) {
                    [self.viewModel reloadTotalPrice];
                }];
            }];
            [cell.viewModel.deleteCartCommand.executionSignals subscribeNext:^(id x) {
                [tableView reloadData];
            }];
            
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark- Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


@end
