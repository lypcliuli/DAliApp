//
//  AppDelegate.m
//  DAliApp
//
//  Created by LYPC on 2020/11/18.
//  Copyright © 2020 baidu.com. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>

#import "WXApi.h"
//#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor yellowColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    [self.window makeKeyAndVisible];

    [self confitUShareSettings];
    [self configUSharePlatforms];

    return YES;
}

- (void)confitUShareSettings {
    [UMConfigure setLogEnabled:YES];
        
    [UMConfigure initWithAppkey:@"552alkjshfu8300011" channel:@"App Store"];
    
    //配置微信平台的Universal Links 微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):@"https://yourdomain.com/",
        @(UMSocialPlatformType_QQ):@"https://yourdomain.com/"};
}

- (void)configUSharePlatforms
{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx8bafdfdff6374bf1" appSecret:@"533weryweiuyoqhbsba28ad3c98767" redirectURL:nil];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1225744047"/*设置QQ平台的appID*/  appSecret:@"LKJlkjlks9nPA" redirectURL:nil];
}

// 设置Universal Links系统回调
- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb])
    {
        NSURL *url = userActivity.webpageURL;
        BOOL result;
        if ([[url absoluteString] containsString:@"pay"]) { // 微信支付
            result = [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
        }else if ([url.host isEqualToString:@"safepay"]) { // 支付宝支付
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                [[ZFPaymanager sharedManager]aliPayEnd:resultDic];
//            }];
            result = YES;
        }else { // 分享和第三方登陆
            result = [[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil];
        }
        return result;
    }
    return YES;
}

@end
