//
//  Prefs.m
//  Prefs
//
//  Created by Xu Alex on 11/14/10.
//  Copyright 2010 Lynx Studio Software. All rights reserved.
//

#import "Prefs.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "UIImage+Thumb.h"
#import "AppDelegate.h"
//#import "UIImage+UIImageExt.h"
#import "SDImageCache.h"
//#import "UIDevice+Resolutions.h"
#import "UserInf+Util.h"

#import "FileHandle.h"

@implementation Prefs

+(int) getDefaultId
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"configuration" ofType:@"plist"];
    NSDictionary * dict=[NSDictionary dictionaryWithContentsOfFile:path];
    return [[dict objectForKey:@"default_id"] intValue];
}

//http://www.sopin.cc/TBPhoneView/GetNews.ashx?m=46&bid=0&sid=0&mid=0&psize=10&pindex=1
//提交方式get
//m//查询类型 (m=1 按品牌来查询 如果bid=0 查询所有品牌资讯 ，如果传bid不为0 是查对应该品牌的资讯;m=2 按店员来查询 此时必须传sid ; m=3 按会员来查询 必须传 mid)
//bid//品牌ID
//sid //店员ID
//mid //会员ID
//psize//记录数
//pindex //页码

/** 封装phone url地址 */
+ (NSString *)getServicePhone:(NSString *)name dict:(NSDictionary *)paramDict{
    NSMutableString *urlTmp = [NSMutableString stringWithFormat:@"%@%@%@%@?",DOMAIN_HOST,PHONESERVICE,name,EXTNAME];
    NSArray * keys=[paramDict allKeys];
    for (int i=0; i<keys.count; i++) {
        NSString *key=[keys objectAtIndex:i];
        if(i!=keys.count-1){
            [urlTmp appendFormat:@"%@=%@&",key,[paramDict objectForKey:key]];
        }else{
            [urlTmp appendFormat:@"%@=%@",key,[paramDict objectForKey:key]];
        }
    }
    return urlTmp;
}

+ (NSString *)getServicePhoneString:(NSString *)name{
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",[AppDelegate shareInstance].userInf.uid] forKey:@"mercantID"];
    return [self getServicePhone:name dict:dict];
}

+ (NSString *)getServicePhoneUrl:(NSString *)name{
    return [NSURL URLWithString:[self getServicePhoneString:name]];
}

/** 封装pad url地址 */
+ (NSString *)getServicePad:(NSString *)name dict:(NSDictionary *)paramDict{
    NSMutableString *urlTmp = [NSMutableString stringWithFormat:@"%@%@%@%@?",DOMAIN_HOST,PADSERVICE,name,EXTNAME];
    NSArray * keys=[paramDict allKeys];
    for (int i=0; i<keys.count; i++) {
        NSString *key=[keys objectAtIndex:i];
        if(i!=keys.count-1){
            [urlTmp appendFormat:@"%@=%@&",key,[paramDict objectForKey:key]];
        }else{
            [urlTmp appendFormat:@"%@=%@",key,[paramDict objectForKey:key]];
        }
    }
    return urlTmp;
}

//最新常用方法
+ (NSString *)getServicePadString:(NSString *)name{
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",[AppDelegate shareInstance].userInf.uid] forKey:@"mercantID"];
    return [self getServicePad:name dict:dict];
}

#pragma mark - 根据参数创建远程接口地址
+ (NSURL *)getServicePadUrl:(NSString *)name{
    return [NSURL URLWithString:[self getServicePadString:name]];
}

// 获取服务/品牌/案例 地址 uid=64
+ (NSURL *)getServicePadUrl:(NSString *)name withParams:(NSString *)params {
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",[AppDelegate shareInstance].userInf.uid] forKey:@"mercantID"];
    int t=0;
    if ([params isEqualToString:@"-0"]) {
        t=0;
    }else if ([params isEqualToString:@"-1"]) {
        t=1;
    }else if ([params isEqualToString:@"-2"]) {
        t=2;
    }
    [dict setObject:[NSString stringWithFormat:@"%d",t] forKey:@"t"];
    return [NSURL URLWithString:[self getServicePad:name dict:dict]];
}

