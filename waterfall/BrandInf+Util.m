//
//  UserInf+Util.m
//  brandshow
//
//  Created by lance on 14-4-24.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import "BrandInf+Util.h"

@implementation BrandInf (Util)

//得到设置等相关属性---这个需要单独请求
+(BrandInf *) initSetFromDict:(NSDictionary *)dict
{
    BrandInf * inf=[[BrandInf alloc] init];
    inf.uid=[[dict objectForKey:@"uid"] intValue];
    inf.usname=[dict objectForKey:@"usname"];
    inf.istrade=[[dict objectForKey:@"istrade"] intValue];
    inf.isshoot=[[dict objectForKey:@"isshoot"] intValue];
    inf.isgrdsel=[[dict objectForKey:@"isgrdsel"] intValue];
    inf.ispicture=[[dict objectForKey:@"ispicture"] intValue];
    inf.isvideo=[[dict objectForKey:@"isvideo"] intValue];
    inf.isgrdset=[[dict objectForKey:@"isgrdset"] intValue];
    inf.paytype=[[dict objectForKey:@"paytype"] intValue];
    @try {
        inf.dspan=[[dict objectForKey:@"dspan"] intValue];
    }@catch (NSException *exception) {}
    @try {
        inf.msg=[dict objectForKey:@"msg"];
    }@catch (NSException *exception) {}
    
    inf.userStatus=0;
    return inf;
}

//合并设置信息
-(BrandInf *) combineSetInf:(BrandInf *)inf
{
    self.uid=inf.uid;
    self.istrade=inf.istrade;
    self.isshoot=inf.isshoot;
    self.isgrdsel=inf.isgrdsel;
    self.ispicture=inf.ispicture;
    self.isvideo=inf.isvideo;
    self.isgrdset=inf.isgrdset;
    self.paytype=inf.paytype;
    
    self.msg=inf.msg;
    
    return self;
}

//从json字典中初始化---得到品牌基本信息
+(BrandInf *)initInfFromDict:(NSDictionary *)dict
{
    BrandInf * inf=[[BrandInf alloc] init];
    inf.uid=[[dict objectForKey:@"id"] intValue];
    inf.usname=[dict objectForKey:@"usname"];
    inf.photo=[dict objectForKey:@"photo"];
    inf.company=[dict objectForKey:@"company"];
    inf.addr=[dict objectForKey:@"addr"];
    inf.phone=[dict objectForKey:@"phone"];
    return inf;
}

//从json数组中初始化---品牌列表---得到基本信息
+(NSMutableArray *)initFromArray:(NSArray *)arr
{
    NSMutableArray * results=[[NSMutableArray alloc] initWithCapacity:1];
    for (int i=0; i<arr.count; i++) {
        NSDictionary * dict=[arr objectAtIndex:i];
        BrandInf * inf=[self initInfFromDict:dict];
        [results addObject:inf];
    }
    return results;
}

@end
