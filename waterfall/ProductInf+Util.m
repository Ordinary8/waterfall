//
//  Wallpaper+Util.m
//  brandshow
//
//  Created by lance on 14-3-24.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import "ProductInf+Util.h"
#import "NSString+Util.h"

@implementation ProductInf (Util)

//从文件中初始化场景
+(NSMutableArray*) initFromFile
{
    //plist文件是一个产品分组
    NSDictionary *dic = [Prefs getCacheResult:PRODUCT_FILE];
    NSArray *walls = [dic objectForKey:@"products"];
    NSMutableArray * wallArr=[[NSMutableArray alloc] init];
    
    for (int i=0; i<walls.count; i++) {
        NSDictionary * dict=[walls objectAtIndex:i];
        ProductInf * inf=[[ProductInf alloc] init];
        inf.productID=[dict objectForKey:@"productID"];
        inf.prdLitID=[dict objectForKey:@"prdLitID"];
        inf.prdPic=[dict objectForKey:@"prdPic"];
        //得到产品大图
        inf.prdLargePic=[self getLargePic:inf.prdPic];
        inf.prdPrice=[NSNumber numberWithInt:[[dict objectForKey:@"prdPrice"] intValue]];
        inf.productTitle=[dict objectForKey:@"productTitle"];
        inf.productDesc=[dict objectForKey:@"productDesc"];
        inf.productImag=[dict objectForKey:@"productImag"];
        inf.productRelated=[dict objectForKey:@"productRelated"];
        inf.productViews=[dict objectForKey:@"productViews"];
        inf.count=1;//默认数量为1
        NSMutableArray * grounds=[dict objectForKey:@"PrdGrounds"];
        
        NSMutableArray * tmps=[[NSMutableArray alloc] initWithCapacity:5];
        
        inf.prdGrounds=tmps;
        [wallArr addObject:inf];
    }
    return wallArr;
}

+(NSString *)getLargePic:(NSString *) picUrl
{
    NSString *fileName=[picUrl lastPathComponent];
    NSString *preUrl=[picUrl stringByDeletingLastPathComponent];
    NSString *nowFile=[fileName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"o"];
    return [preUrl stringByAppendingPathComponent:nowFile];
}

+(NSMutableArray *) initFromArrForMall:(NSArray *)arr
{
    NSMutableArray * wallArr=[[NSMutableArray alloc] init];

    for (int i=0; i<arr.count; i++) {
        NSDictionary * dict=[arr objectAtIndex:i];
        ProductInf * inf=[[ProductInf alloc] init];        
        inf.productID=[dict objectForKey:@"productID"];
        inf.prdLitID=[dict objectForKey:@"prdLitID"];
        inf.prdPic=[dict objectForKey:@"prdPic"];
        //得到产品大图
        inf.prdLargePic=[self getLargePic:inf.prdPic];
        inf.prdPrice=[NSNumber numberWithInt:[[dict objectForKey:@"prdPrice"] intValue]];
        inf.productTitle=[dict objectForKey:@"productTitle"];
        inf.productDesc=[dict objectForKey:@"productDesc"];
        inf.productImag=[dict objectForKey:@"productImag"];
        inf.productRelated=[dict objectForKey:@"productRelated"];
        inf.productViews=[dict objectForKey:@"productViews"];
        inf.brdimg=[dict objectForKey:@"brdimg"];
        inf.prdPic=[dict objectForKey:@"prdPic"];
        inf.productTitle=[dict objectForKey:@"productTitle"];
        inf.bid=[[dict objectForKey:@"bid"] intValue];
        inf.brdname=[dict objectForKey:@"brdname"];
        inf.prdPrice=[NSNumber numberWithInt:[[dict objectForKey:@"prdPrice"] intValue]];
        inf.preferprice=[NSNumber numberWithInt:[[dict objectForKey:@"PreferPrice"] intValue]];
        inf.count=1;//默认数量为1
        NSMutableArray * grounds=[dict objectForKey:@"PrdGrounds"];
        
        NSMutableArray * tmps=[[NSMutableArray alloc] initWithCapacity:5];

        inf.prdGrounds=tmps;
        [wallArr addObject:inf];
    }
    return wallArr;
}

//从数据库中初始化文件
+(NSArray*) initFromCoreData
{
    return nil;
}


@end
