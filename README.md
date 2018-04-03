# SingletonPattern
![](https://upload-images.jianshu.io/upload_images/3265534-34f64d071c083912.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。
这种模式涉及到一个单一的类，该类负责创建自己的对象，同时确保只有单个对象被创建。这个类提供了一种访问其唯一的对象的方式，可以直接访问，不需要实例化该类的对象。

**注意：**
* 1、单例类只能有一个实例。
* 2、单例类必须自己创建自己的唯一实例。
* 3、单例类必须给所有其他对象提供这一实例。

### iOS 中单例模式的实现方式一般分为两种:Non-ARC(非 ARC)和 ARC+GCD。
#### 建模：         
![](https://upload-images.jianshu.io/upload_images/3265534-7937361ff521dd07.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### NON-ARC(非 ARC)的实现：
可查看官方文档：[Creating a Singleton Instance](https://developer.apple.com/legacy/library/documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html#//apple_ref/doc/uid/TP40002974-CH4-SW32)
*因为现在iOS的项目默认是ARC的，我们需要将其对应的文件转换为非arc模式，如下图：*      
![](https://upload-images.jianshu.io/upload_images/3265534-05a9f111acbd018a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### Step 1：
创建单例类 `NonARCSingleton`         
![](https://upload-images.jianshu.io/upload_images/3265534-c4f40153143cad68.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### Step 2：
声明一个静态单例对象并初始化为nil.
```
// .m
static NonARCSingleton *instanceObj = nil;
```

#### Step 3：
在 `.m` 中实现在头文件中定义的方法 `+ (instancetype)sharedInstance;`
```
// 获取一个 sharedInstance 实例，如果有必要的话，实例化一个
+ (instancetype)sharedInstance {
if (instanceObj == nil) {
instanceObj = [[super allocWithZone:NULL] init];
}
return instanceObj;
}
// 当第一次使用这个单例时，会调用这个 init 方法。
- (id)init {
self = [super init];
if (self) {
// 通常在这里做一些相关的初始化任务

}
return self;
}
```
#### Step 4：
重写 `allocWithZone: `  方法，防止他人直接通过分配内存初始化的方式生成新的对象。
```
// 通过返回当前的 sharedInstance 实例，就能防止实例化一个新的对象。
+ (id)allocWithZone:(NSZone*)zone {
return [[self sharedInstance] retain];
}
```
#### Step 5：
实现基本协议的方法 `copyWithZone:` 、`mutableCopyWithZone ` 、`release` 、 `retain `、`retainCount` 、`autorelease` 并做适当的事情，以确保单例状态。
```
// 不希望生成单例的多个拷贝
- (id)copyWithZone:(NSZone *)zone {
return self;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
return self;
}

// 什么也不做 -- 该单例并不需要一个引用计数(retainCount)
- (id)retain {
return self;
}

// 替换掉引用计数 -- 永远都不会 release 这个单例。
- (NSUInteger)retainCount {
return NSUIntegerMax;
}

// 该方法是空的 -- 不希望用户 release 掉这个对象。
- (oneway void)release {
}

// 除了返回单例外，什么也不做。
- (id)autorelease {
return self;
}

// 这个 dealloc 方法永远都不会被调用 -- 因为在程序的生命周期内容，该单例一直都存在。(所以该方法可以不用实现)
-(void)dealloc
{ 
[super dealloc];
}
```
#### Step 6：测试
```
NonARCSingleton *singleton1 = [NonARCSingleton sharedInstance];
NSLog(@"singleton1对象的内存地址为:%p",singleton1);
NonARCSingleton *singleton2 = [[NonARCSingleton alloc] init];
NSLog(@"singleton2对象的内存地址为:%p",singleton2);
NonARCSingleton *singleton3 = [singleton2 copy];
NSLog(@"singleton3对象的内存地址为:%p",singleton3);
NonARCSingleton *singleton4 = [singleton2 mutableCopy];
NSLog(@"singleton4对象的内存地址为:%p",singleton4);
```
控制台打印效果：     
![](https://upload-images.jianshu.io/upload_images/3265534-dce974fc56e0cb4c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

打印结果一目了然，生成的四个对象指向**同一块内存地址**，单例对象创建成功了！！！

***

上面使用非ARC实现单例的方法并**不是线程安全**的，如果有多个线程调用 `sharedInstance` 方法，很可能造成 `init` 方法多次调用，**在不同线程中获取的不是同一个实例**。
##### 解决方法：使用 @synchronized 来创建互斥锁。
```
// 保证在实例化的时候是线程安全的
// (当然，该方法不能保证该单例中所有方法的调用都是线程安全的)
@synchronized (self) {
if (instanceObj == nil) {
instanceObj = [[super allocWithZone:NULL] init];
}
}
```
> 提醒:在 iOS 中，一般不建议使用非 ARC 来实现单例模式。更好的方法是使 用 ARC+GCD 来实现。
***

### ARC的实现：
#### Step 1：
创建单例类 `ARCSingleton`     
![](https://upload-images.jianshu.io/upload_images/3265534-a184f109c5640e01.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Step 2：
声明一个静态单例对象并初始化为nil.
```
static ARCSingleton *_instanceObj = nil;
```

#### Step 3：
在 `.m` 中实现在头文件中定义的方法 `+ (instancetype)sharedInstance;`
```
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
```
#### Step 4：
重写 `allocWithZone:` 方法，防止他人直接通过分配内存初始化的方式生成新的对象。
```
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
if (!_instanceObj) {
_instanceObj = [super allocWithZone:zone];
}
});
return _instanceObj;
}
```
#### Step 5：
实现基本协议的方法 `copyWithZone:` 、`mutableCopyWithZone `，防止他人通过拷贝的方式生成新的对象。
```
- (id)copyWithZone:(NSZone *)zone {
return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
return self;
}
```
#### Step 6：测试
```
ARCSingleton *singleton1 = [ARCSingleton sharedInstance];
NSLog(@"singleton1对象的内存地址为:%p",singleton1);
ARCSingleton *singleton2 = [[ARCSingleton alloc] init];
NSLog(@"singleton2对象的内存地址为:%p",singleton2);
ARCSingleton *singleton3 = [ARCSingleton copy];
NSLog(@"singleton3对象的内存地址为:%p",singleton3);
ARCSingleton *singleton4 = [ARCSingleton mutableCopy];
NSLog(@"singleton4对象的内存地址为:%p",singleton4);
```
控制台打印效果：         
![](https://upload-images.jianshu.io/upload_images/3265534-da70fdacd5a181d3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

打印结果一目了然，生成的四个对象指向同一块内存地址，使用ARC创建单例对象成功了！！！

***
### 我把单例模式写成了宏 `Singleton.h` ，方便使用。 
使用步骤如下：
#### Step 1：导入头文件
```
#import "Singleton.h"
```
#### Step 2：在 `.h` 和 `.m` 文件中实现宏
```
// .h 
#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface MacroSingleton : NSObject
// ()中为当前的类名
singleton_h(MacroSingleton);

@end

// .m 
#import "MacroSingleton.h"

@implementation MacroSingleton

singleton_m(MacroSingleton);

@end

```
#### Step 3：使用方法
```
MacroSingleton *singleton1 = [MacroSingleton shared];
```


千里之行，始于足下。
