//
//  CommunityInf.h
//  brandshow
//
//  Created by lance on 14-4-28.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 社区信息 */
@interface CommunityInf : NSObject

//社区信息标题
@property (nonatomic,retain) NSString* title;
//信息描述
@property (nonatomic,retain) NSString* content;
//信息主图
@property (nonatomic,retain) NSString* picUnity;
//主图宽度
@property (nonatomic,assign) float picWidth;
//主图高度
@property (nonatomic,assign) float picHeight;
//保存图片的下载状态---如果下载失败就显示默认的图片
@property (nonatomic,assign) BOOL flag;


@end
