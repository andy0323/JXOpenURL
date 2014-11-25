//
//  AlertTask.m
//  Demo1
//
//  Created by andy on 11/23/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import "AlertTask.h"

@implementation AlertTask

- (void)alert:(NSDictionary *)params
{
    [self performSelector:@selector(callback) withObject:nil afterDelay:1.0];
}
@end
