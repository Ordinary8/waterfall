//
//  NSString+ArrayUtil.m
//  wallintermobile
//
//  Created by lance on 13-11-26.
//  Copyright (c) 2013年 ganchengkai. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ArrayUtil)

- (void) convertToArray:(float*)rotatef
{
    NSArray * arr=[self componentsSeparatedByString:@","];
    for (int i=0; i<arr.count; i++) {
        rotatef[i]=[[arr objectAtIndex:i] floatValue];
    }
}

/** 将场景对应的参数解析成一个包含多个字符的数组中 每个字符串的最后一位代表纹理类型 */
-(NSMutableArray *) convertToNSArray
{
    NSArray * arr=[self componentsSeparatedByString:JoinedSeparator];
    NSMutableArray * temp=[[NSMutableArray alloc] initWithCapacity:3];
    for (int i=0; i<arr.count; i++) {
        [temp addObject:[arr objectAtIndex:i]];
    }
    return temp;
}
//将数组转化回参数
+(NSString *) arrConvertToString:(NSMutableArray *) rotatefs
{
    NSMutableString * mutableString=[[NSMutableString alloc] init];
    for (int i=0; i<rotatefs.count; i++) {
        NSString *rotatef=[rotatefs objectAtIndex:i];
        if(i==rotatefs.count-1){
            [mutableString appendFormat:@"%@",rotatef];
        }else{
            [mutableString appendFormat:@"%@%@",rotatef,JoinedSeparator];
        }
    }
    return mutableString;
}

//将float数组转化为字符串
+ (NSString *) convertToString:(float*)rotatef
{
    NSMutableString * mutableString=[[NSMutableString alloc] init];
    for (int i=0; i<kRotatefLength; i++) {
        if(i==kRotatefLength-1){
            [mutableString appendString:[NSString stringWithFormat:@"%f",rotatef[i]]];
        }else{
            [mutableString appendString:[NSString stringWithFormat:@"%f,",rotatef[i]]];
        }
    }
    return mutableString;
}

+ (BOOL) isNull:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//将字符串进行MD5加密
-(NSString *) md5HexDigest{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}


@end
