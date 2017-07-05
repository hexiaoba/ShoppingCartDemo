//
//  ShoppingCartViewModel.m
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/28.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import "ShoppingCartViewModel.h"
#import "ShoppingCartGoodsCellViewModel.h"
#import "ShoppingCartGoodsSectionHeaderViewModel.h"

@interface ShoppingCartViewModel()

@property (nonatomic, nullable, strong) RACSignal *fetchDataSingal;
@property (nonatomic, nullable, strong) ShoppingCart *shoppingCart;
@property (nonatomic, assign) NSInteger shops;
@property (nonatomic, nullable, strong) NSArray *carts;
@property (nonatomic, nullable, strong) RACCommand *allSelectedCommand;

@property (nonatomic, nullable, strong) NSNumber *allSelectedState;
@property (nonatomic, nullable, copy) NSString *totalPrice;
@property (nonatomic, nullable, strong) NSNumber *selectedGoodsCount;

@end

@implementation ShoppingCartViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        @weakify(self);
        
        
        self.fetchDataSingal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
         
            @strongify(self);
            
//            NSURLSession *session = [NSURLSession sharedSession];
//            NSURL *url = [NSURL URLWithString:@"http://192.168.100.82:8888/xt-eyiwen-app/appOrderInfo/getAllCarts?data=sBfH2S3328WfRNeUYNpIuFM3QV3VeH-4MEkpDk==&sign=c33ec047446b9f64e8eb51dc26c980cb&time=1498465226768"];
//            
//            __block NSError *tempError;
//            NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                
//                if (error) {
//                    tempError = error;
//                } else {
//                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&tempError];
//                    NSLog(@"%@", @"请求成功");
//                    ShoppingCart *cart = [ShoppingCart initWithDictionary:json];
//                    
//                    self.shoppingCart = cart;
//                }
//
//            }];
//            [task resume];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"shoppingcart" ofType:@"json"];
            NSData *date = [NSData dataWithContentsOfFile:path];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:date options:0 error:nil];
            NSLog(@"%@", @"请求成功");
            ShoppingCart *cart = [ShoppingCart initWithDictionary:json];
            self.shoppingCart = cart;
            
            if (self.shoppingCart) {
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:nil];
            }
            
            return nil;
        }];
        
        
        
        self.allSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [subscriber sendNext:self.allSelectedState];
                [subscriber sendCompleted];
                
                return nil;
            }];
            
            return singal;
        }];
        
    }
    return self;
}

- (NSInteger)shops {
    return self.carts.count;
}

- (NSInteger)goodsNumberOfSection:(NSInteger)section {
    NSDictionary *dic = self.carts[section];
    NSArray *arr = dic[@"goods"];
    return arr.count;
}

- (NSArray<ShoppingCartGoodsCellViewModel *> *)goodsOfSection:(NSInteger)section {
    NSDictionary *dic = self.carts[section];
    NSArray *arr = dic[@"goods"];
    return arr;
}

- (NSInteger)goodsNumberOfRowsInSection:(NSInteger)section {
    ShoppingCartShop *shop = self.shoppingCart.users[section];
    NSArray *goods = [self getAllGoodsWithShopId:shop.id];
    return goods.count;
}

- (ShoppingCartGoodsSectionHeaderViewModel *)shopNumberOfSections:(NSInteger)section {
    NSDictionary *dic = self.carts[section];
    ShoppingCartGoodsSectionHeaderViewModel *shopVM = dic[@"shop"];

    return shopVM;
}

