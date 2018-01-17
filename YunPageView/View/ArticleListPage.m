//
//  ArticleListPage.m
//  YunPageView
//
//  Created by zhiyunyu on 2018/1/16.
//  Copyright © 2018年 zhiyunyu. All rights reserved.
//

#import "ArticleListPage.h"

@interface ArticleListPage ()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *coverImage;

@end

@implementation ArticleListPage

+ (CGSize)size {
    return CGSizeMake(100, 120);
}

#pragma mark - Override
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.coverImage];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 正式工程中的代码，建议把数字定义成 const变量再使用，并且要适配屏幕
    self.titleLabel.frame = CGRectMake(10, 80, 80, 20);
    self.coverImage.frame = CGRectMake(10, 10, 80, 60);
    
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    
}

#pragma mark - Private Methods
- (void)layoutWithData:(NSString *)title {
    self.titleLabel.text = title;
}

#pragma mark - Accessors
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)coverImage {
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc] init];
        _coverImage.image = [UIImage imageNamed:@"a.jpg"];
    }
    return _coverImage;
}
@end
