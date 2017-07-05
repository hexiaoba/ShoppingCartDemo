//
//  YZGoodsCellRightEditView.m
//  YiZhongShop
//
//  Created by 何凯楠 on 16/7/13.
//  Copyright © 2016年 HeXiaoBa. All rights reserved.
//

#import "YZGoodsCellRightEditView.h"
#import "UIView+LayoutMethods.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIResponder+Router.h"



#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

@interface YZGoodsCellRightEditView()<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, nullable, weak) UITextField *countField;
@property (nonatomic, nullable, weak) UIButton *reduceButton;
@property (nonatomic, nullable, weak) UIButton *addButton;
@property (nonatomic, nullable, weak) UIButton *deleteButton;
@property (nonatomic, nullable, weak) UILabel *attrLabel;
@property (nonatomic, nullable, weak) UIView *leftLine;
@property (nonatomic, nullable, weak) UIView *rightLine;
@property (nonatomic, nullable, weak) UIView *bottomLine;

@end

@implementation YZGoodsCellRightEditView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self setupViews];
        
        [self observser];
        
    }
    return self;
}

- (void)observser {
    RAC(self, attrLabel.text) = RACObserve(self, attr);
    RAC(self, countField.text) = RACObserve(self, count);
}


/**
 *  修改购物车数量
 */
- (void)updateCartCountWithCount:(NSInteger)count {
    if (self.updateCountSubject) {
        [self.updateCountSubject sendNext:@(count)];
    }
}

- (void)reduceCountEvent:(UIButton *)button {
    NSInteger count = [self.countField.text integerValue];
    if (count <= 1) {
        self.reduceButton.enabled = NO;
        //        [self hud_showMessage:@"购买的商品数量不少于1件！"];
        return;
    }
    count--;
    [self updateCartCountWithCount:count];
}

- (void)addCountEvent:(UIButton *)button {
    NSInteger count = [self.countField.text integerValue];
    count++;
    [self updateCartCountWithCount:count];
    if (count > 1) {
        self.reduceButton.enabled = YES;
    } else {
        self.reduceButton.enabled = NO;
    }
}


/**
 *  删除商品
 */
- (void)deleteGoods {
    if (self.deleteCountSubject) {
        [self.deleteCountSubject sendNext:@1];
    }
}


- (void)setupViews {
    
    //减号按钮
    UIButton *reduceCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reduceCountButton setTitle:@"-" forState:UIControlStateNormal];
    [reduceCountButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [reduceCountButton addTarget:self action:@selector(reduceCountEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reduceCountButton];
    self.reduceButton = reduceCountButton;
    
    //减号左边线
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:leftLine];
    self.leftLine = leftLine;
    
    //数量
    UITextField *countField = [[UITextField alloc] init];
    countField.delegate = self;
    countField.textAlignment = NSTextAlignmentCenter;
    countField.keyboardType = UIKeyboardTypePhonePad;
    countField.enabled = NO;
    [self addSubview:countField];
    self.countField = countField;
    
    //数量左边线
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:rightLine];
    self.rightLine = rightLine;
    
    //加号按钮
    UIButton *addCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCountButton setTitle:@"+" forState:UIControlStateNormal];
    [addCountButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [addCountButton addTarget:self action:@selector(addCountEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addCountButton];
    self.addButton = addCountButton;
    
    //删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteButton.backgroundColor = [UIColor redColor];
    [deleteButton addTarget:self action:@selector(deleteGoods) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    self.deleteButton = deleteButton;
    
    //属性上边线
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomLine];
    self.bottomLine = bottomLine;
    
    //属性label
    UILabel *attrLabel = [[UILabel alloc] init];
    attrLabel.textColor = HEXCOLOR(0x777777);
    attrLabel.font = [UIFont systemFontOfSize:13.f];
    attrLabel.numberOfLines = 0;
    [self addSubview:attrLabel];
    self.attrLabel = attrLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat gap = 2;
    CGFloat margin = 10;
    
    CGFloat countW = 40;
    CGFloat deleteW = self.width * 0.3;
    CGFloat reduceW = (self.width - countW - deleteW - margin - 2 * gap) * 0.5;
    
    CGFloat reduceX = margin;
    CGFloat reduceY = margin;
    CGFloat reduceH = 40;
    
    self.reduceButton.frame = CGRectMake(reduceX, reduceY, reduceW, reduceH);
    
    CGFloat countX = self.reduceButton.right + gap;
    CGFloat countY = reduceY;
    CGFloat countH = reduceH;
    self.countField.frame = CGRectMake(countX, countY, countW, countH);
    
    self.leftLine.frame = CGRectMake(countX, countY, 1, countH);
    
    CGFloat addX = self.countField.right + gap;
    CGFloat addY = countY;
    CGFloat addW = reduceW;
    CGFloat addH = reduceH;
    self.addButton.frame = CGRectMake(addX, addY, addW, addH);
    
    self.rightLine.frame = CGRectMake(addX, addY, 1, addH);
    
    CGFloat deleteX = self.width - deleteW;
    CGFloat deleteY = 0;
    CGFloat deleteH = self.height;
    self.deleteButton.frame = CGRectMake(deleteX, deleteY, deleteW, deleteH);
    
    CGFloat attrX = margin;
    CGFloat attrY = self.reduceButton.bottom + gap;
    CGFloat attrW = self.width - margin - deleteW;
    CGFloat attrH = self.height - attrY - margin;
    self.attrLabel.frame = CGRectMake(attrX, attrY, attrW, attrH);
    
    self.bottomLine.frame = CGRectMake(attrX, attrY, attrW - margin, 1);
    
}

@end
