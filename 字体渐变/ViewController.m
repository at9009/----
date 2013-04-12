//
//  ViewController.m
//  字体渐变
//
//  Created by niko on 12-11-15.
//  Copyright (c) 2012年 niko. All rights reserved.
//

#import "ViewController.h"
#import "LysLabel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    LysLabel *lylabel = [[LysLabel alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    [lylabel showText:@"1234567890" animationTime:1];
    [self.view addSubview:lylabel];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
