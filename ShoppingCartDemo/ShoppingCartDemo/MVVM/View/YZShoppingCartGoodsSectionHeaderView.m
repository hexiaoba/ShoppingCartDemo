//
//  YZShoppingCartGoodsSectionHeaderView.m
//  YiZhongShop
//
//  Created by 何凯楠 on 16/7/13.
//  Copyright © 2016年 HeXiaoBa. All rights reserved.
//

#import "YZShoppingCartGoodsSectionHeaderView.h"
#import "UIView+LayoutMethods.h"
#import "NSString+Size.h"
#import "ShoppingCartGoodsSectionHeaderViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define SHOP_IMAGE [UIImage imageNamed:@"goodsdetail_joinshop_icon"]

static CGFloat const ShopTitleLabelFontFloat = 14.f;

@interface YZShoppingCartGoodsSectionHeaderView()
@property (nonatomic, nullable, weak) UIButton *selectedButton;
@property (nonatomic, nullable, weak) UILabel *shopTitleLabel;
@property (nonatomic, nullable, weak) UIImageView *arrowImgView;
@property (nonatomic, nullable, weak) UIButton *editButton;
@property (nonatomic, nullable, weak) UIImageView *shopImgView;

@end

@implementation YZShoppingCartGoodsSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
        
        [self observerViewModel];

    }
    return self;
}

- (void)observerViewModel {
    
    RAC(self, shopTitleLabel.text) = RACObserve(self, viewModel.title);
    
    @weakify(self);
    [RACObserve(self, viewModel.isEditState) subscribeNext:^(NSNumber *isEidtState) {
        @strongify(self);
        BOOL state = [isEidtState boolValue];
 
        if (state) {
            [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
        } else {
            [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
        }
    }];
    
    [RACObserve(self, viewModel.selected) subscribeNext:^(NSNumber *selected) {
        @strongify(self);
        self.selectedButton.selected = [selected boolValue];
    }];

}


- (void)selectedClick:(UIButton *)button {
    
    button.selected = !button.selected;
    [self.viewModel selectOfState:button.selected];
}

- (void)edit:(UIButton *)button {
    
    BOOL state = NO;
    if ([button.currentTitle isEqualToString:@"编辑"]) {
        state = YES;
        [button setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        state = NO;
        [button setTitle:@"编辑" forState:UIControlStateNormal];
    }
    [self.viewModel editOfState:state];
    
}


- (void)setupViews {
    //选择按钮
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedButton setImage:[UIImage imageNamed:@"shoppingcart_goods_default_icon"] forState:UIControlStateNormal];
    [selectedButton setImage:[UIImage imageNamed:@"shoppingcart_goods_selected_icon"] forState:UIControlStateSelected];
    [selectedButton addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectedButton];
    self.selectedButton = selectedButton;
    
    //店铺图片
    UIImageView *shopImgView = [[UIImageView alloc] initWithImage:SHOP_IMAGE];
    [self addSubview:shopImgView];
    self.shopImgView = shopImgView;
    
    //店铺名称
    UILabel *shopTitleLabel = [[UILabel alloc] init];
    shopTitleLabel.textColor = HEXCOLOR(0x444444);
    shopTitleLabel.font = [UIFont systemFontOfSize:ShopTitleLabelFontFloat];
    [self addSubview:shopTitleLabel];
    self.shopTitleLabel = shopTitleLabel;
    
    //向右箭头
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.image = [UIImage imageNamed:@"mine_icon_arrow"];
    [self addSubview:arrow];
    self.arrowImgView = arrow;
    
    //编辑按钮
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:HEXCOLOR(0x444444) forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [editButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editButton];
    self.editButton = editButton;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    CGFloat selectedX = 0;
    CGFloat selectedY = 0;
    CGFloat selectedWH = self.height;
    self.selectedButton.frame = CGRectMake(selectedX, selectedY, selectedWH, selectedWH);
    
    CGSize titleSize = [self.shopTitleLabel.text stringSizeWithFontFloat:ShopTitleLabelFontFloat];
    
    //店铺图片
    CGFloat shopImgViewX = self.selectedButton.right;
    CGFloat shopImgViewW = SHOP_IMAGE.size.width;
    CGFloat shopImgViewH = SHOP_IMAGE.size.height;
    CGFloat shopImgViewY = (self.height - shopImgViewH) * 0.5;
    self.shopImgView.frame = CGRectMake(shopImgViewX, shopImgViewY, shopImgViewW, shopImgViewH);
    
    CGFloat titleX = self.shopImgView.right + margin;
    CGFloat titleY = 0;
    CGFloat titleW = 0;
    CGFloat maxWidth = self.width - self.shopImgView.right - self.height - margin * 4;
    if (titleSize.width > maxWidth) {
        titleW = maxWidth;
    } else {
        titleW = titleSize.width;
    }
    CGFloat titleH = self.height;
    self.shopTitleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGSize arrorSize = self.arrowImgView.image.size;
    
    CGFloat arrorX = self.shopTitleLabel.right + margin;
    CGFloat arrorY = (self.height - arrorSize.height) * 0.5;
    self.arrowImgView.frame = CGRectMake(arrorX, arrorY, arrorSize.width, arrorSize.height);
    
    CGFloat editW = self.height;
    CGFloat editX = self.width - editW - margin;
    CGFloat editY = 0;
    CGFloat editH = self.height;
    self.editButton.frame = CGRectMake(editX, editY, editW, editH);
}


@end
