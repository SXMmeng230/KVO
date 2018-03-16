//
//  NSObject+KVO.m
//  解剖---KVO
//
//  Created by 小萌 on 2017/5/27.
//  Copyright © 2017年 小萌. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/message.h>
@implementation NSObject (KVO)

- (void)xy_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    NSString *classStr = NSStringFromClass([self class]);
    NSString *childClassStr = [NSString stringWithFormat:@"XYKVO_%@",classStr];
    
   Class childClass =  objc_allocateClassPair([self class], [childClassStr UTF8String], 0);
    class_addMethod(childClass, NSSelectorFromString([NSString stringWithFormat:@"set%@:",[keyPath capitalizedString]]), (IMP)name, "");
    objc_registerClassPair(childClass);
    object_setClass(self, childClass);
    objc_setAssociatedObject(self, @"objc", observer, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, @"keyPath", keyPath, OBJC_ASSOCIATION_COPY);
}
id getter(id self, SEL _cmd) {
    NSString *key = NSStringFromSelector(_cmd);
    NSString * keyPath  = objc_getAssociatedObject(self, @"keyPath");
    Ivar ivar = class_getInstanceVariable([self class], [keyPath UTF8String]);
    NSMutableDictionary *dictCustomerProperty = object_getIvar(self, ivar);
    return [dictCustomerProperty objectForKey:key];
}
void name(id self,SEL _cmd ,NSString * newName){
    id class = [self class];
    object_setClass(self, class_getSuperclass([self class]));
    NSString * keyPath  = objc_getAssociatedObject(self, @"keyPath");
    //旧值
    unsigned int count;
    id old;
    Method *memberFuncs = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {
        SEL name = method_getName(memberFuncs[i]);
        NSString *methodName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        if ([methodName isEqualToString:keyPath]) {
           old =  [self name];
            
            break;
        }
    }
    //新值
    //向Person发送set消息，为了消除死循环
    objc_msgSend(self,NSSelectorFromString([NSString stringWithFormat:@"set%@:",[keyPath capitalizedString]]),newName);
    id objc = objc_getAssociatedObject(self, @"objc");
    

    
    objc_msgSend(objc, @selector(observeValueForKeyPath:ofObject:change:context:),keyPath,self,@{@"old":old,@"new":newName},nil);
    //这设置到XYKVO_Person，继续监听
    object_setClass(self, class);

}
@end
