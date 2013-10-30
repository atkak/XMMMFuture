//
//  XMMMPromise.m
//  XMMMFuture
//
//  Created by KAKEGAWA Atsushi on 2013/10/22.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMPromise.h"
#import "XMMMConcreteFuture.h"

@interface XMMMPromise ()

@property (nonatomic) XMMMConcreteFuture *internalFuture;

@end

@implementation XMMMPromise

+ (instancetype)defaultPromise
{
    return [[self alloc] initWithFuture:[XMMMConcreteFuture new]];
}

- (instancetype)initWithFuture:(XMMMConcreteFuture *)future
{
    self = [super init];
    if (self) {
        _internalFuture = future;
    }
    return self;
}

- (XMMMFuture *)future
{
    return self.internalFuture;
}

- (BOOL)completed
{
    return self.internalFuture.completed;
}

- (void)resolveWithObject:(id)result
{
    [self.internalFuture resolveWithObject:result];
}

- (void)rejectWithError:(NSError *)error
{
    [self.internalFuture rejectWithError:error];
}

@end
