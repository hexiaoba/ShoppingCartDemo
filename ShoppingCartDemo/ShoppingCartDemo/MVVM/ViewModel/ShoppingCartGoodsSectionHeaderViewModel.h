//
//  ShoppingCartGoodsSectionHeaderViewModel.h
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/29.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSubject;
@class ShoppingCartShop;
@interface ShoppingCartGoodsSectionHeaderViewModel : NSObject

+ (instancetype)initWithShoppingCartShop:(ShoppingCartShop *)shop;

- (NSString *)title;
- (NSNumber *)isEditState;
- (NSNumber *)selected;
- (void)editOfState:(BOOL)state;
- (void)selectOfState:(BOOL)selected;

@property (nonatomic, strong) RACSubject *editStateSubject;
@property (nonatomic, strong) RACSubject *selectedStateSubject;

@end
