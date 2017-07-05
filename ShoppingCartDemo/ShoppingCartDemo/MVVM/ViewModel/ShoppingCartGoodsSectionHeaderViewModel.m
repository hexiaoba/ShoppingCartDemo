//
//  ShoppingCartGoodsSectionHeaderViewModel.m
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/29.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import "ShoppingCartGoodsSectionHeaderViewModel.h"
#import "ShoppingCartShop.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ShoppingCartGoodsSectionHeaderViewModel()

@property (nonatomic, nullable, strong) ShoppingCartShop *shop;
@property (nonatomic, nullable, strong) NSNumber *isEditState;
@property (nonatomic, nullable, strong) NSNumber *selected;

@end

@implementation ShoppingCartGoodsSectionHeaderViewModel

+ (instancetype)initWithShoppingCartShop:(ShoppingCartShop *)shop {
    return [[self alloc] initWithShoppingCartShop:shop];
}

- (instancetype)initWithShoppingCartShop:(ShoppingCartShop *)shop {
    self = [super init];
    if (self) {
        self.shop = shop;

    }
    return self;
}


- (NSString *)title {
    return self.shop.comment ?: @"--";
}

- (NSNumber *)isEditState {
    return @(self.shop.isEidtState);
}

- (NSNumber *)selected {
    return @(self.shop.shopSelected);
}

- (void)editOfState:(BOOL)state {
    self.shop.isEidtState = state;
    self.isEditState = @(state);
    
    if (self.editStateSubject) {
        [self.editStateSubject sendNext:@{@"state": self.isEditState,
                                          @"shopId": @(self.shop.id) }];
    }
}

- (void)selectOfState:(BOOL)selected {
    
    //注意：要修改Model中的商铺按钮的选中状态
    self.shop.shopSelected = selected;
    self.selected = @(selected);
    
    if (self.selectedStateSubject) {
        [self.selectedStateSubject sendNext:@{@"selected": @(selected),
                                              @"shopId": @(self.shop.id) }];
    }
    
}


@end
