//
//  YunObjectRecycler.h
//  YunPageView
//
//  Created by zhiyunyu on 2018/1/18.
//  Copyright © 2018年 zhiyunyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YunReusableObject<NSObject>
@optional
@property(nonatomic, copy) NSString *reuseIdentifier;
@end

@interface YunObjectRecycler : NSObject

- (instancetype)initWithMaxCacheSize:(NSUInteger)maxCacheSize;

- (void)enqueueRecycledObject:(id<YunReusableObject>)objectToRecycle;
- (NSObject<YunReusableObject> *)dequeueRecycledObjectForIdentifier:(NSString *)identifier;

@end
