//
//  ViewController.m
//  Demo1
//
//  Created by andy on 11/23/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import "ViewController.h"
#import "QBaseOpenURLManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[QBaseOpenURLManager manager] openApp:@"QBaseAppTwo"];
}
@end
