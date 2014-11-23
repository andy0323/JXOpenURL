//
//  QBaseOpenURLTask.m
//  QBaseOpenURLManager
//
//  Created by andy on 11/22/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import "QBaseOpenURLTask.h"
#import "QBaseOpenURLManager.h"

@implementation QBaseOpenURLTask

/**
 *  跳转返回
 */
- (BOOL)callback
{
    return [[QBaseOpenURLManager manager] openApp:_backOpenURL];
}

/**
 *  跳转返回
 */
- (void)callbackWithTask:(NSString *)task message:(NSString *)message params:(NSDictionary *)params complete:(void (^)(BOOL))completeBlock
{
    [[QBaseOpenURLManager manager] openApp:_backOpenURL
                                      task:task
                                   message:message
                                    params:params
                                  complete:completeBlock];
}

@end
