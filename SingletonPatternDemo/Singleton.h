//
//  Singleton.h
//  SingletonPatternDemo
//
//  Created by Joeyoung on 2018/4/3.
//  Copyright © 2018年 Joeyoung. All rights reserved.
//

#define singleton_h(name) + (instancetype)shared;

#if __has_feature(objc_arc) // ARC

#define singleton_m(name) \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
if (!_instance) { \
_instance = [super allocWithZone:zone]; \
} \
}); \
return _instance; \
} \
+ (instancetype)shared { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
if (!_instance) { \
_instance = [[self alloc] init]; \
} \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone { \
return self; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone { \
return self; \
} \

#else // 非ARC

#define singleton_m(name) \
static id _instance; \
+ (id)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)shared { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
+ (id)copyWithZone:(struct _NSZone *)zone { \
return self; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone { \
return self; \
} \
- (oneway void)release { \
} \
- (id)autorelease { \
return self; \
} \
- (id)retain { \
return self; \
} \
- (NSUInteger)retainCount { \
return NSUIntegerMax; \
} \


#endif
