//
//  NSObject+KVO.h
//  解剖---KVO
//
//  Created by 小萌 on 2017/5/27.
//  Copyright © 2017年 小萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO)
- (void)xy_addObserver:(NSObject *_Nullable)observer forKeyPath:(NSString *_Nullable)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

@end
