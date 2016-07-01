//
//  ViewController.m
//  小球拖拽拉伸
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import "ViewController.h"
#import "LY_CircleButton.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    LY_CircleButton *button = [LY_CircleButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.center = self.view.center;
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"100" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.clickName = ^(UIButton *btn){
        NSLog(@"点击 -> 销毁了");
    };
}
@end
