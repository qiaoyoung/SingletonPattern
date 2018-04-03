//
//  ARCSingleton.m
//  SingletonPatternDemo
//
//  Created by Joeyoung on 2018/4/3.
//  Copyright © 2018年 Joeyoung. All rights reserved.
//

#import "ARCSingleton.h"

static ARCSingleton *_instanceObj = nil;

@implementation ARCSingleton

+ (instancetype)sharedInstance {
    // 只会执行一次
    // 该方法是线程安全的
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instanceObj) {
            _instanceObj = [[self alloc] init];
        }
    });
    return _instanceObj;
}

// 当第一次使用这个单例时，会调用这个 init 方法
- (id)init {
    self = [super init];
    if (self) {
        // 通常在这里做一些相关的初始化任务
        
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instanceObj) {
            _instanceObj = [super allocWithZone:zone];
        }
    });
    return _instanceObj;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

@end
