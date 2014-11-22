//
//  QBaseOpenURLManager.m
//  QBaseOpenURLManager
//
//  Created by andy on 11/22/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import "QBaseOpenURLManager.h"

#define QBASE_KEY_SCHEMES_URL @"QBASE_KEY_SCHEMES_URL"
#define QBASE_KEY_TARGET      @"QBASE_KEY_TARGET"
#define QBASE_KEY_MESSAGE     @"QBASE_KEY_MSSAGE"
#define QBASE_KEY_PARAMS      @"QBASE_KEY_PARAMS"

@interface QBaseOpenURLManager ()
{
    NSMutableDictionary *_targetStorage;
}
@property (nonatomic, readonly) NSMutableDictionary *targetStorage;
@end

@implementation QBaseOpenURLManager

/**
 *  能否打开客户端
 */
- (BOOL)canOpen:(NSString *)schemesURL
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:schemesURL]];
}

/**
 *  打开客户端
 */
- (BOOL)openApp:(NSString *)schemesURL
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:schemesURL]];
}

/**
 *  打开客户端, 调用函数, 传出参数
 */
- (void)openApp:(NSString *)schemesURL target:(id)target message:(NSString *)message params:(NSDictionary *)params complete:(void (^)(BOOL))completeBlock
{
//    // 判断是否可以打开客户端
//    BOOL canOpen = [self canOpen:schemesURL];
//    
//    // 如果打不开, 进行回调
//    if (!canOpen) {
//        completeBlock(NO);
//        return;
//    }
    
    // 如果可以打开, 开始转换参数
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    
    [userInfo setObject:schemesURL forKey:QBASE_KEY_SCHEMES_URL];
    [userInfo setObject:target     forKey:QBASE_KEY_TARGET];
    [userInfo setObject:message    forKey:QBASE_KEY_MESSAGE];
    [userInfo setObject:params     forKey:QBASE_KEY_PARAMS];
    
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
    
    NSString *schemesURL = [userInfo objectForKey:@"QBASE_KEY_SCHEMES_URL"];
    NSString *target  = [userInfo objectForKey:@"QBASE_KEY_TARGET"];
    NSString *message = [userInfo objectForKey:@"QBASE_KEY_MSSAGE"];
    NSString *params  = [userInfo objectForKey:@"QBASE_KEY_PARAMS"];

    
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
        schemesURL = [CFBundleURLType objectForKey:@"CFBundleURLSchemes"];
    }
    
    return schemesURL;
}

- (NSMutableDictionary *)targetStorage
{
    if (!_targetStorage) {
        _targetStorage = [NSMutableDictionary new];
    }
    return _targetStorage;
}

@end
