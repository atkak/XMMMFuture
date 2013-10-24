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

- (instancetype)initWithFuture:(XMMMFuture *)future mapBlock:(XMMMFutureMapBlock)block
{
    self = [super init];
    if (self) {
        _originalFuture = future;
        
        [future addSuccessObserverWithBlock:^(id result) {
            id newResult = block(result);
            [self resolveWithObject:newResult];
        }];
        
        [future addFailureObserverWithBlock:^(NSError *error) {
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
        
        [future addSuccessObserverWithBlock:^(id result) {
            XMMMFuture *newFuture = block(result);
            
            [newFuture addSuccessObserverWithBlock:^(id result) {
                [self resolveWithObject:result];
            }];
            
            [newFuture addFailureObserverWithBlock:^(NSError *error) {
                [self rejectWithError:error];
            }];
        }];
        
        [future addFailureObserverWithBlock:^(NSError *error) {
            [self rejectWithError:error];
        }];
    }
    return self;
}

@end
