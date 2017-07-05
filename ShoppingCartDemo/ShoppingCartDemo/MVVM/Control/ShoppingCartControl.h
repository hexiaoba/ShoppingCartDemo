//
//  ShoppingCartContol.h
//  ShoppingCartDemo
//
//  Created by 何凯楠 on 2017/6/28.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@class ShoppingCartViewModel;
@interface ShoppingCartControl : NSObject

+ (instancetype)initWithViewModel:(ShoppingCartViewModel *)viewModel;
- (UITableView *)tableView;

- (RACCommand *)fetchDataCommand;

@end
