//
//  ArticleListPage.h
//  YunPageView
//
//  Created by zhiyunyu on 2018/1/16.
//  Copyright © 2018年 zhiyunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleListPage : UIView

+ (CGSize)size;

- (void)layoutWithData:(NSString *)title;

@end
