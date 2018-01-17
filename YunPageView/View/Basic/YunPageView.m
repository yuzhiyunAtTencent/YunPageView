//
//  YunPageView.m
//  YunPageView
//
//  Created by zhiyunyu on 2018/1/16.
//  Copyright © 2018年 zhiyunyu. All rights reserved.
//

#import "YunPageView.h"

typedef NSMutableDictionary<NSString *, NSString *> QNPageViewRegisteredClassDictionary;

@interface YunPageView ()
@property(nonatomic, strong) QNPageViewRegisteredClassDictionary *registeredClassDictionary;
@property(nonatomic, assign) NSUInteger pageNum;
@end

@implementation YunPageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.registeredClassDictionary = [NSMutableDictionary dictionary];
        self.contentPageSize = CGSizeZero;
        self.contentViewInsets = UIEdgeInsetsMake(0.f, 2.f, 0.f, 2.f);
        self.pageNum = 0;
        self.intervalOfPages = 10;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self p_layoutPages];
    [self p_caculateAndSetContentSize];
}

- (void)registerClass:(Class)pageViewClass forContentViewReusedIdentifier:(NSString *)identifier {
    if (!(identifier && [identifier length])) {
        NSLog(@"Error!!!  RegisterClass invalid identifier");
        return;
    }

    if (pageViewClass != nil) {
        [self.registeredClassDictionary setObject:NSStringFromClass(pageViewClass) forKey:identifier];
    }
}

- (UIView *)dequeueReusableContentViewWithIdentifier:(NSString *)identifier {
#warning zhiyunyu 先不做page 复用的逻辑，先把代码跑通，再慢慢完善复用逻辑
    UIView *view;
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

#pragma mark - Private Methods
- (void)p_layoutPages {
    if ([self.dataSource respondsToSelector:@selector(numberOfRowsInPageView:)]) {
        self.pageNum = [self.dataSource numberOfRowsInPageView:self];
    }

    [self p_addContentPageViewWithPageRange:NSMakeRange(0, MAX(0, self.pageNum))];
}
/**
 *  添加需要的子view
 */
- (void)p_addContentPageViewWithPageRange:(NSRange)pageRange {
    NSUInteger index;
    for (int i = 0; i < pageRange.length; i++) {
        index = i + pageRange.location;
        if ([self.dataSource respondsToSelector:@selector(pageView:contentForPageAtIndex:)]) {
            UIView *view = [self.dataSource pageView:self contentForPageAtIndex:index];
            // 添加每个page到scrollView中
            [self addSubview:view];

            CGRect viewFrame = CGRectMake(self.contentViewInsets.left + index * (self.contentPageSize.width + self.intervalOfPages), floorf((self.bounds.size.height - self.contentPageSize.height) / 2) , self.contentPageSize.width, self.contentPageSize.height);
            view.frame = viewFrame;
        }
    }
}
/**
 *  计算scrollView的ContentSize
 *  如果不计算正确，可能导致有的内容显示不出来，或者内容显示完了却有多余的空缺
 */
- (void)p_caculateAndSetContentSize {
    if (0 == self.pageNum) {
        return;
    }
    CGFloat width = (self.contentPageSize.width + self.intervalOfPages) * self.pageNum - self.intervalOfPages + self.contentViewInsets.left + self.contentViewInsets.right;
    self.contentSize = CGSizeMake(width, self.contentPageSize.height);
}























@end
