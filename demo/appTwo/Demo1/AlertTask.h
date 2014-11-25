//
//  AlertTask.h
//  Demo1
//
//  Created by andy on 11/23/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import "QBaseOpenURLTask.h"
#import <UIKit/UIKit.h>
@interface AlertTask : QBaseOpenURLTask<UIAlertViewDelegate>
- (void)alert:(NSDictionary *)params;
@end
