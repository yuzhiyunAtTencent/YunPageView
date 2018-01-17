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
    ArticleListPage *page = [pageView dequeueReusableContentViewWithIdentifier:NSStringFromClass([ArticleListPage class])];

    [page layoutWithData:[self.articleListItems objectAtIndex:index]];
    
    [page setNeedsLayout];
    [page layoutIfNeeded];
    
    return page;
}

#pragma mark - YunPageViewDelegate
- (void)pageView:(YunPageView *)pageView didSelectPageAtIndex:(NSUInteger)index {
    NSLog(@"selected index = %@", @(index));
}

#pragma mark - Accessor
- (YunPageView *)yunPageView {
    if (!_yunPageView) {
        _yunPageView = [[YunPageView alloc] initWithFrame: (CGRect){10, 100, [[UIScreen mainScreen] bounds].size.width - 20, [ArticleListPage size].height}];
        _yunPageView.dataSource = self;
        _yunPageView.pageViewdelegate = self;
        _yunPageView.scrollEnabled = YES;
        _yunPageView.showsHorizontalScrollIndicator = NO;
        [_yunPageView registerClass:[ArticleListPage class] forContentViewReusedIdentifier:NSStringFromClass([ArticleListPage class])];
        _yunPageView.contentPageSize = [ArticleListPage size];
    }
    return _yunPageView;
}

- (NSMutableArray *)articleListItems {
    if (!_articleListItems) {
        _articleListItems = [NSMutableArray array];
    }
    return _articleListItems;
}
@end