//
//  ShoppingCartViewModel.h
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/28.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ShoppingCart.h"

@class ShoppingCartGoodsCellViewModel;
@class ShoppingCartGoodsSectionHeaderViewModel;

@interface ShoppingCartViewModel : NSObject

//请求数据
- (RACSignal *)fetchDataSingal;

//获取有几个section
- (NSInteger)shops;

//根据section获取该section有几个cell
- (NSInteger)goodsNumberOfSection:(NSInteger)section;

//根据section获取cell的viewmodel
- (NSArray<ShoppingCartGoodsCellViewModel *> *)goodsOfSection:(NSInteger)section;

//根据section获取shop的viewmodel
- (ShoppingCartGoodsSectionHeaderViewModel *)shopNumberOfSections:(NSInteger)section;

//店铺编辑按钮事件
- (void)shopEditOfDic:(NSDictionary *)dic;

//店铺选择按钮事件
- (void)shopSelectedOfDic:(NSDictionary *)dic;

//cell选择按钮事件
- (void)goodsSelectedOfDic:(NSDictionary *)dic;

//bottomview全选按钮事件
- (NSString *)allSelectedCommandWithState:(BOOL)state;

- (RACCommand *)allSelectedCommand;

- (NSNumber *)allSelectedState;

//选择的商品总价格
- (NSString *)totalPrice;

//选择的商品总数量
- (NSNumber *)selectedGoodsCount;

//刷新总价格
- (void)reloadTotalPrice;

//删除商品
- (void)deleteGoodsWithId:(NSInteger)goodsId;

@end