- (void)setShoppingCart:(ShoppingCart *)shoppingCart {
    _shoppingCart = shoppingCart;
    
    NSMutableArray *temCarts = [NSMutableArray array];

    for (ShoppingCartShop *shop in shoppingCart.users) {
        
        NSArray *goods = [self getAllGoodsWithShopId:shop.id];
        if (!goods.count) {
            continue;
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        ShoppingCartGoodsSectionHeaderViewModel *shopVM = [ShoppingCartGoodsSectionHeaderViewModel initWithShoppingCartShop:shop];
        dic[@"shop"] = shopVM;
        
       
        NSMutableArray *goodsVM = [NSMutableArray array];
        for (ShoppingCartGoods *tempGoods in goods) {
            ShoppingCartGoodsCellViewModel *vm = [ShoppingCartGoodsCellViewModel initWithGoodsModel:tempGoods type:shoppingCart.type];
            [goodsVM addObject:vm];
        }
        dic[@"goods"]  = [goodsVM copy];
        
        [temCarts addObject:dic];
    }
    self.carts = [temCarts copy];
    
}

- (ShoppingCartShop *)shopOfShopId:(NSInteger)shopId {
    
    ShoppingCartShop *tempShop = nil;
    for (ShoppingCartShop *shop in self.shoppingCart.users) {
        if (shop.id == shopId) {
            tempShop = shop;
            break;
        }
    }
    return tempShop;
}

- (NSArray *)getAllGoodsWithShopId:(NSInteger)shopId {
    if (!self.shoppingCart) { return nil; }
    
    ShoppingCartShop *tempShop = [self shopOfShopId:shopId];

    NSMutableArray *tempGoods = [NSMutableArray array];
    if (tempShop) {
        for (ShoppingCartGoods *goods in self.shoppingCart.list) {
            if (goods.createUser == shopId) {
                [tempGoods addObject:goods];
            }
        }
    }
    return [tempGoods copy];
}

- (void)shopEditOfDic:(NSDictionary *)dic {
    BOOL state = [dic[@"state"] boolValue];
    NSInteger shopId = [dic[@"shopId"] integerValue];
    
    if (state) {
        
        NSArray *goodsList = [self getAllGoodsWithShopId:shopId];
        for (ShoppingCartGoods *goods in goodsList) {
            goods.isEidtState = YES;
        }
    } else {

        NSArray *goodsList = [self getAllGoodsWithShopId:shopId];
        for (ShoppingCartGoods *goods in goodsList) {
            goods.isEidtState = NO;
        }
    }
}

- (void)shopSelectedOfDic:(NSDictionary *)dic {
    BOOL selected = [dic[@"selected"] boolValue];
    NSInteger shopId = [dic[@"shopId"] integerValue];
    
    NSArray *shopGoods = [self getAllGoodsWithShopId:shopId];
    for (ShoppingCartGoods *goods in shopGoods) {
        if (selected) {
            goods.goodsSelected = YES;
        } else {
            goods.goodsSelected = NO;
        }
    }
  
    
    self.allSelectedState = [self setupAllSelectedState];
    self.totalPrice = [self setupTotalPrice];
    self.selectedGoodsCount = @([self setupSelectedCount]);
}

- (void)goodsSelectedOfDic:(NSDictionary *)dic {
    BOOL selected = [dic[@"selected"] boolValue];
    NSInteger shopId = [dic[@"shopId"] integerValue];
//    NSInteger goodsId = [dic[@"goodsId"] integerValue];
    
    ShoppingCartShop *shop = [self shopOfShopId:shopId];
    NSUInteger selectedCount = 0;
    if (selected) {
        NSArray *shopGoods = [self getAllGoodsWithShopId:shopId];
        for (ShoppingCartGoods *goods in shopGoods) {
            goods.goodsSelected ? selectedCount++ : 0;
        }
        
        if (selectedCount == shopGoods.count) {
            shop.shopSelected = YES;
        }
    } else {
        shop.shopSelected = NO;
    }
    
    self.allSelectedState = [self setupAllSelectedState];
    self.totalPrice = [self setupTotalPrice];
    self.selectedGoodsCount = @([self setupSelectedCount]);
}

- (double)goodsPriceWithGoods:(ShoppingCartGoods *)goods {
    return @(self.shoppingCart.type != 0) ? [goods.goodsPrice doubleValue] : [goods.marketPrice doubleValue];
}

- (NSString *)totalPrice {
    return [self setupTotalPrice];
}


- (NSString *)setupTotalPrice {
    double total = 0.00;
    for (ShoppingCartGoods *goods in self.shoppingCart.list) {
        if (goods.goodsSelected) {
            double goodsP = goods.goodsNumber * [self goodsPriceWithGoods:goods];
            total += goodsP;
        }
    }

    return [NSString stringWithFormat:@"%.2f", total];
}

- (NSString *)allSelectedCommandWithState:(BOOL)state {
    
    self.allSelectedState = @(state);
    for (ShoppingCartShop *shop in self.shoppingCart.users) {
        ShoppingCartShop *tempShop = [self shopOfShopId:shop.id];
        tempShop.shopSelected = state;
        [self shopSelectedOfDic:@{@"selected": @(state), @"shopId": @(shop.id)}];
    }

    return [self totalPrice];
}

- (NSNumber *)setupAllSelectedState {
    if (!self.shoppingCart) return @NO;
    NSUInteger num = [self setupSelectedCount];
    return @(num == self.shoppingCart.list.count);
}

- (NSNumber *)selectedGoodsCount {
    return @([self setupSelectedCount]);
}

- (NSInteger)setupSelectedCount {
    if (!self.shoppingCart) return 0;
    NSUInteger count = 0;
    for (ShoppingCartGoods *goods in self.shoppingCart.list) {
        if (goods.goodsSelected) {
            count++;
        }
    }
    return count;
}

- (void)reloadTotalPrice {
    self.totalPrice = [self setupTotalPrice];
}

- (void)deleteGoodsWithId:(NSInteger)goodsId {
    ShoppingCart *cart = self.shoppingCart;
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.shoppingCart.list];
    for (ShoppingCartGoods *goods in tempArr) {
        if (goods.id == goodsId) {
            [tempArr removeObject:goods];
            break;
        }
    }
    cart.list = [tempArr copy];
    
    self.shoppingCart = cart;
    
    [self reloadTotalPrice];
    self.selectedGoodsCount = @([self setupSelectedCount]);
}


@end
