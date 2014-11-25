//
//  AppDelegate.m
//  Demo1
//
//  Created by andy on 11/23/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import "AppDelegate.h"
#import "QBaseOpenURLManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[QBaseOpenURLManager manager] handleOpenURL:url
                                        complete:^(BOOL hasSendMsg) {
        
                                        }];
    
    return YES;
}

@end
