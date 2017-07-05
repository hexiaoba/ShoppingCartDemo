//
//  ShoppingCartGoodsCellViewModel.h
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/28.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const DeleteShoppingCart;

@class ShoppingCartGoods, RACSubject, RACCommand, RACSignal;
@interface ShoppingCartGoodsCellViewModel : NSObject

+ (instancetype)initWithGoodsModel:(ShoppingCartGoods *)goods type:(NSInteger)type;
- (NSInteger)goodsId;

- (NSString *)imagePath;
- (NSString *)price;
- (NSString *)name;
- (NSString *)attr;
- (NSNumber *)count;
- (NSNumber *)isEditState;
- (NSNumber *)selected;
- (void)goodsSelectedOfState:(BOOL)selected;

@property (nonatomic, strong) RACSubject *goodsSelectedSubject;

//修改购物车数量
- (void)updateCartCountSingalWithCount:(NSNumber *)count;
- (RACCommand *)updateCartCountCommand;

- (RACCommand *)deleteCartCommand;

@end
