//
//  XMMMMappedFuture.m
//  XMMMFuture
//
//  Created by KAKEGAWA Atsushi on 2013/10/23.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMMappedFuture.h"

@interface XMMMMappedFuture ()

@property (nonatomic) XMMMFuture *originalFuture;

@end

@implementation XMMMMappedFuture

+ (instancetype)futureWithFuture:(XMMMFuture *)future mapBlock:(XMMMFutureMapBlock)block
{
    return [[self alloc] initWithFuture:future mapBlock:block];
}

+ (instancetype)futureWithFuture:(XMMMFuture *)future flatMapBlock:(XMMMFutureFlatMapBlock)block
{
    return [[self alloc] initWithFuture:future flatMapBlock:block];
}

+ (instancetype)futureWithFuture:(XMMMFuture *)future recoverBlock:(XMMMFutureRecoverBlock)block
{
    return [[self alloc] initWithFuture:future recoverBlock:block];
}

+ (instancetype)futureWithFuture:(XMMMFuture *)future recoverWithBlock:(XMMMFutureRecoverWithBlock)block
{
    return [[self alloc] initWithFuture:future recoverWithBlock:block];
}

- (instancetype)initWithFuture:(XMMMFuture *)future mapBlock:(XMMMFutureMapBlock)block
{
    self = [super init];
    if (self) {
        _originalFuture = future;
        
        [future setSuccessHandlerWithBlock:^(id result) {
            id newResult = block(result);
            [self resolveWithObject:newResult];
        }];
        
        [future setFailureHandlerWithBlock:^(NSError *error) {
            [self rejectWithError:error];
        }];
    }
    return self;
}

- (instancetype)initWithFuture:(XMMMFuture *)future flatMapBlock:(XMMMFutureFlatMapBlock)block
{
    self = [super init];
    if (self) {
        _originalFuture = future;
        
        [future setSuccessHandlerWithBlock:^(id result) {
            XMMMFuture *newFuture = block(result);
            
            [newFuture setSuccessHandlerWithBlock:^(id result) {
                [self resolveWithObject:result];
            }];
            
            [newFuture setFailureHandlerWithBlock:^(NSError *error) {
                [self rejectWithError:error];
            }];
        }];
        
        [future setFailureHandlerWithBlock:^(NSError *error) {
            [self rejectWithError:error];
        }];
    }
    return self;
}

- (instancetype)initWithFuture:(XMMMFuture *)future recoverBlock:(XMMMFutureRecoverBlock)block
{
    self = [super init];
    if (self) {
        _originalFuture = future;
        
        [future setSuccessHandlerWithBlock:^(id result) {
            [self resolveWithObject:result];
        }];
        
        [future setFailureHandlerWithBlock:^(NSError *error) {
            id newResult = block(error);
            
            if ([newResult isKindOfClass:[NSError class]]) {
                NSError *newError = (NSError *)newResult;
                [self rejectWithError:newError];
            } else {
                [self resolveWithObject:newResult];
            }
        }];
    }
    return self;
}

- (instancetype)initWithFuture:(XMMMFuture *)future recoverWithBlock:(XMMMFutureRecoverWithBlock)block
{
    self = [super init];
    if (self) {
        _originalFuture = future;
        
        [future setSuccessHandlerWithBlock:^(id result) {
            [self resolveWithObject:result];
        }];
        
        [future setFailureHandlerWithBlock:^(NSError *error) {
            XMMMFuture *newFuture = block(error);
            
            [newFuture setSuccessHandlerWithBlock:^(id result) {
                [self resolveWithObject:result];
            }];
            
            [newFuture setFailureHandlerWithBlock:^(NSError *error) {
                [self rejectWithError:error];
            }];
        }];
    }
    return self;
}

@end
