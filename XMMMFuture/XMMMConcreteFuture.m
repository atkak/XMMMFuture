//
//  XMMMConcreteFuture.m
//  XMMMFuture
//
//  Created by KAKEGAWA Atsushi on 2013/10/22.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMConcreteFuture.h"
#import "XMMMMappedFuture.h"

typedef NS_ENUM(NSInteger, XMMMFutureState) {
    XMMMFutureStateIncomplete,
    XMMMFutureStateSucceeded,
    XMMMFutureStateFailed,
    XMMMFutureStateFinished
};

@interface XMMMConcreteFuture ()

@property (nonatomic) XMMMFutureState state;
@property (nonatomic) id result;
@property (nonatomic) NSError *error;
@property (nonatomic, copy) XMMMFutureSuccessBlock successBlock;
@property (nonatomic, copy) XMMMFutureFailureBlock failureBlock;

@end

@implementation XMMMConcreteFuture

#pragma mark - Accessor methods

- (BOOL)completed
{
    return self.state == XMMMFutureStateSucceeded ||
        self.state == XMMMFutureStateFailed ||
        self.state == XMMMFutureStateFinished;
}

#pragma mark - Lifecycle methods

- (id)init
{
    self = [super init];
    if (self) {
        _state = XMMMFutureStateIncomplete;
    }
    return self;
}

#pragma mark - Public methods (Future handlers)

- (void)addSuccessObserverWithBlock:(XMMMFutureSuccessBlock)block
{
    @synchronized(self) {
        if (self.state == XMMMFutureStateIncomplete) {
            self.successBlock = block;
        } else if (self.state == XMMMFutureStateSucceeded) {
            block(self.result);
            self.state = XMMMFutureStateFinished;
        }
    }
}

- (void)addFailureObserverWithBlock:(XMMMFutureFailureBlock)block
{
    @synchronized(self) {
        if (self.state == XMMMFutureStateIncomplete) {
            self.failureBlock = block;
        } else if (self.state == XMMMFutureStateFailed) {
            block(self.error);
            self.state = XMMMFutureStateFinished;
        }
    }
}

#pragma mark - Public methods (Future conbinators)

- (XMMMFuture *)map:(XMMMFutureMapBlock)block
{
    return [XMMMMappedFuture futureWithFuture:self mapBlock:block];
}

- (XMMMFuture *)flatMap:(XMMMFutureFlatMapBlock)block
{
    return [XMMMMappedFuture futureWithFuture:self flatMapBlock:block];
}

- (XMMMFuture *)recover:(XMMMFutureRecoverBlock)block
{
    return [XMMMMappedFuture futureWithFuture:self recoverBlock:block];
}

- (XMMMFuture *)recoverWith:(XMMMFutureRecoverWithBlock)block
{
    return [XMMMMappedFuture futureWithFuture:self recoverWithBlock:block];
}

#pragma mark - Public methods (Promise resolvers)

- (void)resolveWithObject:(id)result
{
    @synchronized(self) {
        if (self.state != XMMMFutureStateIncomplete) {
            return;
        }
        
        if (self.successBlock) {
            self.successBlock(result);
            self.state = XMMMFutureStateFinished;
        } else {
            self.state = XMMMFutureStateSucceeded;
            self.result = result;
        }
    }
}

- (void)rejectWithError:(NSError *)error
{
    if (!error) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Error must not be nil."
                                     userInfo:nil];
    }
    
    @synchronized(self) {
        if (self.state != XMMMFutureStateIncomplete) {
            return;
        }
        
        if (self.failureBlock) {
            self.failureBlock(error);
            self.state = XMMMFutureStateFinished;
        } else {
            self.state = XMMMFutureStateFailed;
            self.error = error;
        }
    }
}

@end
