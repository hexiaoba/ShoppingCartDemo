//
//  ShoppingCartGoodsCellViewModel.m
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/28.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import "ShoppingCartGoodsCellViewModel.h"
#import "ShoppingCartGoods.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

NSString *const DeleteShoppingCart = @"DeleteShoppingCart";

@interface ShoppingCartGoodsCellViewModel()

@property (nonatomic, nullable, strong) ShoppingCartGoods *goods;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, nullable, strong) NSNumber *count;
@property (nonatomic, nullable, strong) RACCommand *updateCartCountCommand;
@property (nonatomic, nullable, strong) RACCommand *deleteCartCommand;

@end

@implementation ShoppingCartGoodsCellViewModel

+ (instancetype)initWithGoodsModel:(ShoppingCartGoods *)goods type:(NSInteger)type {
    return [[self alloc] initWithGoodsModel:goods type:type];
}

- (instancetype)initWithGoodsModel:(ShoppingCartGoods *)goods type:(NSInteger)type {
    self = [super init];
    if (self) {
        self.goods = goods;
        self.type = type;
        
        self.updateCartCountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            RACSignal *updateSingal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

                [subscriber sendNext:self.count];
                [subscriber sendCompleted];
                
                return nil;
            }];
            return updateSingal;
        }];
        
        self.deleteCartCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
           RACSignal *delteSingal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               [subscriber sendCompleted];
               return nil;
           }];
            return delteSingal;
        }];
        
    }
    return self;
}

- (NSInteger)goodsId {
    return self.goods.id;
}

- (NSString *)imagePath {
    return [NSString stringWithFormat:@"%@%@", @"http://192.168.100.145/", self.goods.pic];
}

- (NSNumber *)isEditState {
    return @(self.goods.isEidtState);
}

- (NSString *)price {
    NSString *price = nil;
    if (self.type != 0) { //充值会员
        price = self.goods.goodsPrice;
    } else { //普通会员
        price = self.goods.marketPrice;
    }
    return [NSString stringWithFormat:@"￥%@", price];
}

- (NSString *)name {
    NSString *nameStr = self.goods.goodsName;
    //限时抢购商品
    if (self.goods.buyType == 1) {
        NSString *prefixStr = @"[限时抢购]";
        nameStr = [NSString stringWithFormat:@"%@%@", prefixStr, nameStr];

    }
    return nameStr;
}

- (NSString *)attr {
    return self.goods.goodsAttr;
}

- (NSNumber *)count {
    return @(self.goods.goodsNumber);
}

- (NSNumber *)selected {
    return @(self.goods.goodsSelected);
}

- (void)goodsSelectedOfState:(BOOL)selected {
    //修改model中的商品的选中状态
    self.goods.goodsSelected = selected;
    
    if (self.goodsSelectedSubject) {
        [self.goodsSelectedSubject sendNext:@{
                                              @"selected": @(selected),
                                              @"goodsId": @(self.goods.id),
                                              @"shopId": @(self.goods.createUser)
                                             }];
    }

}

- (void)updateCartCountSingalWithCount:(NSNumber *)count {
    
    //请求接口
    //code
    
    //修改数量
    self.goods.goodsNumber = [count integerValue];
    self.count = count;
    
    NSLog(@"修改数量为=%@", count);

}


@end
