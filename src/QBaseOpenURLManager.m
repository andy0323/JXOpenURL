//
//  QBaseOpenURLManager.m
//  QBaseOpenURLManager
//
//  Created by andy on 11/22/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import "QBaseOpenURLManager.h"
#import "QBaseOpenURLTask.h"
#import <objc/message.h>

#define QBASE_OPEN_URL_KEY_SCHEMES_URL @"QBASE_OPEN_URL_KEY_SCHEMES_URL"
#define QBASE_OPEN_URL_KEY_TASK        @"QBASE_OPEN_URL_KEY_TASK"
#define QBASE_OPEN_URL_KEY_MESSAGE     @"QBASE_OPEN_URL_KEY_MESSAGE"
#define QBASE_OPEN_URL_KEY_PARAMS      @"QBASE_OPEN_URL_KEY_PARAMS"

@interface QBaseOpenURLManager ()
{
    NSMutableDictionary *_taskStorage;
}
@property (nonatomic, readonly) NSMutableDictionary *taskStorage;
@end

@implementation QBaseOpenURLManager
+ (instancetype)manager
{
    static QBaseOpenURLManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _taskStorage = [NSMutableDictionary new];
    }
    
    return self;
}

/**
 *  能否打开客户端
 */
- (BOOL)canOpen:(NSString *)schemesURL
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:rightSchemesURL(schemesURL)]];
}

/**
 *  打开客户端
 */
- (BOOL)openApp:(NSString *)schemesURL
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rightSchemesURL(schemesURL)]];
}

/**
 *  打开客户端, 调用函数, 传出参数
 */
- (void)openApp:(NSString *)schemesURL task:(NSString *)task message:(NSString *)message params:(NSDictionary *)params complete:(void (^)(BOOL))completeBlock
{
    // 判断是否可以打开客户端
    BOOL canOpen = [self canOpen:schemesURL];
    
    // 如果打不开, 进行回调
    if (!canOpen) {
        if (completeBlock) {
            completeBlock(NO);
        }
        return;
    }
    
    NSString *mySchemesURL = [self schemesURL];
    // 如果可以打开, 开始转换参数
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    
    save_setObj_forKey(userInfo, mySchemesURL, QBASE_OPEN_URL_KEY_SCHEMES_URL);
    save_setObj_forKey(userInfo, task,         QBASE_OPEN_URL_KEY_TASK);
    save_setObj_forKey(userInfo, message,      QBASE_OPEN_URL_KEY_MESSAGE);
    save_setObj_forKey(userInfo, params,       QBASE_OPEN_URL_KEY_PARAMS);
    
    // UserInfo 转化为Base64
    NSData *data = [NSJSONSerialization dataWithJSONObject:userInfo
                                                   options:kNilOptions
                                                     error:nil];
    
    NSString *base64Str = base64(data);

    NSMutableString *openURL = [NSMutableString stringWithString:schemesURL];
    [openURL appendString:@"://"];
    [openURL appendString:base64Str];

    [self openApp:openURL];
}

/**
 *  处理OpenURL
 */
- (void)handleOpenURL:(NSURL *)openURL complete:(void (^)(BOOL))completeBlock
{
    NSString *openURLStr = openURL.absoluteString;
    
    NSString *base64Str = [openURLStr componentsSeparatedByString:@"://"][1];
    
    NSData *data = decodeBase64(base64Str);
    
    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
    
    NSString *schemesURL =
                        [userInfo objectForKey:QBASE_OPEN_URL_KEY_SCHEMES_URL];
    NSString *task    = [userInfo objectForKey:QBASE_OPEN_URL_KEY_TASK];
    NSString *message = [userInfo objectForKey:QBASE_OPEN_URL_KEY_MESSAGE];
    NSDictionary *params  =
                        [userInfo objectForKey:QBASE_OPEN_URL_KEY_PARAMS];

    QBaseOpenURLTask *taskTarget = [self.taskStorage objectForKey:task];
    if (!taskTarget) {
        Class TaskClass = NSClassFromString(task);
        if (!task) {
            NSLog(@"传参任务名称非法, 无法调用");
            return;
        }
        taskTarget = [[TaskClass alloc] init];
        [self.taskStorage setObject:taskTarget forKey:task];
    }
    
    taskTarget.backOpenURL = schemesURL;
    
    message = [message stringByAppendingString:@":"];
    SEL messageSelector = NSSelectorFromString(message);
    if ([taskTarget respondsToSelector:messageSelector]) {
        ((void (*)(id,SEL,id))objc_msgSend)(taskTarget,
                                            messageSelector,
                                            params);
    }
}

#pragma mark 
#pragma mark Simple Base64

NSString* base64(NSData *data)
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        return [data base64Encoding];
    }
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
}

NSData * decodeBase64(NSString *base64Str)
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        return [[NSData alloc] initWithBase64Encoding:base64Str];
    }
    return [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

#pragma mark -
#pragma mark Getting

- (NSString *)schemesURL
{
    NSString *schemesURL = @"";
    
    NSDictionary *plistInfo = [[NSBundle mainBundle] infoDictionary];
    NSArray *CFBundleURLTypes = [plistInfo objectForKey:@"CFBundleURLTypes"];
    
    if (CFBundleURLTypes.count > 0) {
        NSDictionary *CFBundleURLType = CFBundleURLTypes[0];
        schemesURL = [CFBundleURLType objectForKey:@"CFBundleURLSchemes"][0];
    }
    
    return schemesURL;
}

- (NSMutableDictionary *)targetStorage
{
    if (!_taskStorage) {
        _taskStorage = [NSMutableDictionary new];
    }
    return _taskStorage;
}

#pragma mark -
#pragma mark 特殊处理SchemesURL

/**
 *  处理SchemesURL异常
 */
NSString* rightSchemesURL(NSString *schemesURL)
{
    NSString *regex = [NSString stringWithFormat:@"^.*://.*$"];
    NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![predicate evaluateWithObject:schemesURL]) {
        return [schemesURL stringByAppendingString:@"://"];
    }
    
    return schemesURL;
}

#pragma mark
#pragma mark 字典扩展

void save_setObj_forKey(NSMutableDictionary *dic, id obj, id<NSCopying>key){
    if ([dic isKindOfClass:[NSMutableDictionary class]] && obj) {
        [dic setObject:obj forKey:key];
    }
}

@end