///** 获取原始 */
//+ (NSString *)getOrign:(NSString *)name{
//    NSString *last = [name lastPathComponent];
//    NSRange r = {0,1};
//    if ([[last substringToIndex:1] isEqualToString:@"t"]) {
//        NSString *mystring = [last stringByReplacingCharactersInRange:r withString:@"o"];
//        last = [name stringByReplacingOccurrencesOfString:last withString:mystring];
//        
//        if ([UIDevice currentResolution]==UIDevice_iPadStandardRes && ![[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:last]) {
//            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:last]]];
//            float w = img.size.width;
//            float h = img.size.height;
//            if (w>1024 || h>768) {
//                img = [img imageByScalingAndCroppingForSize:CGSizeMake(1024, 768)];
//            }
//            [[SDImageCache sharedImageCache] storeImage:img forKey:last];
//        }
//        return last;
//    }
//    return name;
//}

//获取沙盒plist文件根据key获取值
+ (NSString *)getPrefs:(NSString *)key{
    NSString *filename=[[FileHandle getPlistCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",PREFS_FILE]];
    NSMutableDictionary *data = [[[NSMutableDictionary alloc] initWithContentsOfFile:filename] autorelease];
    return [data objectForKey:key];
}

//保存键值对
+ (void)setPrefs:(NSString *)key value:(NSString *)value{
    NSString *filename=[[FileHandle getPlistCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",PREFS_FILE]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filename]){
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObject:value] forKeys:[NSArray arrayWithObject:key]];
        [data writeToFile:filename atomically:YES];
        [data release];
    }else {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
        [data setObject:value forKey:key];
        [data writeToFile:filename atomically:YES];
        [data release];
    }
}

//将结果缓存到指定名称的文件
+ (void)cacheResult:(NSDictionary *)dict withName:(NSString *)name{
    NSString *pname = [name stringByAppendingString:@".plist"];
    NSString *filename=[[FileHandle getPlistCacheDirectory] stringByAppendingPathComponent:pname];
    [dict writeToFile:filename atomically:YES];
}

//获取缓存结果
+ (NSDictionary *)getCacheResult:(NSString *)name{
    NSString *pname = [name stringByAppendingString:@".plist"];
    NSString *filename=[[FileHandle getPlistCacheDirectory] stringByAppendingPathComponent:pname];
    return [NSDictionary dictionaryWithContentsOfFile:filename];
}


//==========================老方法===========================
//准备音频文件
+ (AVAudioPlayer *)prepareSound:(NSString *)fullPath {
	NSString *extension = [fullPath pathExtension];
	NSString *filename = [fullPath substringToIndex:(fullPath.length - extension.length - 1)];
	NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
	NSURL *filePath = [NSURL fileURLWithPath:file isDirectory:NO];
    NSData *fileUrl=[[NSData alloc]initWithContentsOfURL:filePath];
	AVAudioPlayer *myplayer = [[[AVAudioPlayer alloc] initWithData:fileUrl error:nil] autorelease];
	[fileUrl release];
	return myplayer;
}
//播放声音文件
+ (void)playSound:(AVAudioPlayer *)player{
	[player setVolume: 1.0];
	[player play];
}
//播放系统声音
+ (void)playSystemSound:(NSString *)fullPath {
	NSString *extension = [fullPath pathExtension];
	NSString *filename = [fullPath substringToIndex:(fullPath.length - extension.length - 1)];
	NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
	NSURL *filePath = [NSURL fileURLWithPath:file isDirectory:NO];
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
	AudioServicesPlaySystemSound(soundID);
}
//加载远程数据
+ (NSData *)loadDataFromURL:(NSString *)URLString {
	NSURL *url = [NSURL URLWithString:URLString];
	return [NSData dataWithContentsOfURL:url];
}

//创建UILabel标签
+ (UILabel *)getLabel:(NSUInteger)fontSize bold:(BOOL) b color:(UIColor*)color{
	UILabel *label = [[[UILabel alloc] init] autorelease];
	label.backgroundColor = nil;
	if (b) {
		label.font = [UIFont boldSystemFontOfSize:fontSize];
	} else {
		label.font = [UIFont systemFontOfSize:fontSize];
	}
	
	label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
	label.opaque = NO;
	label.numberOfLines = 0;
	label.lineBreakMode = UILineBreakModeWordWrap;
	return label;
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
	NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	if ([cString length] < 6){
        return [UIColor blackColor];
    }
	if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
	if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
	if ([cString length] != 6) {
        return [UIColor blackColor];
    }
	
	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
	
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
}

#pragma mark -
#pragma mark NSUserDefaults
//保存键值对
+(void)saveToUserDefaults:(NSString*)key value:(id)value{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) {
		[standardUserDefaults setObject:value forKey:key];
		[standardUserDefaults synchronize];
	}
}
//根据key取出保存的数据
+(id)retrieveFromUserDefaults:(NSString*) key{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) {
        return [standardUserDefaults objectForKey:key];
    }
	return nil;
}

