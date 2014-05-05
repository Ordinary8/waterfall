//
//  AppMacros.h
//  brandshow
//
//  Created by lance on 14-3-18.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#ifndef brandshow_AppMacros_h
#define brandshow_AppMacros_h

//单个面的参数 8代表纹理类型
#define kRotatefLength 9


//触摸事件通知key
#define kScreenTouch @"uptouch"
//开始计算屏保
#define START_CHECK_SLEEP @"start_check_sleep"
//永不显示屏保
#define STOP_CHECK_SLEEP @"stop_check_sleep"

//默认材质
#define DEFAULT_SCENE @"default_scene.png"
//默认材质
#define DEFAULT_TEX @"default_tex.jpg"
//默认场景参数
#define DEFAULT_ROTATEFS @"0,0,0,0,0,-1.5,13,13,1##0,-20,0,-4,0,-1.5,13,8,1##0,65,0,0,0,-1.5,13,13,1##0,-45,0,0,0,-0.8,7,10,1"

//用户数据文件 获取用户名key---简单数据存储
#define kUserName @"userName"
#define kPassword @"password"
//超时时间
#define kOuttime @"outtime"

//数组分隔符
#define JoinedSeparator @"##"
//沉睡时间
#define kSleepTime 300

#define LOGO_URL @"logo_url"

//全景图片缓存目录
#define PANORAMIC_CACHE_DIR @"panoramic"
//资源缓存目录
#define RESOURCE_CACHE_DIR @"resource"
//社区图片缓存目录
#define UNITY_CACHE_DIR @"unity"
//plist文件缓存目录
#define PLIST_CACHE_DIR @"plist"
//纹理图片缓存目录
#define TEXS_CACHE_DIR @"texs"

//行业,风格
#define KEYWORDINF @"KeywordInf"
//首页的缓存文件
#define FACEVIEW @"FaceView"
//服务/案例 缓存文件
#define BRANDINFO_SERVER @"BrandInfo_Server"
//品牌 缓存文件
#define BRANDINFO_BRAND @"BrandInfo_Brand"
//环境 缓存
#define BRANDINFO_ENVIR @"BrandInfo_Envir"
//用户数据缓存---今后不缓存用户
//#define USER_DATA_FILE @"UserInf"
//简单数据文件
#define PREFS_FILE @"Prefs"
//缓存产品文件名
#define PRODUCT_FILE @"ProductInfo"
//缓存菜单
#define MENUINFO_FILE @"MenuInfo"
#define SCROLLER_INTVAL 10

//域名---测试环境
#define DOMAIN_TEST @"http://o2o.sopin.cc"
//主机域名---上线环境
#define DOMAIN_HOST @"http://www.sopin.cc"
//web服务地址 --- 原始
#define PADSERVICE @"/TBPadView/"
//新的web服务地址 --- 最新
#define PHONESERVICE @"/TBPhoneView/"

//webservice 扩展名
#define EXTNAME @".ashx"
//检索邮箱地址正确性
#define EMAIL_REGEX @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
//判断是否Retina设备
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?CGSizeEqualToSize(CGSizeMake(768, 1024),[[UIScreen mainScreen] currentMode].size) : NO)

#define SIZE_3D_W 800
#define SIZE_3D_H 500

//服务端信息 远程桌面
//IP:117.135.131.221 配置：E5200  2G   160G 用户名：root 密码：sopin&*(789x63.014yf0213

#endif
