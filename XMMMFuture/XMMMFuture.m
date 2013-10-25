//
//  XMMMFuture.m
//  XMMMFuture
//
//  Created by KAKEGAWA Atsushi on 2013/10/22.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMFuture.h"
#import "XMMMConcreteFuture.h"

@implementation XMMMFuture

+ (instancetype)futureWithPromiseBlock:(XMMMFuturePromiseBlock)block
{
    return [[XMMMConcreteFuture alloc] initWithPromiseBlock:block];
}

@end