//清空用户数据
+(void)clearAllUserDefaults{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *keys = [[[defaults dictionaryRepresentation] allKeys] copy];
	for(NSString *key in keys) {
		[defaults removeObjectForKey:key];
	}
	[keys release];
}

//是否支持叠层
//+(BOOL) getEnabledIndexes{
//     return [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_indexes"];
//}
//是否显示营销按钮
//+(BOOL) getEnabledSalebar{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_salebar"];
//}
////是否支持现场取景
//+(BOOL) getEnabledPropicPhoto{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_propic_photo"];
//}
////是否支持背景缩放
//+(BOOL) getEnabledPropicZoom{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_propic_zoom"];
//}
///** 是否启用场景 */
//+(BOOL) getEnabledScene{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_scene"];
//}
///** 编辑效果 */
//+(BOOL) getEnabledEdit{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_edit"];
//}

//判断是否有效的邮箱地址
+(BOOL) isValidEmailAddress:(NSString *)email{
	NSArray *validateAtSymbol = [email componentsSeparatedByString:@"@"];
    NSArray *validateDotSymbol = [email componentsSeparatedByString:@"."];
    if(([validateAtSymbol count] != 2) || ([validateDotSymbol count] < 2)) {
		return NO;
    }
	return YES;
}

//获取时间信息
+(NSDateComponents *) myGetTimeInfo{
    NSDate* date = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps;
    // 年月日获得
    comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit) fromDate:date];
    return comps;
}
//格式化时间
+ (NSString *)formatTimer:(int)Hour Minutes:(int)Minutes Seconds:(int)Seconds{
    NSString *time=[[[NSString alloc] init] autorelease];
    if (Hour>0) {
        time = [time stringByAppendingFormat:@"%d小时",Hour];
    }
    if (Minutes>0) {
        time = [time stringByAppendingFormat:@"%d分钟",Minutes];
    }
    if (Seconds>0) {
        time = [time stringByAppendingFormat:@"%d秒",Seconds];
    }
    return time;
}

//获取字符串的长度
+ (int)stringLength:(NSString  *)str{
    int len=0;
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            len+=2;
        }else {
            len+=1;
        }
    }
    return len;
}

//拨打电话
+ (void)dailPhone:(NSString *) dailPhoneNumber view:(UIView *)view
{
	NSURL *phoneNumber = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel:%@",dailPhoneNumber]];
	if ( [[UIApplication sharedApplication] canOpenURL: phoneNumber] ){
        //get iOS version
        NSString *osVersion = [[UIDevice currentDevice] systemVersion];
        
        if ([osVersion floatValue] >= 3.1) {
            NSLog(@"iOS version is after 3.1, version = %@",osVersion);
            UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
            webview.alpha = 0.0;
            NSLog(@"phoneNumber = %@",phoneNumber);
            [webview loadRequest:[NSURLRequest requestWithURL:phoneNumber]];
            
            // Assume we are in a view controller and have access to self.view
            [view addSubview:webview];
            [webview release];
            
        }
        else {
            // On 3.0 and below, dial as usual
            NSLog(@"iOS version is below 3.1, version = %@",osVersion);
            [[UIApplication sharedApplication] openURL: phoneNumber];
        }
	}
    [phoneNumber release];
}


