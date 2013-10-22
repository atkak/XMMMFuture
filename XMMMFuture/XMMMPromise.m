//
//  XMMMPromise.m
//  XMMMFuture
//
//  Created by KAKEGAWA Atsushi on 2013/10/22.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMPromise.h"
#import "XMMMConcreteFuture.h"

@implementation XMMMPromise

+ (instancetype)promise
{
    return (XMMMPromise *)[XMMMConcreteFuture new];
}

- (XMMMFuture *)future
{
    return self;
}

@end
