//
//  Wallpaper+Util.h
//  brandshow
//
//  Created by lance on 14-3-24.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import "ProductInf.h"

@interface ProductInf (Util)

//从文件中初始化场景
+(NSMutableArray*) initFromFile;

//从json数组中初始化数组
+(NSMutableArray *) initFromArrForMall:(NSArray *)arr;

@end
