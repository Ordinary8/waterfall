//
//  UserInf.h
//  brandshow
//
//  Created by lance on 14-4-17.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BrandInf : NSObject

@property (nonatomic,assign) int uid;//就是品牌ID
//品牌相关信息
@property(nonatomic,retain) NSString *usname;
@property(nonatomic,retain) NSString *photo;
@property(nonatomic,retain) NSString *company;
@property(nonatomic,retain) NSString *addr;
@property(nonatomic,retain) NSString *phone;
//品牌设置信息
//品牌截止时间
@property (nonatomic,retain) NSString * stopdate;
@property (nonatomic,assign) int dspan;//使用时间
@property (nonatomic,assign) int paytype;//支付方式
//设置相关属性
@property (nonatomic,assign) int istrade;
@property (nonatomic,assign) int isshoot;
@property (nonatomic,assign) int isgrdsel;
@property (nonatomic,assign) int ispicture;
@property (nonatomic,assign) int isvideo;
@property (nonatomic,assign) int isgrdset;

//用户登录状态 0未登录 1会员登录 2店员登录 3为
@property (nonatomic,assign) int userStatus;

//客户端附加字段
@property (nonatomic,retain) NSString * msg;

//附加---是否进入了品牌
@property (nonatomic,assign) BOOL isBind;//

@end
