//
//  ShoppingCart.m
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/28.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import "ShoppingCart.h"


@implementation ShoppingCart

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    ShoppingCart *cart = [[self alloc] init];
    cart.client = dictionary[@"client"];
    cart.count = [dictionary[@"count"] integerValue];
    NSArray *list = dictionary[@"list"];
    NSMutableArray *tempList = [NSMutableArray array];
    for (NSDictionary *dic in list) {
        ShoppingCartGoods *goods = [[ShoppingCartGoods alloc] init];
        [goods setValuesForKeysWithDictionary:dic];
        [tempList addObject:goods];
    }
    cart.list = [tempList copy];
    cart.type = [dictionary[@"type"] integerValue];
    NSArray *users = dictionary[@"users"];
    NSMutableArray *tempUsers = [NSMutableArray array];
    for (NSDictionary *dic in users) {
        ShoppingCartShop *shop = [[ShoppingCartShop alloc] init];
        [shop setValuesForKeysWithDictionary:dic];
        [tempUsers addObject:shop];
    }
    cart.users = [tempUsers copy];
    
    return cart;
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%@", key);
}

@end
