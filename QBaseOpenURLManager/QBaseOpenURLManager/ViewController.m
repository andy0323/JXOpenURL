//
//  ViewController.m
//  QBaseOpenURLManager
//
//  Created by andy on 11/22/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import "ViewController.h"
#import "QBaseOpenURLManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    QBaseOpenURLManager *manager = [[QBaseOpenURLManager alloc] init];
    
    
    [manager openApp:@"HELLO"
              target:@"TTT"
             message:@"test"
              params:@{@"namd":@"andy"}
            complete:^(BOOL canOpen) {
                
                
            }];

    [manager handleOpenURL:[NSURL URLWithString:@"HELLO://eyJRQkFTRV9LRVlfU0NIRU1FU19VUkwiOiJIRUxMTyIsIlFCQVNFX0tFWV9QQVJBTVMiOnsibmFtZCI6ImFuZHkifSwiUUJBU0VfS0VZX01TU0FHRSI6InRlc3QiLCJRQkFTRV9LRVlfVEFSR0VUIjoiVFRUIn0="] complete:^(BOOL hasSendMsg) {
        
    }];
    
}

@end
