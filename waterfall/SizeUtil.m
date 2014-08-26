//
//  SIzeUtil.m
//  brandshow
//
//  Created by lance on 14-5-26.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import "SizeUtil.h"

@implementation SizeUtil

//根据视图宽度和字体得到需要的尺寸空间
+ (CGSize) calHeight:(NSString *)str width:(int)width font:(UIFont *)fontp
{
    
    return [str sizeWithFont:fontp constrainedToSize:CGSizeMake(width,9999)lineBreakMode:NSLineBreakByCharWrapping];
}

//计算单行的高度
+ (CGSize)calSingleLine:(NSString *)str width:(int)width font:(UIFont *)fontp
{
    CGSize singleLineStringSize=[str sizeWithFont:fontp];//单行高度
    return singleLineStringSize;
}

@end
