//
//  AppDelegate.m
//  waterfall
//
//  Created by lance on 14-05-05.
//  Copyright (c) 2013年 harry.xie. All rights reserved.
//

#import "AppDelegate.h"

#import "MallAct.h"
#import "FileHandle.h"
#import "BrandInf+Util.h"

//最近因为公司要使用瀑布流的效果,老板一定要这个效果,在强大的压力下解决的,希望能帮助更多地开发者
//能为开源社区贡献自己的一份努力是我的荣幸
// 我英文名:lance 电子邮箱:1094226429@qq.com 希望有机会交流

//demo可以使用SD加载(未测试,但是要用reloadData,重载单个会因为下载的图片快慢导致错位,这里用得是循序下载(单行重载)不会出错)
//要下拉刷新可以自己用EGO很简单,可以自己去学用法

@implementation AppDelegate

@synthesize userInf;
@synthesize sleepSecond;
@synthesize productCart;
@synthesize screenSaverTimer;
@synthesize logoimgpath;
@synthesize netActive;
@synthesize customCache;
@synthesize colorname;
@synthesize relatename;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    productCart=[[NSMutableArray alloc] initWithCapacity:1];
    //处理启动通知更新
    UILocalNotification *localNotif =[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        application.applicationIconBadgeNumber=0;
		NSLog(@"Recieved Notification %@",localNotif);
	}
    userInf=[[BrandInf alloc] init];
    userInf.uid=[Prefs getDefaultId];
    MallAct * loginVC=[[MallAct alloc] init];
    self.naviController=[[UINavigationController alloc] initWithRootViewController:loginVC];
    self.naviController.navigationBarHidden = YES;
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    self.customCache = cache;
    [self.customCache setStoragePath:[FileHandle getResourceCacheDirectory]];
    //有网络就访问网络---默认资源加载策略
    [self.customCache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    
    self.window.rootViewController = self.naviController;
    [self.window makeKeyAndVisible];
    return YES;
}

//点击通知后的处理
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {
	// Handle the notificaton when the app is running
	NSLog(@"Recieved Notification %@",notif);
    application.applicationIconBadgeNumber=0;
}

//注册远程消息推送并指定推送类型
-(void) registerRemoteNotify
{
    //消息推送支持的类型---三种消息类型
    UIRemoteNotificationType types =(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound
                                     |UIRemoteNotificationTypeAlert);
    //注册消息推送
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:types];
}

//获取DeviceToken成功
- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"DeviceToken: {%@}",deviceToken);
    //这里进行的操作，是将Device Token发送到服务端
}

//注册消息推送失败
- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Register Remote Notifications error:{%@}",[error localizedDescription]);
}

//处理收到的消息推送
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Receive remote notification : %@",userInfo);
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"温馨提示"
                               message:@"推送成功！"
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application{
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
}
- (void)applicationWillEnterForeground:(UIApplication *)application{
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
}
- (void)applicationWillTerminate:(UIApplication *)application{
}

@end
