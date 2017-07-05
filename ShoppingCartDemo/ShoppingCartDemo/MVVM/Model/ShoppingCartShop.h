//
//  ShoppingCartShop.h
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/28.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartShop : NSObject

@property (nonatomic, nullable, copy) NSString *comment;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger roleId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, nullable, copy) NSString *mobile;
@property (nonatomic, nullable, copy) NSString *userName;

/****************************以下为自己新增字段*********************************************/
/**
 *  新增加字段，记录商铺view的选中状态
 */
@property (nonatomic, assign) BOOL shopSelected;
/**
 *  保存商铺下选中的商品的goodsId   (暂时废弃)
 */
@property (nonatomic, nullable, strong) NSMutableArray *selectedGoodsIds;
/**
 *  新增加字段，记录商铺是否是编辑状态
 */
@property (nonatomic, assign) BOOL isEidtState;

@end
