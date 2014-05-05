//
//  UserInf.h
//  brandshow
//
//  Created by lance on 14-4-17.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInf : NSObject

@property (nonatomic,assign) int uid;
@property (nonatomic,retain) NSString* usname;
@property (nonatomic,retain) NSString* stopdate;
@property (nonatomic,assign) int dspan;
@property (nonatomic,assign) int istrade;
@property (nonatomic,assign) int isshoot;
@property (nonatomic,assign) int isgrdsel;
@property (nonatomic,assign) int ispicture;
@property (nonatomic,assign) int isvideo;
@property (nonatomic,assign) int isgrdset;
@property (nonatomic,retain) NSString * msg;

@end
