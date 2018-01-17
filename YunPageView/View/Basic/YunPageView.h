//
//  YunPageView.h
//  YunPageView
//
//  Created by zhiyunyu on 2018/1/16.
//  Copyright © 2018年 zhiyunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YunPageView;

@protocol YunPageViewDataSource<NSObject>
@required
- (NSUInteger)numberOfRowsInPageView:(YunPageView *)pageView;
- (UIView *)pageView:(YunPageView *)pageView contentForPageAtIndex:(NSUInteger)index;
@end

@protocol YunPageViewDelegate<NSObject>
@required
- (void)pageView:(YunPageView *)pageView didSelectPageAtIndex:(NSUInteger)index;
@end

//_______________________________________________________________________________________________________________

@interface YunPageView : UIScrollView

@property(nonatomic, weak) id<YunPageViewDataSource> dataSource;
@property(nonatomic, weak) id<YunPageViewDelegate> pageViewdelegate;

@property(nonatomic, assign) CGSize contentPageSize;            // default is 0; 每一个page的size
@property(nonatomic, assign) UIEdgeInsets contentViewInsets;     // default is 0; pageview的内边距
@property(nonatomic, assign) CGFloat intervalOfPages;           // page间隔

- (void)registerClass:(Class)pageViewClass forContentViewReusedIdentifier:(NSString *)identifier;
- (UIView *)dequeueReusableContentViewWithIdentifier:(NSString *)identifier;
- (void)reloadData;

@end
