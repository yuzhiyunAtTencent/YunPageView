//
//  TestPageViewController.m
//  YunPageView
//
//  Created by zhiyunyu on 2018/1/16.
//  Copyright © 2018年 zhiyunyu. All rights reserved.
//

#import "TestPageViewController.h"
#import "YunPageView.h"
#import "ArticleListPage.h"

@interface TestPageViewController ()<YunPageViewDelegate, YunPageViewDataSource>

@property(nonatomic, strong) YunPageView *yunPageView;
@property (nonatomic, strong) NSMutableArray *articleListItems;

@end

@implementation TestPageViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self.view addSubview:self.yunPageView];
    
    [self.articleListItems addObject:@"青青子衿"];
    [self.articleListItems addObject:@"悠悠我心"];
    [self.articleListItems addObject:@"但为君故"];
    [self.articleListItems addObject:@"沉吟至今"];
    [self.articleListItems addObject:@"呦呦鹿鸣"];
    [self.articleListItems addObject:@"食野之萍"];
    [self.articleListItems addObject:@"幸甚至哉"];
    [self.articleListItems addObject:@"歌以咏志"];
    
    [self.yunPageView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YunPageViewDataSource
- (NSUInteger)numberOfRowsInPageView:(YunPageView *)pageView {
    return self.articleListItems.count;
}

- (UIView *)pageView:(YunPageView *)pageView contentForPageAtIndex:(NSUInteger)index {
    ArticleListPage *page = (ArticleListPage *)[pageView dequeueReusableContentViewWithIdentifier:NSStringFromClass([ArticleListPage class])];

    [page layoutWithData:[self.articleListItems objectAtIndex:index]];
    
    [page setNeedsLayout];
    [page layoutIfNeeded];
    
    return page;
}

#pragma mark - YunPageViewDelegate
- (void)pageView:(YunPageView *)pageView didSelectedPage:(UIView *)page atIndex:(NSUInteger)index {
    [self showAlertMessage:[self.articleListItems objectAtIndex:index]];
}

#pragma mark - Accessor
- (YunPageView *)yunPageView {
    if (!_yunPageView) {
        _yunPageView = [[YunPageView alloc] initWithFrame: (CGRect){0, 100, [[UIScreen mainScreen] bounds].size.width, [ArticleListPage size].height}];
        _yunPageView.dataSource = self;
        _yunPageView.pageViewdelegate = self;
        _yunPageView.scrollEnabled = YES;
        _yunPageView.showsHorizontalScrollIndicator = NO;
        [_yunPageView registerClass:[ArticleListPage class] forContentViewReusedIdentifier:NSStringFromClass([ArticleListPage class])];
        _yunPageView.contentPageSize = [ArticleListPage size];
        _yunPageView.preLoadNumber = 3;
    }
    return _yunPageView;
}

- (NSMutableArray *)articleListItems {
    if (!_articleListItems) {
        _articleListItems = [NSMutableArray array];
    }
    return _articleListItems;
}

- (void)showAlertMessage:(NSString *) myMessage{
    UIAlertController *alertMessage;
    alertMessage = [UIAlertController alertControllerWithTitle:@"提示" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertMessage addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertMessage animated:YES completion:nil];
}

@end
