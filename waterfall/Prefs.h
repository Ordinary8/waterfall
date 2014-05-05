//
//  Prefs.h 保存到用户参数文件
//  Prefs
//
//  Created by Xu Alex on windows on 11/14/10.
//  Copyright 2010 Lynx Studio Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface Prefs : NSObject {

}

//获取默认的登录id
+(int) getDefaultId;
//加载远程数据
+(NSData *)loadDataFromURL:(NSString *)URLString;
//将表示颜色的16进制字符串转化为color对象
+(UIColor *)colorWithHexString: (NSString *) stringToConvert;
/** 播放系统声音 */
+ (void)playSystemSound:(NSString *)fullPath;
//准备播放音频
+ (AVAudioPlayer *)prepareSound:(NSString *)fullPath;
//播放声音
+ (void)playSound:(AVAudioPlayer *)player;

#pragma mark - 保存参数文件
//保存键值对
+(void)saveToUserDefaults:(NSString*)key value:(id)value;
//取出key的值
+(id)retrieveFromUserDefaults:(NSString*) key;
//清空用户数据
+(void)clearAllUserDefaults;
//判断邮箱的有效性
+(BOOL)isValidEmailAddress:(NSString*) email;
//获取时间信息
+(NSDateComponents *) myGetTimeInfo;


+(NSString *)LunarForSolar:(NSDate *)solarDate;
+(NSString *)formatTimer:(int)Hour Minutes:(int)Minutes Seconds:(int)Seconds;

+ (UILabel *)getLabel:(NSUInteger)fontSize bold:(BOOL) b color:(UIColor*)color;

+ (void)dailPhone:(NSString *) dailPhoneNumber view:(UIView *)view;
+ (NSMutableArray *)getDirFilenameList:(NSString *)Folder;
/** 计算字符串长度 */
+ (int)stringLength:(NSString  *)str;
/** 将时间转化为字符串 */
+(NSString *)dateConvertToString:(NSDate *)date ;

//根据英文名获取类型信息
+ (NSDictionary *)getTypeByEname:(NSString *)ename;
//根据ID获取类型信息
+ (NSDictionary *)getTypeByID:(int)tpid;
//2个nsdate相差的天数
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

+ (NSString *)urlencode:(NSString *)fstr;

+ (NSData*)encodeDictionary:(NSDictionary*)dictionary;

+ (BOOL)willShowWriteComment;
+ (void)updateSavedTimes;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+ (NSString *)getOrign:(NSString *)name;

//根据key获取保存的值
+ (NSString *)getPrefs:(NSString *)key;
//保存key和值
+ (void)setPrefs:(NSString *)key value:(NSString *)value;
//将结果缓存到文件
+ (void)cacheResult:(NSDictionary *)dic withName:(NSString *)name;
//获取缓存文件的结果
+ (NSDictionary *)getCacheResult:(NSString *)name;

+ (NSString *)getServicePhone:(NSString *)name dict:(NSDictionary *)paramDict;

+ (NSString *)getServicePhoneString:(NSString *)name;

+ (NSURL *)getServicePhoneUrl:(NSString *)name;

+ (NSString *)getServicePad:(NSString *)name dict:(NSDictionary *)paramDict;
//最新常用方法
+ (NSString *)getServicePadString:(NSString *)name;

#pragma mark - 根据参数创建远程接口地址
+ (NSURL *)getServicePadUrl:(NSString *)name;

//封装带参数的远程服务地址
+ (NSURL *)getServicePadUrl:(NSString *)name withParams:(NSString *)params;

/** 是否支持叠层 */
//+(BOOL) getEnabledIndexes;
/** 是否显示营销按钮 */
//+(BOOL) getEnabledSalebar;
///** 是否支持现场取景 */
//+(BOOL) getEnabledPropicPhoto;
///** 是否支持背景缩放 */
//+(BOOL) getEnabledPropicZoom;
///** 是否启用场景 */
//+(BOOL) getEnabledScene;
///** 编辑效果 */
//+(BOOL) getEnabledEdit;

@end
