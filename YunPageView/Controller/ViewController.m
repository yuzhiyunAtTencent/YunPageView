//
//  ViewController.m
//  YunPageView
//
//  Created by zhiyunyu on 2018/1/16.
//  Copyright © 2018年 zhiyunyu. All rights reserved.
//

#import "ViewController.h"
#import "TestPageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    

    UIButton *enterMainButton = [[UIButton alloc] init];
    enterMainButton.frame = CGRectMake(24, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width - 48, 48);
    enterMainButton.layer.borderWidth = 1;
    enterMainButton.layer.cornerRadius = 24;
    enterMainButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [enterMainButton setTitle:@"开启非凡之旅" forState:UIControlStateNormal];
    [enterMainButton addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:enterMainButton];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

-(void)tap:(id)sender{
    TestPageViewController *nextPage= [[TestPageViewController alloc]init];
    nextPage.hidesBottomBarWhenPushed=YES;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:nextPage animated:YES];
}

@end
