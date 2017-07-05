//
//  ShoppingCart.h
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/28.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingCartGoods.h"
#import "ShoppingCartShop.h"

@interface ShoppingCart : NSObject

@property (nonatomic, nullable, strong) NSArray *client;
/**
 *  购物车数量
 */
@property (nonatomic, assign) NSInteger count;
/**
 *  所有添加到购物车中的商品
 */
@property (nonatomic, nullable, strong) NSArray *list;
/**
 *  0是普通会员  !0是充值会员
 */
@property (nonatomic, assign) NSInteger type;
/**
 *  所有的商铺
 */
@property (nonatomic, nullable, strong) NSArray *users;


+ (instancetype _Nullable)initWithDictionary:(NSDictionary * _Nullable)dictionary;

@end
