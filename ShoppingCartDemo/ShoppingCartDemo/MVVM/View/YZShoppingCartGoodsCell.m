//
//  YZShoppingCartGoodsCell.m
//  YiZhongShop
//
//  Created by 何凯楠 on 16/7/13.
//  Copyright © 2016年 HeXiaoBa. All rights reserved.
//

#import "YZShoppingCartGoodsCell.h"
#import "UIView+LayoutMethods.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YZGoodsCellRightDefaultView.h"
#import "YZGoodsCellRightEditView.h"
#import "ShoppingCartGoodsCellViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIResponder+Router.h"

@interface YZShoppingCartGoodsCell()
@property (nonatomic, nullable, weak) UIButton *selectedButton;
@property (nonatomic, nullable, weak) UIImageView *goodsImageView;
@property (nonatomic, nullable, weak) YZGoodsCellRightDefaultView *rightDefaultView;
@property (nonatomic, nullable, weak) YZGoodsCellRightEditView *rightEditView;
@property (nonatomic, nullable, strong) NSMutableArray *selectedGoodsIds;
@end

@implementation YZShoppingCartGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
        
        [self observerViewModel];
        
    }
    return self;
}

- (void)observerViewModel {
    
    RAC(self, rightDefaultView.price) = RACObserve(self, viewModel.price);
    RAC(self, rightDefaultView.name) = RACObserve(self, viewModel.name);
    RAC(self, rightDefaultView.attr) = RACObserve(self, viewModel.attr);

    RAC(self.rightEditView, attr) = RACObserve(self, viewModel.attr);

    @weakify(self);
    
    [RACObserve(self, viewModel.count) subscribeNext:^(NSNumber *count) {
        @strongify(self);
        self.rightDefaultView.count = [NSString stringWithFormat:@"x%@", count];
        self.rightEditView.count = [NSString stringWithFormat:@"%@", count];
    }];
    
    
    [RACObserve(self, viewModel.isEditState) subscribeNext:^(NSNumber *isEditState) {
        @strongify(self);

        self.rightDefaultView.hidden = [isEditState boolValue];
        self.rightEditView.hidden = ![isEditState boolValue];
    }];
    
    [RACObserve(self, viewModel.imagePath) subscribeNext:^(NSString *imagePath) {
        @strongify(self);

        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
    }];
    
    [RACObserve(self, viewModel.selected) subscribeNext:^(NSNumber *selected) {
        @strongify(self);
        self.selectedButton.selected = [selected boolValue];
    }];
}

/**
 *  选中商品
 */
- (void)selectedGoods:(UIButton *)button {
    
    button.selected = !button.selected;
    [self.viewModel goodsSelectedOfState:button.selected];    
}


- (void)setupViews {
    
//    self.backgroundColor = RGB(250, 250, 250);
    
    //选择按钮
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedButton setImage:[UIImage imageNamed:@"shoppingcart_goods_default_icon"] forState:UIControlStateNormal];
    [selectedButton setImage:[UIImage imageNamed:@"shoppingcart_goods_selected_icon"] forState:UIControlStateSelected];
    [selectedButton addTarget:self action:@selector(selectedGoods:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:selectedButton];
    self.selectedButton = selectedButton;
    
    //商品图片
    UIImageView *goodsImageView = [[UIImageView alloc] init];
    goodsImageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:goodsImageView];
    self.goodsImageView = goodsImageView;
    
    //右边默认view
    YZGoodsCellRightDefaultView *rightDefaultView = [[YZGoodsCellRightDefaultView alloc] init];
    [self.contentView addSubview:rightDefaultView];
    self.rightDefaultView = rightDefaultView;
    
    //右边编辑view
    YZGoodsCellRightEditView *rightEditView = [[YZGoodsCellRightEditView alloc] init];
    rightEditView.hidden = YES;
    [self.contentView addSubview:rightEditView];
    self.rightEditView = rightEditView;
    rightEditView.updateCountSubject = [RACSubject subject];
    [rightEditView.updateCountSubject subscribeNext:^(NSNumber *count) {
        [self.viewModel updateCartCountSingalWithCount:count];
        [self.viewModel.updateCartCountCommand execute:@1];
    }];
    rightEditView.deleteCountSubject = [RACSubject subject];
    [rightEditView.deleteCountSubject subscribeNext:^(id x) {
        [self routeEvent:DeleteShoppingCart userInfo:@{@"viewModel": self.viewModel}];
    }];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    CGFloat selectedX = 0;
    CGFloat selectedWH = 40;
    CGFloat selectedY = (self.height - selectedWH) * 0.5;
    self.selectedButton.frame = CGRectMake(selectedX, selectedY, selectedWH, selectedWH);
    
    CGFloat imageX = self.selectedButton.right;
    CGFloat imageY = margin;
    CGFloat imageWH = self.height - 2 * margin;
    self.goodsImageView.frame = CGRectMake(imageX, imageY, imageWH, imageWH);
    
    CGFloat rightDefaultX = self.goodsImageView.right;
    CGFloat rightDefaultY = 0;
    CGFloat rightDefaultW = self.width - rightDefaultX;
    CGFloat rightDefaultH = self.height;
    self.rightDefaultView.frame = CGRectMake(rightDefaultX, rightDefaultY, rightDefaultW, rightDefaultH);
    
    self.rightEditView.frame = self.rightDefaultView.frame;
}


@end
