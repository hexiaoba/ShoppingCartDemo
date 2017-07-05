//
//  NSString+size.m
//  MeiTuan
//
//  Created by 何凯楠 on 16/6/20.
//  Copyright © 2016年 HeXiaoBa. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

/**
 *  根据字体算出字符串的size
 *
 *  @param font 字体
 *  @param size 大小
 *
 *  @return CGSize
 */
- (CGSize)stringSizeWithFont:(UIFont *)font size:(CGSize)size {
    NSDictionary *attr = @{NSFontAttributeName : font};
    CGSize result = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    return result;
}

- (CGSize)stringSizeWithFont:(UIFont *)font {
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    return [self stringSizeWithFont:font size:size];
}


- (CGSize)stringSizeWithFontFloat:(CGFloat)fontFloat {
    return [self stringSizeWithFont:[UIFont systemFontOfSize:fontFloat]];
}

@end
