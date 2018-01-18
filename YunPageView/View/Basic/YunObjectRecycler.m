//
//  YunObjectRecycler.m
//  YunPageView
//
//  Created by zhiyunyu on 2018/1/18.
//  Copyright © 2018年 zhiyunyu. All rights reserved.
//

#import "YunObjectRecycler.h"

@interface YunObjectRecycler ()
@property(nonatomic, strong) NSMutableDictionary *recycleObjects;
@property(nonatomic, assign) NSUInteger maxCacheSize;
@end

@implementation YunObjectRecycler

- (instancetype)initWithMaxCacheSize:(NSUInteger)maxCacheSize {
    self = [super init];
    if (self) {
        self.recycleObjects = [NSMutableDictionary dictionary];
        self.maxCacheSize = maxCacheSize;
    }
    return self;
}

- (void)enqueueRecycledObject:(id<YunReusableObject>)objectToRecycle {
    if (!objectToRecycle || ![objectToRecycle respondsToSelector:@selector(reuseIdentifier)] ||
        !CHECK_VALID_STRING(objectToRecycle.reuseIdentifier)) {
        return;
    }

    NSString *identifier = objectToRecycle.reuseIdentifier;
    NSMutableSet *set = self.recycleObjects[identifier];
    if (!set) {
        set = [NSMutableSet set];
        [set addObject:objectToRecycle];
        self.recycleObjects[identifier] = set;
    } else if (![set containsObject:objectToRecycle]) {
        if ([set count] < self.maxCacheSize) {
            [set addObject:objectToRecycle];
        }
    }
}

- (NSObject<YunReusableObject> *)dequeueRecycledObjectForIdentifier:(NSString *)identifier {
    if (!CHECK_VALID_STRING(identifier)) {
        return nil;
    }
    
    NSObject<YunReusableObject> *result;
    NSMutableSet *set = self.recycleObjects[result];
    if (CHECK_VALID_SET(set)) {
        id objectToRecycle = [set anyObject];
        [set removeObject:objectToRecycle];
    }
    return result;
}

@end
