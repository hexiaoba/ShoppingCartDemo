//
//  ViewController.m
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/28.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ShoppingCartControl.h"
#import "ShoppingCartViewModel.h"
#import "YZShoppingCartBottomView.h"
#import "UIResponder+Router.h"
#import "ShoppingCartGoodsCellViewModel.h"

@interface ViewController ()

@property (nonatomic, nullable, strong) ShoppingCartViewModel *viewModel;
@property (nonatomic, nullable, strong) ShoppingCartControl *control;
@property (nonatomic, nullable, strong) YZShoppingCartBottomView *bottomView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.viewModel = [[ShoppingCartViewModel alloc] init];
    self.control = [ShoppingCartControl initWithViewModel:self.viewModel];
    
    CGFloat h = 50;
    CGFloat screenH = CGRectGetHeight(self.view.frame);
    CGFloat screenW = CGRectGetWidth(self.view.frame);
    self.bottomView = [YZShoppingCartBottomView initWithViewModel:self.viewModel];
    self.bottomView.frame = CGRectMake(0, screenH - h, screenW, h);
    [self.view addSubview:self.bottomView];
    
    self.control.tableView.frame = CGRectMake(0, 64, screenW, screenH - h - 64);
    [self.view addSubview:self.control.tableView];
    
    [self.control.fetchDataCommand execute:@1];

}

- (void)routeEvent:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:DeleteShoppingCart]) {
        ShoppingCartGoodsCellViewModel *vm = userInfo[@"viewModel"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要删除改商品吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.viewModel deleteGoodsWithId:vm.goodsId];
            [vm.deleteCartCommand execute:@1];
        }];
        [alert addAction:cancel];
        [alert addAction:delete];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
