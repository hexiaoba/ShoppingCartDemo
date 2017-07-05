//
//  YZGoodsCellRightDefaultView.m
//  YiZhongShop
//
//  Created by 何凯楠 on 16/7/13.
//  Copyright © 2016年 HeXiaoBa. All rights reserved.
//

#import "YZGoodsCellRightDefaultView.h"
#import <HandyFrame/UIView+LayoutMethods.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

@interface YZGoodsCellRightDefaultView()
@property (nonatomic, nullable, weak) UILabel *goodsNameLabel;
@property (nonatomic, nullable, weak) UILabel *goodsAttrLabel;
@property (nonatomic, nullable, weak) UILabel *goodsPriceLabel;
@property (nonatomic, nullable, weak) UILabel *goodsCountLabel;

@end

@implementation YZGoodsCellRightDefaultView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        
        [self observser];
    }
    return self;
}

- (void)observser {
    RAC(self, goodsPriceLabel.text) = RACObserve(self, price);
    RAC(self, goodsNameLabel.text) = RACObserve(self, name);
    RAC(self, goodsAttrLabel.text) = RACObserve(self, attr);
    RAC(self, goodsCountLabel.text) = RACObserve(self, count);
}

- (void)setupViews {
    //商品名称
    UILabel *goodsNameLabel = [[UILabel alloc] init];
    goodsNameLabel.textColor = HEXCOLOR(0x444444);
    goodsNameLabel.font = [UIFont systemFontOfSize:13.f];
    goodsNameLabel.numberOfLines = 2;
    [self addSubview:goodsNameLabel];
    self.goodsNameLabel = goodsNameLabel;
    
    //商品属性
    UILabel *goodsAttrLabel = [[UILabel alloc] init];
    goodsAttrLabel.textColor = HEXCOLOR(0x777777);
    goodsAttrLabel.font = [UIFont systemFontOfSize:12.f];
    [self addSubview:goodsAttrLabel];
    self.goodsAttrLabel = goodsAttrLabel;
    
    //商品价格
    UILabel *goodsPriceLabel = [[UILabel alloc] init];
    goodsPriceLabel.textColor = [UIColor redColor];
    goodsPriceLabel.font = [UIFont systemFontOfSize:12.f];
    [self addSubview:goodsPriceLabel];
    self.goodsPriceLabel = goodsPriceLabel;
    
    //商品购买的数量
    UILabel *goodsCountLabel = [[UILabel alloc] init];
    goodsCountLabel.textColor = HEXCOLOR(0x444444);
    goodsCountLabel.font = [UIFont systemFontOfSize:16.f];
    goodsCountLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:goodsCountLabel];
    self.goodsCountLabel = goodsCountLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    CGFloat nameX = margin;
    CGFloat nameY = margin;
    CGFloat nameW = self.width - nameX;
    CGFloat nameH = 40;
    self.goodsNameLabel.frame = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat attrX = nameX;
    CGFloat attrY = self.goodsNameLabel.bottom;
    CGFloat attrW = nameW;
    CGFloat attrH = 20;
    self.goodsAttrLabel.frame = CGRectMake(attrX, attrY, attrW, attrH);
    
    CGFloat priceX = attrX;
    CGFloat priceY = self.goodsAttrLabel.bottom + 5;
    CGFloat priceW = attrW * 0.5;
    CGFloat priceH = 20;
    self.goodsPriceLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);
    
    CGFloat countW = priceW - margin;
    CGFloat countX = self.width - countW - margin;
    CGFloat countY = priceY;
    CGFloat countH = 20;
    self.goodsCountLabel.frame = CGRectMake(countX, countY, countW, countH);
    
}


@end
