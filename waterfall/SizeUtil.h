//
//  SIzeUtil.h
//  brandshow
//
//  Created by lance on 14-5-26.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SizeUtil : NSObject

/** 根据视图宽度和字体得到需要的尺寸空间 */
+ (CGSize) calHeight:(NSString *)str width:(int)width font:(UIFont *)fontp;

/** 计算单行的高度 */
+ (CGSize)calSingleLine:(NSString *)str width:(int)width font:(UIFont *)fontp;

@end
