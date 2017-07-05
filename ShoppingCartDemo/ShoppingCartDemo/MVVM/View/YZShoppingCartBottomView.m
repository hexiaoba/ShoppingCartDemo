//
//  YZShoppingCartBottomView.m
//  YiZhongShop
//
//  Created by 何凯楠 on 16/7/14.
//  Copyright © 2016年 HeXiaoBa. All rights reserved.
//

#import "YZShoppingCartBottomView.h"
#import "UIView+LayoutMethods.h"
#import "NSString+Size.h"
#import "ShoppingCartViewModel.h"

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

@interface YZShoppingCartBottomView()

@property (nonatomic, nullable, strong) ShoppingCartViewModel *viewModel;

@property (nonatomic, nullable, weak) UIView *lineView;
@property (nonatomic, nullable, weak) UIImageView *bgImageView;
@property (nonatomic, nullable, weak) UIButton *allSelectedBtn;
@property (nonatomic, nullable, weak) UILabel *allPriceLabel;
@property (nonatomic, nullable, weak) UILabel *freightLabel;
@property (nonatomic, nullable, weak) UIButton *settleButton;

@end

@implementation YZShoppingCartBottomView

+ (instancetype)initWithViewModel:(ShoppingCartViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (instancetype)initWithViewModel:(ShoppingCartViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self setupViews];
        
        [RACObserve(self, viewModel.allSelectedState) subscribeNext:^(NSNumber *selected) {
            self.allSelectedBtn.selected = [selected boolValue];
        }];
        
        [RACObserve(self, viewModel.totalPrice) subscribeNext:^(NSString *totalPrice) {
            [self setupPriceLabelWithTotalPrice:totalPrice];
        }];;
        
        [RACObserve(self, viewModel.selectedGoodsCount) subscribeNext:^(NSNumber *count) {
            [self setupSettleButtonTitleWithCount:[count integerValue]];
        }];
    }
    return self;
}

- (void)setupPriceLabelWithTotalPrice:(NSString *)totalPrice {
    
    NSString *price = [NSString stringWithFormat:@"合计:￥%@", totalPrice];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor redColor]};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:price];
    NSRange range = [price rangeOfString:@"合计:"];
    NSUInteger index = range.location + range.length;
    NSRange effectiveRange = NSMakeRange(index, price.length - index);
    [attrStr setAttributes:attributes range:effectiveRange];
    
    self.allPriceLabel.attributedText = attrStr;
}

- (void)setupSettleButtonTitleWithCount:(NSInteger)count {
    NSString *settleStr = [NSString stringWithFormat:@"结算(%ld)", count];
    [self.settleButton setTitle:settleStr forState:UIControlStateNormal];
}

- (void)selectAll:(UIButton *)button {
    button.selected = !button.selected;
    [self.viewModel allSelectedCommandWithState:button.selected];
    [self.viewModel.allSelectedCommand execute:@1];
}

- (void)settleButtonClick:(UIButton *)button {
    NSString *tempStr = button.currentTitle;
    if ([tempStr isEqualToString:@"结算"]) {
//        [NSObject hudClass_showMessage:@"请选择商品"];
        return;
    }
    tempStr = [tempStr substringToIndex:tempStr.length - 1];
    tempStr = [tempStr substringFromIndex:3];
    if ([tempStr isEqualToString:@"0"]) {
//        [NSObject hudClass_showMessage:@"请选择商品"];
        return;
    }

}

- (void)setupViews {
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    //背景图片
    UIImageView *bgImageView = [[UIImageView alloc] init];
//    bgImageView.image = [UIImage imageNamed:@"shopping_bottom_bg"];
    bgImageView.backgroundColor = [UIColor whiteColor];
    bgImageView.userInteractionEnabled = YES;
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    //全选按钮
    UIButton *allSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allSelectedBtn setImage:[UIImage imageNamed:@"shoppingcart_goods_default_icon"] forState:UIControlStateNormal];
    [allSelectedBtn setImage:[UIImage imageNamed:@"shoppingcart_goods_selected_icon"] forState:UIControlStateSelected];
    [allSelectedBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectedBtn setTitleColor:HEXCOLOR(0x444444) forState:UIControlStateNormal];
    allSelectedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [allSelectedBtn addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:allSelectedBtn];
    self.allSelectedBtn = allSelectedBtn;
    
    //合计
    UILabel *allPriceLabel = [[UILabel alloc] init];
    allPriceLabel.text = @"合计:";
    allPriceLabel.textAlignment = NSTextAlignmentRight;
    allPriceLabel.font = [UIFont systemFontOfSize:15.f];
    allPriceLabel.textColor = HEXCOLOR(0x444444);
    [bgImageView addSubview:allPriceLabel];
    self.allPriceLabel = allPriceLabel;
    
    //是否含运费
    UILabel *freightLabel = [[UILabel alloc] init];
    freightLabel.text = @"不含运费";
    freightLabel.textAlignment = NSTextAlignmentRight;
    freightLabel.textColor = HEXCOLOR(0x777777);
    freightLabel.font = [UIFont systemFontOfSize:12.f];
    [bgImageView addSubview:freightLabel];
    self.freightLabel = freightLabel;
    
    //结算
    UIButton *settleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settleButton setTitle:@"结算" forState:UIControlStateNormal];
    [settleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [settleButton setBackgroundImage:[UIImage imageNamed:@"background_icon"] forState:UIControlStateNormal];
    [settleButton addTarget:self action:@selector(settleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:settleButton];
    self.settleButton = settleButton;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    self.lineView.frame = CGRectMake(0, 0, self.width, 0.5);
    
    self.bgImageView.frame = CGRectMake(0, self.lineView.bottom, self.width, self.height - self.lineView.height);
    
    CGFloat selectedX = 0;
    CGFloat selectedY = 0;
    CGFloat selectedW = 79;
    CGFloat selectedH = self.height;
    self.allSelectedBtn.frame = CGRectMake(selectedX, selectedY, selectedW, selectedH);
    
    CGFloat settleW = 100;
    CGFloat settleX = self.width - settleW;
    CGFloat settleY = 0;
    CGFloat settleH = self.height;
    self.settleButton.frame = CGRectMake(settleX, settleY, settleW, settleH);
    
    CGFloat priceW = self.width - self.allSelectedBtn.right - self.settleButton.width - margin;
    CGFloat priceX = self.width - self.settleButton.width - priceW - margin;
    CGFloat priceY = 0;
    CGFloat priceH = self.height * 0.7;
    self.allPriceLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);
    
    CGFloat freightX = priceX;
    CGFloat freightY = self.allPriceLabel.bottom;
    CGFloat freightW = self.allPriceLabel.width;
    CGFloat freightH = self.height - self.allPriceLabel.height - 5;
    self.freightLabel.frame = CGRectMake(freightX, freightY, freightW, freightH);
}

@end
