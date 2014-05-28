//
//  Wallpaper.h 墙纸模型
//  brandshow
//
//  Created by lance on 14-3-24.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInf : NSObject

//产品ID--productID
@property (nonatomic,retain) NSNumber * productID;
//子分类  prdLitID
@property (nonatomic,retain) NSNumber *prdLitID;
//产品标题
@property (nonatomic,retain) NSString *productTitle;
//产品缩略图 md5加密后保存为本地文件
@property (nonatomic,retain) NSString * prdPic;
//产品大图
@property (nonatomic,retain) NSString * prdLargePic;
//价格
@property (nonatomic,retain) NSNumber * prdPrice;
//产品描述
@property (nonatomic,retain) NSString *productDesc;

@property (nonatomic,assign) int bid;
//产品描述
@property (nonatomic,retain) NSString *brdname;

/////////////////////新增///////////////////////////
@property (nonatomic,retain) NSString * brdimg;//产品对应品牌logo
@property (nonatomic,retain) NSNumber * preferprice;//优惠价
/////////////////////////////////////////////////////

//配置关联的场景 -PrdGrounds
@property (nonatomic,retain) NSMutableArray * prdGrounds;
//产品图片---包含多个字典类 颜色,图片 colorV,imgurl--productImag
@property (nonatomic,retain) NSArray * productImag;
//相关图片,产品的小部件 包含多个字典类 productImage--productRelated
@property (nonatomic,retain) NSArray * productRelated;
//产品3D,视频展示文件,一般只会有1组数据 prodView
@property (nonatomic,retain) NSArray *productViews;

//购物车产品数量
@property (nonatomic,assign) int count;

//附件字段---保存图片的宽高
@property (nonatomic,assign) float picWidth;
@property (nonatomic,assign) float picHeight;
//记录图片是否下载
@property (nonatomic,assign) BOOL flag;

@end
