//
//  CommonMacros.h
//  YunPageView
//
//  Created by zhiyunyu on 2018/1/18.
//  Copyright © 2018年 zhiyunyu. All rights reserved.
//

#ifndef CommonMacros_h
#define CommonMacros_h


#endif /* CommonMacros_h */

/** checking **/
#define CHECK_VALID_STRING(__aString) (__aString && [__aString isKindOfClass:[NSString class]] && [__aString length])
#define CHECK_VALID_DATA(__aData) (__aData && [__aData isKindOfClass:[NSData class]] && [__aData length])
#define CHECK_VALID_NUMBER(__aNumber) (__aNumber && [__aNumber isKindOfClass:[NSNumber class]])
#define CHECK_VALID_ARRAY(__aArray) (__aArray && [__aArray isKindOfClass:[NSArray class]] && [__aArray count])
#define CHECK_VALID_MUTABLEARRAY(__aArray) (__aArray && [__aArray isKindOfClass:[NSMutableArray class]] && [__aArray count])
#define CHECK_VALID_DICTIONARY(__aDictionary) \
(__aDictionary && [__aDictionary isKindOfClass:[NSDictionary class]] && [__aDictionary count])
#define CHECK_VALID_MUTABLEDICTIONARY(__aDictionary) \
(__aDictionary && [__aDictionary isKindOfClass:[NSMutableDictionary class]] && [__aDictionary count])
#define CHECK_VALID_SET(__aSet) (__aSet && [__aSet isKindOfClass:[NSSet class]] && [__aSet count])
