//
//  YunPageView.m
//  YunPageView
//
//  Created by zhiyunyu on 2018/1/16.
//  Copyright © 2018年 zhiyunyu. All rights reserved.
//

#import "YunPageView.h"
#import "YunObjectRecycler.h"

typedef NSMutableDictionary<NSString *, NSString *> QNPageViewRegisteredClassDictionary;

@interface YunPageView ()
@property(nonatomic, strong) QNPageViewRegisteredClassDictionary *registeredClassDictionary;
@property(nonatomic, strong) NSMutableDictionary *visiblePages;
@property(nonatomic, assign) NSUInteger pageNumber;
@property(nonatomic, strong) YunObjectRecycler *recycler;
@property(nonatomic, strong) UITapGestureRecognizer *singleTapGesture;
@end

@implementation YunPageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.registeredClassDictionary = [NSMutableDictionary dictionary];
        self.contentPageSize = CGSizeZero;
        self.contentViewInsets = UIEdgeInsetsMake(0.f, 2.f, 0.f, 2.f);
        self.visiblePages = [NSMutableDictionary dictionary];
        self.recycler = [[YunObjectRecycler alloc] initWithMaxCacheSize:5];
        self.pageNumber = 0;
        self.intervalOfPages = 10;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    NSLog(@"layoutSubviews**********");

    [self p_layoutPages];
    [self p_caculateAndSetContentSize];
}

- (void)registerClass:(Class)pageViewClass forContentViewReusedIdentifier:(NSString *)identifier {
    if (!CHECK_VALID_STRING(identifier)) {
//        NSLog(@"Error!!!  RegisterClass invalid identifier");
        return;
    }

    if (pageViewClass != nil) {
        [self.registeredClassDictionary setObject:NSStringFromClass(pageViewClass) forKey:identifier];
    }
}

- (UIView *)dequeueReusableContentViewWithIdentifier:(NSString *)identifier {
    if (!CHECK_VALID_STRING(identifier)) {
        NSLog(@"Error!!!  DequeueReusableContentView invalid identifier");
        return nil;
    }
    
    UIView *view = (UIView *)[self.recycler dequeueRecycledObjectForIdentifier:identifier];
    if (view) {
        return view;
    }
    
    Class viewClass = NSClassFromString(identifier);
    if (!viewClass) {
        return nil;
    }
    view = [[viewClass alloc] initWithFrame:(CGRect){0, 0, self.contentPageSize}];

    return view;
}

- (void)reloadData {
    [self p_layoutPages];
    [self p_caculateAndSetContentSize];
}

- (NSUInteger)currentPageNumber {
    if (self.pageNumber == 0)
        return NSNotFound;
    
    CGFloat contentOffsetX = self.contentOffset.x;
    CGFloat width = self.contentPageSize.width + self.intervalOfPages;
    
    if (self.contentSize.width - self.frame.size.width == self.contentOffset.x) {
        return self.pageNumber - 1;  // last page
    }
    
    return (int)(contentOffsetX / width);
}

- (BOOL)isScrolling {
    return self.tracking || self.dragging || self.decelerating;
}

#pragma mark - Private Methods
- (void)p_layoutPages {
    if ([self.dataSource respondsToSelector:@selector(numberOfRowsInPageView:)]) {
        self.pageNumber = [self.dataSource numberOfRowsInPageView:self];
    }
    if (self.pageNumber <= 0) {
        return;
    }
    const NSRange pageRange = [self p_rangeOfPageToLoad];
    [self p_addContentPageViewWithPageRange:pageRange];
    //停止滑动的时候开始回收未显示的page对象，存储起来以便之后复用；
    if (![self isScrolling]) {
        [self p_recycleViewsOutOfRange:pageRange];
    }
}

/**
 *  回收不可见的page
 */
- (void)p_recycleViewsOutOfIndexes:(NSIndexSet *)indexes {
    NSArray *allKeys = [self.visiblePages allKeys];
    for (NSNumber *key in allKeys) {
        if (![indexes containsIndex:[key integerValue]]) {
            UIView<YunReusableObject> *contentView = self.visiblePages[key];
            [contentView removeFromSuperview];
            [self.recycler enqueueRecycledObject:contentView];
            [self.visiblePages removeObjectForKey:key];
        }
    }
}

