//
//  YZGoodsCellRightEditView.h
//  YiZhongShop
//
//  Created by 何凯楠 on 16/7/13.
//  Copyright © 2016年 HeXiaoBa. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN



@class YZShoppingCartGoods, RACSubject;
@interface YZGoodsCellRightEditView : UIView

@property (nonatomic, nullable, copy) NSString *count;
@property (nonatomic, nullable, copy) NSString *attr;

@property (nonatomic, nullable, strong) RACSubject *updateCountSubject;
@property (nonatomic, nullable, strong) RACSubject *deleteCountSubject;

NS_ASSUME_NONNULL_END
@end
