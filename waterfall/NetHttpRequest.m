//
//  NetHttpRequest.m
//  brandshow
//
//  Created by lance on 14-3-18.
//  Copyright (c) 2014年 lance. All rights reserved.
//

#import "NetHttpRequest.h"
#import "ASIHTTPRequest.h"
#import "XMLReader.h"
#import "FileHandle.h"
#import "JSONKit.h"

//#import "AppDelegate.h"

#define wsdl @"http://wa.wallinter.com/services/goodsservice.asmx/"
#define ickd_key @"9DF88C356D2F801DE05E0B0BCF8573F0"
//解析json字符串内容键
#define KEY @"text"

@implementation NetHttpRequest

/** 条用http请求 */
+ (ASIHTTPRequest *) callHttpSync:(NSString *) methodName paramDict:(NSDictionary *) paramDict
{
    NSMutableString * urlStr=[NSMutableString stringWithFormat:@"%@%@%@%@?",DOMAIN_HOST,PADSERVICE,methodName,EXTNAME];
    NSArray * keys=[paramDict allKeys];
    for (int i=0; i<keys.count; i++) {
        NSString *key=[keys objectAtIndex:i];
        if(i!=keys.count-1){
            [urlStr appendFormat:@"%@=%@&",key,[paramDict objectForKey:key]];
        }else{
            [urlStr appendFormat:@"%@=%@",key,[paramDict objectForKey:key]];
        }
    }
    NSURL * url=[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest * request=[ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    return request;
    
}

/** 返回格式:{"m":n}  说明:n>0设置成功 n<=0 设置失败 */
+(BOOL) setSceneParams:(NSString *)sceneId param:(NSString *) params
{
    NSMutableString * urlStr=[NSMutableString stringWithFormat:@"%@%@%@%@?",DOMAIN_HOST,PADSERVICE,@"SetGroundParam",EXTNAME];
    [urlStr appendFormat:@"gid=%@&",sceneId];
    [urlStr appendFormat:@"params=%@",params];
    NSURL * url=[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest * request=[ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    NSError * error=[request error];
    if(error==nil){
        NSString *result=[request responseString];
        NSDictionary * dict=[result objectFromJSONString];
        int res=[[dict objectForKey:@"m"] intValue];
        if(res>0){
            return YES;
        }
    }
    return NO;
}


//调用快递接口 授权id 9DF88C356D2F801DE05E0B0BCF8573F0
//快递公司代码 yunda 运单号 1600427091575 type:json/htm/text/xml encode:gbk/utf8
+ (NSString *) callSyncExpressWithCom:(NSString *) com nu:(NSString *)nu
{
    NSString * req_url_string=[NSString stringWithFormat:@"http://api.ickd.cn/?com=%@&nu=%@&id=%@&type=&encode=&ord=&lang=",com,nu,ickd_key];
    return [[self class] callPostSyncURL:req_url_string];
}

//通过url GET请求数据
+ (ASIHTTPRequest *) callSyncForURL:(NSURL *) url cache:(ASIDownloadCache *)cache
{
    ASIHTTPRequest * request=[ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setDownloadCache:cache];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request startSynchronous];
    return request;
}
//webservice url通用接口
+ (NSString *) callSyncURL:(NSString *) urlStr
{
    NSURL * url=[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest * req=[ASIHTTPRequest requestWithURL:url];
    [req setRequestMethod:@"GET"];
    [req startSynchronous];
    NSError * error=[req error];
    if(!error){//如果没有错误
        return [req responseString];
    }else{
        //NSLog(@"接口错误:%@",[error localizedDescription]);
    }
    return nil;
}
//通过url POST请求数据
+ (NSString *) callPostSyncURL:(NSString *) urlStr
{
    NSURL * url=[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest * req=[ASIHTTPRequest requestWithURL:url];
    [req setRequestMethod:@"POST"];
    [req startSynchronous];
    NSError * error=[req error];
    if(!error){//如果没有错误
        return [req responseString];
    }else{
        //NSLog(@"接口错误:%@",[error localizedDescription]);
    }
    return nil;
}

//webservice url通用接口
+ (NSString *) callSyncUrl:(NSString *) urlStr
{
    NSURL * url=[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest * req=[ASIHTTPRequest requestWithURL:url];
    [req setRequestMethod:@"GET"];
    [req startSynchronous];
    NSError * error=[req error];
    if(!error){//如果没有错误
        return [req responseString];
    }else{
        //NSLog(@"接口错误:%@",[error localizedDescription]);
    }
    return [req responseString];
}

//检测更新 返回字典
+ (NSMutableDictionary *) checkUpdate:(NSString *) urlStr
{
    static NSString *resultKey=@"resultKey";
    static NSString *trackViewUrl=@"trackViewUrl";
    NSMutableDictionary * result=[NSMutableDictionary dictionary];
    
    NSString * json=[NetHttpRequest callSyncURL:urlStr];
    if(json!=nil){
        NSArray *infs=[[json objectFromJSONString] objectForKey:@"results"];
        if(infs.count>0){
            NSDictionary * releaseInf=[infs objectAtIndex:0];
            NSString * lastVersion=[releaseInf objectForKey:@"version"];
            NSString * upgradeURL=[releaseInf objectForKey:trackViewUrl];
            //CFBundleShortVersionString
            //获取 version  CFBundleShortVersionString  获取版本号 CFBundleVersion
            //https://itunes.apple.com/us/app/zhi-neng-qiang-zhi-dian/id785991017?mt=8&uo=4
            NSString * localVersion=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if([lastVersion isEqualToString:localVersion]){
                [result setObject:@"0" forKey:resultKey];
            }else{
                [result setObject:@"1" forKey:resultKey];
            }
            [result setObject:upgradeURL forKey:trackViewUrl];
        }else{
            [result setObject:@"0" forKey:resultKey];
            [result setObject:@"" forKey:trackViewUrl];
        }
    }else{
        [result setObject:@"-1" forKey:resultKey];
        [result setObject:@"" forKey:trackViewUrl];
    }
    return result;
}

+ (NSString *) callSyncWithMethodName:(NSString *) methodName paramDict:(NSDictionary *) paramDict
{
    return [[self class] callSyncWithMethodName:methodName
                                      paramDict:paramDict userInfo:nil];
}


//==========================================Webservice SOAP方法======================================

+ (NSString *) callSyncWithMethodName:(NSString *)methodName paramDict:(NSDictionary *)paramDict userInfo:(NSDictionary *) userInfo
{
    NSMutableString * url_string=[NSMutableString stringWithFormat:@"%@",wsdl];
    [url_string appendFormat:@"%@?",methodName];
    
    NSArray * keys=[paramDict allKeys];
    for (int i=0; i<keys.count; i++) {
        NSString *key=[keys objectAtIndex:i];
        if(i!=keys.count-1){
            [url_string appendFormat:@"%@=%@&",key,[paramDict objectForKey:key]];
        }else{
            [url_string appendFormat:@"%@=%@",key,[paramDict objectForKey:key]];
        }
    }
    NSURL * url=[NSURL URLWithString:[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest * req=[ASIHTTPRequest requestWithURL:url];
    [req setRequestMethod:@"GET"];
    [req setUserInfo:userInfo];
    
    [req startSynchronous];
    
    NSError * error=[req error];
    if(!error){
        NSString * theResp=[req responseString];
        NSDictionary *xmlDict=[XMLReader dictionaryForXMLString:theResp error:nil];
        NSDictionary * clearDict=[[self class] extractXML:[xmlDict mutableCopy]];
        NSDictionary *resultDict=[clearDict objectForKey:@"string"];
        //这里获取命名空间;这里没有使用价值
        //NSString * nameSpace=[resultDict objectForKey:@"xmlns"];
        NSString *result=[resultDict objectForKey:KEY];
        return result;
    }else{
        //NSLog(@"down fail:%@",[error localizedDescription]);
    }
    return nil;
}

+ (NSData *) downloadSync:(NSString *) urlParam
{
    NSURL * url=[NSURL URLWithString:[urlParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"远程下载地址-->%@",urlParam);
    ASIHTTPRequest * req=[ASIHTTPRequest requestWithURL:url];
    [req setRequestMethod:@"GET"];
    
    [req startSynchronous];
    
    NSError * error=[req error];
    if(!error){
        return [req responseData];
    }else{
        //NSLog(@"down fail:%@",[error localizedDescription]);
    }
    return nil;
}

+ (BOOL) downloadSync:(NSString *) urlParam saveTo:(NSString *)dir fileName:(NSString *)fileName
{
    if ([[FileHandle class] existFile:dir fileName:fileName]) {//如果文件存在
        return YES;
    }
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlParam]];
    [request startSynchronous];
    int statusCode = [request responseStatusCode];
    if(statusCode==200){//远程文件存在
        NSError * error=[request error];
        if(!error){
            NSData *data=[request responseData];
            return [[FileHandle class] writeImage:data to:dir fileName:fileName];
        }
    }
    return NO;
}

//==================================异步方法===================================

//通过方法名调用指定的接口
+ (void) callService:(NSString *)methodName paramsDict:(NSMutableDictionary *)param delegate:(id<NetHttpRequestDelegate>)delegate message:(int)msgid{
    dispatch_queue_t pool = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(pool, ^{
        NSString * result=[[self class] callSyncWithMethodName:methodName paramDict:param];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(delegate!=nil){
                [delegate callFinish:result message:msgid];
            }
        });
    });
}


//这个地方返回的委托需要特别处理
+(void) callAsyncWithDelegate:(id<ASIHTTPRequestDelegate>) delegate methodName:(NSString *)methodName paramsDict:(NSMutableDictionary *) paramsDict
{
    [[self class] callAsyncWithDelegate:delegate methodName:methodName paramsDict:paramsDict userInfo:nil];
}
//这个地方返回的委托需要特别处理
+(void) callAsyncWithDelegate:(id<ASIHTTPRequestDelegate>) delegate methodName:(NSString *)methodName paramsDict:(NSMutableDictionary *) paramsDict userInfo:(NSDictionary *)userIfo
{
    NSMutableString *url_string=[NSMutableString stringWithFormat:@"%@",wsdl];
    [url_string appendString:methodName];
    
    NSArray * keys=[paramsDict allKeys];
    
    for (int i=0; i<keys.count; i++) {
        NSString * key= [keys objectAtIndex:i];
        if(i!=keys.count-1){
            [url_string appendFormat:@"%@=%@&",key,[paramsDict objectForKey:key]];
        }else{
            [url_string appendFormat:@"%@=%@",key,[paramsDict objectForKey:key]];
        }
    }
    NSURL * url=[NSURL URLWithString:[url_string stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    ASIHTTPRequest * req=[ASIHTTPRequest requestWithURL:url];
    
    [req setRequestMethod:@"GET"];
    [req setUserInfo:userIfo];
    
    [req setDelegate:delegate];
    
    [req startAsynchronous];
}

//异步下载图片文件
+ (void) downloadSync:(NSString *) urlParam fileName:(NSString *) fileName delegate:(id<NetHttpRequestDelegate>) delegate message:(int) msgid
{
    dispatch_queue_t pool = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(pool, ^{
        NSData * data=[[self class] downloadSync:urlParam];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(delegate!=nil){
                [delegate callDataFinish:data message:msgid];
            }
        });
    });
}

//判断远程文件是否存在
+ (BOOL) isExistsRemoteFile:(NSString *)url
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request startSynchronous];
    int statusCode = [request responseStatusCode];
    if(statusCode==200){
        return YES;
    }
    return NO;
}


+ (ASIHTTPRequest *) postFormData:(NSURL *)urlParam dictParams:(NSDictionary *)dictParams
{
    NSArray * keys=[dictParams allKeys];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlParam];
    [request setDelegate:self];
    request.tag = 1020;
    for (int i=0; i<keys.count; i++) {
        NSString * key=[keys objectAtIndex:i];
        [request setPostValue:[dictParams objectForKey:key] forKey:key];
    }
    [request addSecret];
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    return request;
}

//=========================================辅助方法===============================================

#pragma mark private 提取webservice(SOAP协议)结果集XML中的内容 去掉不需要的内容
+ (NSMutableDictionary *) extractXML:(NSMutableDictionary *)xmlDictionary {
    
    for (NSString *key in [xmlDictionary allKeys]) {
        // get the current object for this key
        id object = [xmlDictionary objectForKey:key];
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            if ([[object allKeys] count] == 1 &&
                [[[object allKeys] objectAtIndex:0] isEqualToString:KEY] &&
                ![[object objectForKey:KEY] isKindOfClass:[NSDictionary class]]) {
                // this means the object has the key "text" and has no node
                // or array (for multiple values) attached to it.
                [xmlDictionary setObject:[object objectForKey:KEY] forKey:key];
            }else {
                // go deeper
                [self extractXML:object];
            }
        }else if ([object isKindOfClass:[NSArray class]]) {
            // this is an array of dictionaries, iterate
            for (id inArrayObject in (NSArray *)object) {
                if ([inArrayObject isKindOfClass:[NSDictionary class]]) {
                    // if this is a dictionary, go deeper
                    [self extractXML:inArrayObject];
                }
            }
        }
    }
    
    return xmlDictionary;
}

@end
