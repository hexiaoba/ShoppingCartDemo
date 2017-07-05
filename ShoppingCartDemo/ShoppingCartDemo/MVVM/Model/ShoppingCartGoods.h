//
//  YZShoppingCart.h YZShoppingCart.m YZShoppingCartGoods.h ShoppingCartGoods.h
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/28.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartGoods : NSObject

/**
 *  购物车id
 */
@property (nonatomic, assign) NSInteger id;
/**
 *  商品对应的商铺id
 */
@property (nonatomic, assign) NSInteger createUser;
/**
 *  商品id
 */
@property (nonatomic, assign) NSInteger goodsId;
/**
 *  频道id  clientId
 */
@property (nonatomic, assign) NSInteger parentId;
/**
 *  client
 */
@property (nonatomic, assign) NSInteger recType;
@property (nonatomic, nullable, copy) NSString *goodsAttr;
@property (nonatomic, nullable, copy) NSString *goodsName;
@property (nonatomic, assign) NSInteger goodsNumber;
@property (nonatomic, nullable, copy) NSString *goodsPrice;
@property (nonatomic, nullable, copy) NSString *marketPrice;
@property (nonatomic, nullable, copy) NSString *integralPrice;
@property (nonatomic, nullable, copy) NSString *pic;
/**
 *  buyType=1为抢购商品
 */
@property (nonatomic, assign) NSInteger buyType;
/**
 *  开始抢购时间
 */
@property (nonatomic, nullable, copy) NSString *promotion_start;
/**
 *  抢购结束时间
 */
@property (nonatomic, nullable, copy) NSString *promotion_end;


/**
 *  新增加字段，记录商品cell的选中状态
 */
@property (nonatomic, assign) BOOL goodsSelected;
/**
 *  新增加字段，记录商品cell是否是编辑状态
 */
@property (nonatomic, assign) BOOL isEidtState;

@end
