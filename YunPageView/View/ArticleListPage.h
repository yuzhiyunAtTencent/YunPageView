//
//  ArticleListPage.h
//  YunPageView
//
//  Created by zhiyunyu on 2018/1/16.
//  Copyright © 2018年 zhiyunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunObjectRecycler.h"

@interface ArticleListPage : UIView <YunReusableObject>

+ (CGSize)size;
+ (NSString *)identifier;

- (void)layoutWithData:(NSString *)title;

@end
