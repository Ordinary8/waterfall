//
//  AppDelegate.h
//  waterfall
//
//  Created by lance on 14-05-05..
//  Copyright (c) 2013年 harry.xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIDownloadCache.h"

@class UserInf;
@class ProductInf;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *naviController;
//将用户信息保存到内存---不需要缓存
@property (strong, nonatomic) UserInf *userInf;
//用于展示屏幕保护的定时器
@property (strong, nonatomic) NSTimer *screenSaverTimer;
//这样的话需要遍历添加
@property (strong, nonatomic) NSMutableArray *productCart;//购物车列表  保存的是一个字典类

@property (strong, nonatomic) NSString *colorname;//颜色名
@property (strong, nonatomic) NSString *relatename;//相关名
@property (assign, nonatomic) int sleepSecond;//屏保时间
@property (strong, nonatomic) NSString *logoimgpath;//品牌标志路径
@property (assign, nonatomic) BOOL netActive;//是否有网络---三方控件监听
//自定义下载缓存---该对象用于在UI展示时获取数据的策略
@property (nonatomic,retain) ASIDownloadCache *customCache;

+ (AppDelegate *) shareInstance;


@end
