//
//  NetHttpRequest.h
//  brandshow
//
//  Created by lance on 14-3-18.
//  Copyright (c) 2014年 lance. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@protocol NetHttpRequestDelegate;

// 这里主要负责调用webservice方法
@interface NetHttpRequest : NSObject

//======================同步方法====soap协议========================
//提交场景参数到服务器
+(BOOL) setSceneParams:(NSString *)sceneId param:(NSString *) params;
+ (ASIHTTPRequest *) callHttpSync:(NSString *) methodName paramDict:(NSDictionary *) paramDict;
//通过url GET请求数据
+ (ASIHTTPRequest *) callSyncForURL:(NSURL *) url cache:(ASIDownloadCache *)cache;
//通过字符串
+ (NSString *) callSyncURL:(NSString *) urlStr;
//通过url POST请求数据
+ (NSString *) callPostSyncURL:(NSString *) urlStr;
//检测更新
+ (NSMutableDictionary *) checkUpdate:(NSString *) urlStr;
//快递接口
+ (NSString *) callSyncExpressWithCom:(NSString *)com nu:(NSString *)nu;



//通过方法名调用接口
+ (NSString *) callSyncWithMethodName:(NSString *)methodName paramDict:(NSDictionary *) paramDict;

+ (NSString *) callSyncWithMethodName:(NSString *)methodName paramDict:(NSDictionary *)paramDict userInfo:(NSDictionary *) userInfo;
//同步下载图片文件
+ (NSData *) downloadSync:(NSString *) urlParam;
//同步下载图片并保存到本地
+ (BOOL) downloadSync:(NSString *) urlParam saveTo:(NSString *)dir fileName:(NSString *)fileName;

//======================异步回调===soap协议==========================
+(void) callAsyncWithDelegate:(id<ASIHTTPRequestDelegate>) delegate methodName:(NSString *)methodName paramsDict:(NSMutableDictionary *) paramsDict;

+(void) callAsyncWithDelegate:(id<ASIHTTPRequestDelegate>) delegate methodName:(NSString *)methodName paramsDict:(NSMutableDictionary *) paramsDict userInfo:(NSDictionary *)userIfo;

+ (void) callService:(NSString *)methodName paramsDict:(NSMutableDictionary *)param delegate:(id<NetHttpRequestDelegate>)delegate message:(int)msgid;
//异步下载图片文件
+ (void) downloadSync:(NSString *) urlParam fileName:(NSString *) fileName delegate:(id<NetHttpRequestDelegate>) delegate message:(int) msgid;
//同步方法下载数据请求
+ (ASIHTTPRequest *) downloadSyncData:(NSURL *)urlParam;

+ (ASIHTTPRequest *) postFormData:(NSURL *)urlParam dictParams:(NSDictionary *)dictParams;

@end

//这里定义一个回调协议
@protocol NetHttpRequestDelegate <NSObject>
@optional
//这里返回字符串数据
-(void) callFinish:(NSString *)result message:(int)msgid;
//这里返回图像数据
-(void) callDataFinish:(NSData *)result message:(int)msgid;

@end