- (void)p_recycleViewsOutOfRange:(NSRange)range {
    [self p_recycleViewsOutOfIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
}

/**
 *  获取可见pages的索引
 *
 *  但是，实际上这里加大了范围，可以看到最多的时候，范围包含了两倍 preLoad 数量的page，这样可以提高性能
 */
- (NSRange)p_rangeOfPageToLoad {
    NSUInteger preLoad = self.preLoadNumber;
    NSUInteger currentPageNO = [self currentPageNumber];
    NSLog(@"currentPageNO %@", @(currentPageNO));
    
    NSInteger start = currentPageNO - preLoad;
    start = MAX(0, start);
    //  +1 是考虑第一个item部分被遮挡时，最右边的可见item却还不显示的情况
    NSInteger end = currentPageNO + preLoad + 1;
    
    NSUInteger count = end - start + 1;
    count = MIN(self.pageNumber - start, count);
    return NSMakeRange(start, count);
}

/**
 *  添加需要的子view
 */
- (void)p_addContentPageViewWithPageRange:(NSRange)pageRange {
    NSUInteger index;
    NSLog(@"范围%@ ---- %@", @(pageRange.location), @(pageRange.length));
    for (int i = 0; i < pageRange.length; i++) {
        index = i + pageRange.location;
        UIView *view = self.visiblePages[@(index)];
        if (!view) {
            if ([self.dataSource respondsToSelector:@selector(pageView:contentForPageAtIndex:)]) {
                UIView *view = [self.dataSource pageView:self contentForPageAtIndex:index];
                // 添加每个page到scrollView中
                [self addSubview:view];
                
                self.visiblePages[@(index)] = view;
                
                CGRect viewFrame = CGRectMake(self.contentViewInsets.left + index * (self.contentPageSize.width + self.intervalOfPages), floorf((self.bounds.size.height - self.contentPageSize.height) / 2) , self.contentPageSize.width, self.contentPageSize.height);
                view.frame = viewFrame;
            }
        }
    }
}

/**
 *  计算scrollView的ContentSize
 *  如果不计算正确，可能导致有的内容显示不出来，或者内容显示完了却有多余的空缺
 */
- (void)p_caculateAndSetContentSize {
    if (self.pageNumber <= 0) {
        return;
    }
    CGFloat width = (self.contentPageSize.width + self.intervalOfPages) * self.pageNumber - self.intervalOfPages + self.contentViewInsets.left + self.contentViewInsets.right;
    self.contentSize = CGSizeMake(width, self.contentPageSize.height);
}

#pragma mark - Setter & Getter
- (void)setPageViewdelegate:(id<YunPageViewDelegate>)pageViewdelegate {
    if (pageViewdelegate) {
        if ([pageViewdelegate respondsToSelector:@selector(pageView:didSelectedPage:atIndex:)]) {
            [self removeGestureRecognizer:self.singleTapGesture];
            [self addGestureRecognizer:self.singleTapGesture];
        }
    } else {
        [self removeGestureRecognizer:self.singleTapGesture];
    }
    
    _pageViewdelegate = pageViewdelegate;
}

#pragma mark -Touch  Event
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture {
    
    UIView *selectedView = nil;
    for (UIView *subView in self.subviews) {
        if (CGRectContainsPoint(subView.frame, [gesture locationInView:self])) {
            selectedView = subView;
            break;
        }
    }
    if (selectedView) {
        NSUInteger index = ([gesture locationInView:self].x - self.contentViewInsets.left) / (self.contentPageSize.width + self.intervalOfPages);
        index = MIN(index, self.pageNumber -1);
        [self.pageViewdelegate pageView:self didSelectedPage:selectedView atIndex:index];
    }
}

- (UITapGestureRecognizer *)singleTapGesture {
    if (!_singleTapGesture) {
        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    }
    return _singleTapGesture;
}

@end
