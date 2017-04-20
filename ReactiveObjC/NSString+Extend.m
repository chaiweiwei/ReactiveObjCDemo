//
//  NSString+Extend.m
//  ReactiveObjC
//
//  Created by chaiweiwei on 2017/4/19.
//  Copyright © 2017年 chaiweiwei. All rights reserved.
//

#import "NSString+Extend.h"
#import <objc/runtime.h>

static NSString *strKey = @"strKey";

@implementation NSString (Extend)

- (void)setDesc:(NSString *)desc {
    objc_setAssociatedObject(self, &strKey, desc, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)desc {
    return objc_getAssociatedObject(self, &strKey);
}


@end