+ (NSMutableArray *)getDirFilenameList:(NSString *)Folder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:Folder];
    
    NSArray* filelist = [fileManager contentsOfDirectoryAtPath: filepath error: nil];
    
    NSMutableArray *ret = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<[filelist count]; i++) {
        NSString *filename = [filelist objectAtIndex:i];
        if (![filename isEqualToString:@"."] && ![filename isEqualToString:@".."]) {
            if([[filename substringFromIndex:[filename length]-4] isEqualToString:@".mp4"]){
                [ret addObject:filename];
            }
        }
    }
    return ret;
}

+ (NSDictionary *)getTypeByEname:(NSString *)ename{
    //Load 数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"NotificationTypes" ofType:@"plist"];
    NSDictionary *tmpDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *gameDic = [tmpDic objectForKey:@"types"];

    for (int i=0; i<[gameDic count]; i++) {
        NSDictionary *aType = [gameDic objectAtIndex:i];
        if ([[aType objectForKey:@"ename"] isEqualToString:ename]) {
            return aType;
        }
    }
    return nil;
}

+ (NSDictionary *)getTypeByID:(int)tpid{
    //Load 数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"NotificationTypes" ofType:@"plist"];
    NSDictionary *tmpDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *gameDic = [tmpDic objectForKey:@"types"];
   
    for (int i=0; i<[gameDic count]; i++) {
        NSDictionary *aType = [gameDic objectAtIndex:i];
        if ([[aType objectForKey:@"id"] intValue]==tpid){
            return aType;
        }
    }
    return nil;
}

//2个nsdate相差的天数
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

+ (NSString *)urlencode:(NSString *)fstr {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[fstr UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+ (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    [parts release];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

+ (void)updateSavedTimes{
    int oldcnt = [[self getPrefs:@"notisavedtimes"] intValue];
    NSString *mycnt = [NSString stringWithFormat:@"%d",oldcnt+1];
    [self setPrefs:@"notisavedtimes" value:mycnt];
}

+ (BOOL)willShowWriteComment{
    if ([self getPrefs:@"iswritecomment"]==nil || [[self getPrefs:@"iswritecomment"] isEqualToString:@""]) {
        int cnt = [[self getPrefs:@"notisavedtimes"] intValue];
        if(cnt>=10 && cnt%10==0){
            return YES;
        }
    }else{
        return NO;
    }
    return NO;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        //NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }else{
        //NSLog(@"Success excluding %@ from backup", [URL lastPathComponent]);
    }
    return success;
}
//将时间转化为字符串
+(NSString *)dateConvertToString:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    [formatter release];
    return dateString;
}


/** 农历转换函数 */
+(NSString *)LunarForSolar:(NSDate *)solarDate{
    //天干名称
    NSArray *cTianGan = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸", nil];
    
    //地支名称
    NSArray *cDiZhi = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
    
    //属相名称
    NSArray *cShuXiang = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
    
    //农历日期名
    NSArray *cDayName = [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                         @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                         @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName = [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static int wCurYear,wCurMonth,wCurDay;
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //取当前公历年、月、日
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |NSMonthCalendarUnit | NSYearCalendarUnit fromDate:solarDate];
    wCurYear = [components year];
    wCurMonth = [components month];
    wCurDay = [components day];
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    
    //生成农历天干、地支、属相
    NSString *szShuXiang = (NSString *)[cShuXiang objectAtIndex:((wCurYear - 4) % 60) % 12];
    NSString *szNongli = [NSString stringWithFormat:@"%@(%@%@)年",szShuXiang, (NSString *)[cTianGan objectAtIndex:((wCurYear - 4) % 60) % 10],(NSString *)[cDiZhi objectAtIndex:((wCurYear - 4) % 60) %12]];
    //生成农历月、日
    NSString *szNongliDay;
    if (wCurMonth < 1){
        szNongliDay = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }
    else{
        szNongliDay = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
    //NSString *lunarDate = [NSString stringWithFormat:@"%@ %@月 %@",szNongli,szNongliDay,(NSString*)[cDayName objectAtIndex:wCurDay]];
    NSString *lunarDate = [NSString stringWithFormat:@"%@月%@",szNongliDay,(NSString*)[cDayName objectAtIndex:wCurDay]];
    return lunarDate;
}
@end
