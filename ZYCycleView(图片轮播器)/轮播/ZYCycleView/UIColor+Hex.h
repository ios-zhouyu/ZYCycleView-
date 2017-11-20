//
//  UIColor+Hex.h
//  轮播
//
//  Created by zhouyu on 2017/11/20.
//  Copyright © 2017年 zhouyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
// 颜色转换：iOS中（以#开头,如红色#ff0000）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;

/**
 产生随机颜色
 
 @return 随机产生的颜色值
 */
+ (UIColor *)randomColor;
@end
