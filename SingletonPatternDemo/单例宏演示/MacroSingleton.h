//
//  MacroSingleton.h
//  SingletonPatternDemo
//
//  Created by Joeyoung on 2018/4/3.
//  Copyright © 2018年 Joeyoung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface MacroSingleton : NSObject

// ()中为当前的类名
singleton_h(MacroSingleton);

@end
