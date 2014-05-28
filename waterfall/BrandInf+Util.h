//
//  UserInf+Util.h
//  brandshow
//
//  Created by lance on 14-4-24.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import "BrandInf.h"

@interface BrandInf (Util)

+(BrandInf *) initSetFromDict:(NSDictionary *)dict;

+(BrandInf *)initInfFromDict:(NSDictionary *)dict;

//从json数组中初始化---品牌列表---得到基本信息
+(NSMutableArray *)initFromArray:(NSArray *)arr;
//赋值设置信息
-(BrandInf *) combineSetInf:(BrandInf *)inf;

@end
