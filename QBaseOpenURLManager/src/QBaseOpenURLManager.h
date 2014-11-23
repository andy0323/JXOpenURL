//
//  QBaseOpenURLManager.h
//  QBaseOpenURLManager
//
//  Created by andy on 11/22/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import "UIKit/UIKit.h"
#import <Foundation/Foundation.h>

@class QBaseOpenURLTask;
@interface QBaseOpenURLManager : NSObject
{

}
/**
 *  单例
 */
+ (instancetype)manager;

/**
 *  客户端自身SchemesURL
 */
@property (nonatomic, readonly) NSString *schemesURL;


/**
 *  能否打开客户端
 *
 *  @param schemesURL 客户端 SchemesURL
 *
 *  @return YES：能够打开  NO：不能打开
 */
- (BOOL)canOpen:(NSString *)schemesURL;

/**
 *  打开客户端
 *
 *  @param schemesURL 客户端 SchemesURL
 *
 *  @return YES：已经成功打开  NO：未能成功打开
 */
- (BOOL)openApp:(NSString *)schemesURL;

/**
 *  打开客户端, 调用函数, 传出参数
 *
 *  @param schemesURL    客户端 SchemesURL
 *  @param task          客户端 调用函数对象名
 *  @param message       客户端 调用函数的函数名
 *  @param params        客户端 调用函数的参数
 *  @param completeBlock 完成调用, 回调是否成功打开
 */
- (void)openApp:(NSString *)schemesURL
           task:(NSString *)task
        message:(NSString *)message
         params:(NSDictionary *)params
       complete:(void (^)(BOOL canOpen))completeBlock;


/**
 *  处理OpenURL
 */
- (void)handleOpenURL:(NSURL *)openURL
             complete:(void (^)(BOOL hasSendMsg))completeBlock;


@end
