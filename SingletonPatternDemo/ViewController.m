//
//  ViewController.m
//  SingletonPatternDemo
//
//  Created by Joeyoung on 2018/4/3.
//  Copyright © 2018年 Joeyoung. All rights reserved.
//

#import "ViewController.h"

#import "NonARCSingleton.h"
#import "ARCSingleton.h"
#import "MacroSingleton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 非ARC单例测试
//    [self nonARCSingletonDemo];
    
    // ARC单例测试
//    [self arcSingletonDemo];

    // 单例宏测试
    [self macroSingletonDemo];
    
}

// 非ARC单例测试
- (void)nonARCSingletonDemo {
    NonARCSingleton *singleton1 = [NonARCSingleton sharedInstance];
    NSLog(@"singleton1对象的内存地址为:%p",singleton1);
    NonARCSingleton *singleton2 = [[NonARCSingleton alloc] init];
    NSLog(@"singleton2对象的内存地址为:%p",singleton2);
    NonARCSingleton *singleton3 = [singleton2 copy];
    NSLog(@"singleton3对象的内存地址为:%p",singleton3);
    NonARCSingleton *singleton4 = [singleton2 mutableCopy];
    NSLog(@"singleton4对象的内存地址为:%p",singleton4);
}

// ARC单例测试
- (void)arcSingletonDemo {
    ARCSingleton *singleton1 = [ARCSingleton sharedInstance];
    NSLog(@"singleton1对象的内存地址为:%p",singleton1);
    ARCSingleton *singleton2 = [[ARCSingleton alloc] init];
    NSLog(@"singleton2对象的内存地址为:%p",singleton2);
    ARCSingleton *singleton3 = [singleton2 copy];
    NSLog(@"singleton3对象的内存地址为:%p",singleton3);
    ARCSingleton *singleton4 = [singleton2 mutableCopy];
    NSLog(@"singleton4对象的内存地址为:%p",singleton4);
}

// 单例宏测试
- (void)macroSingletonDemo {
    MacroSingleton *singleton1 = [MacroSingleton shared];
    NSLog(@"singleton1对象的内存地址为:%p",singleton1);
    MacroSingleton *singleton2 = [[MacroSingleton alloc] init];
    NSLog(@"singleton2对象的内存地址为:%p",singleton2);
    MacroSingleton *singleton3 = [singleton2 copy];
    NSLog(@"singleton3对象的内存地址为:%p",singleton3);
    MacroSingleton *singleton4 = [singleton2 mutableCopy];
    NSLog(@"singleton4对象的内存地址为:%p",singleton4);
}

@end
