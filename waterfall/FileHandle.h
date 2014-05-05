//
//  FileHandle.h
//  Wallinter
//
//  Created by lance on 14-2-22.
//  Copyright (c) 2014年 lance. All rights reserved.
//

//文件处理类

#import <Foundation/Foundation.h>

@interface FileHandle : NSObject

//判断文件是否存在
+ (BOOL) existFile:(NSString *) dir fileName:(NSString *) fileName;
//写入图像数据到文件路径
+ (BOOL) writeImage:(NSData *) data to:(NSString *) dir fileName:(NSString *) fileName;
//根据文件路径获取图片
+ (UIImage *) getImageWithDir:(NSString *)dir fileName:(NSString *) fileName;
//删除指定路径的文件
+ (BOOL) deleteFile:(NSString *) filePath;
//获取文件夹下的所有内容
+ (NSArray *) contentOfDir:(NSString *) dir;

/* 获取程序的Home目录 */
+ (NSString *) getHomeDirectory;
//获取document目录
+ (NSString *) getDocumentDir;
//获取cache目录
+ (NSString *) getCacheDirectory;
//获取Library目录
+ (NSString *) getLibraryDirectory;
//获取Tmp目录
+ (NSString *) getTempDirectory;

//获取图片缓存目录
+ (NSString *) getResourceCacheDirectory;
//社区主图片缓存目录
+ (NSString *) getUnityCacheDirectory;
+ (NSString *) getPanoramicCacheDirectory;
+ (NSString *) getPlistCacheDirectory;
+ (NSString *) getTexCacheDirectory;

//根据名称返回经过md5处理的文件名的二进制数据
+ (NSData *) getTexData:(NSString *)name isSync:(BOOL)flag;
/** 根据文件创建图片 */
+ (UIImage *) getTexImage:(NSString *)name isSync:(BOOL)flag;

//返回单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath;
//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath;

@end
