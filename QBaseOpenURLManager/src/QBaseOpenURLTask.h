//
//  QBaseOpenURLTask.h
//  QBaseOpenURLManager
//
//  Created by andy on 11/22/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBaseOpenURLTask : NSObject
/**
 *  跳转返回OpenURL
 */
@property (nonatomic, copy) NSString *backOpenURL;

/**
 *  跳转返回
 */
- (BOOL)callback;

/**
 *  跳转返回
 *
 *  @param task          返回, 回调任务对象
 *  @param message       返回, 回调任务函数
 *  @param params        返回, 回调任务参数
 *  @param completeBlock 是否成功返回
 */
- (void)callbackWithTask:(NSString *)task
                 message:(NSString *)message
                  params:(NSDictionary *)params
                complete:(void (^)(BOOL hasCallback))completeBlock;
@end
