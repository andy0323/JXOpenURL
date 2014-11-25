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
              task:@"DemoTask"
             message:@"test"
              params:@{@"name":@"andy"}
            complete:^(BOOL canOpen) {
                
                
            }];

    [manager handleOpenURL:[NSURL URLWithString:@"HELLO://eyJRQkFTRV9PUEVOX1VSTF9LRVlfVEFTSyI6IkRlbW9UYXNrIiwiUUJBU0VfT1BFTl9VUkxfS0VZX1NDSEVNRVNfVVJMIjoiSEVMTE8iLCJRQkFTRV9PUEVOX1VSTF9LRVlfUEFSQU1TIjp7Im5hbWQiOiJhbmR5In0sIlFCQVNFX09QRU5fVVJMX0tFWV9NRVNTQUdFIjoidGVzdCJ9"] complete:^(BOOL hasSendMsg) {
        
    }];
    
}

@end
