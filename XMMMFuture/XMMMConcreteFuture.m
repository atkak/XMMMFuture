//
//  XMMMConcreteFuture.m
//  XMMMFuture
//
//  Created by KAKEGAWA Atsushi on 2013/10/22.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMConcreteFuture.h"
#import "XMMMMappedFuture.h"
#import "XMMMPromise.h"

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
@property (nonatomic, copy) XMMMFutureCompleteBlock completeBlock;
@property (nonatomic) dispatch_queue_t executeQueue;

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

- (void)success:(XMMMFutureSuccessBlock)successBlock
        failure:(XMMMFutureFailureBlock)failureBlock
      completed:(XMMMFutureCompleteBlock)completeBlock
{
    [self success:successBlock
          failure:failureBlock
        completed:completeBlock
            queue:dispatch_get_main_queue()];
}

- (void)success:(XMMMFutureSuccessBlock)successBlock
        failure:(XMMMFutureFailureBlock)failureBlock
      completed:(XMMMFutureCompleteBlock)completeBlock
          queue:(dispatch_queue_t)queue
{
    if (self.state == XMMMFutureStateIncomplete) {
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
        self.completeBlock = completeBlock;
        self.executeQueue = queue;
    } else if (self.state == XMMMFutureStateSucceeded) {
        self.state = XMMMFutureStateFinished;
        
        dispatch_async(queue, ^{
            successBlock(self.result);
            completeBlock();
        });
    } else if (self.state == XMMMFutureStateFailed) {
        self.state = XMMMFutureStateFinished;
        
        dispatch_async(queue, ^{
            failureBlock(self.error);
            completeBlock();
        });
    }
}

#pragma mark - Public methods (Future conbinators)

- (XMMMFuture *)map:(XMMMFutureMapBlock)block
{
    return [XMMMMappedFuture futureWithFuture:self mapBlock:block];
}

- (XMMMFuture *)mapWithPromise:(XMMMFutureMapWithPromiseBlock)block
{
    return [XMMMMappedFuture futureWithFuture:self mapWithPromiseBlock:block];
}

- (XMMMFuture *)recover:(XMMMFutureRecoverBlock)block
{
    return [XMMMMappedFuture futureWithFuture:self recoverBlock:block];
}

- (XMMMFuture *)recoverWithPromise:(XMMMFutureRecoverWithPromiseBlock)block
{
    return [XMMMMappedFuture futureWithFuture:self recoverWithPromiseBlock:block];
}

#pragma mark - Public methods (Promise resolvers)

- (void)resolveWithObject:(id)result
{
    if (self.state != XMMMFutureStateIncomplete) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Future is already resolved or rejected."
                                     userInfo:nil];
    }
    
    if (self.successBlock) {
        dispatch_queue_t queue = self.executeQueue;
        if (!queue) {
            queue = dispatch_get_main_queue();
        }
        
        dispatch_async(queue, ^{
            self.successBlock(result);
            if (self.completeBlock) {
                self.completeBlock();
            }
        });
        
        self.state = XMMMFutureStateFinished;
    } else {
        self.state = XMMMFutureStateSucceeded;
        self.result = result;
    }
}

- (void)rejectWithError:(NSError *)error
{
    if (!error) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Error must not be nil."
                                     userInfo:nil];
    }
    
    if (self.state != XMMMFutureStateIncomplete) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Future is already resolved or rejected."
                                     userInfo:nil];
    }
    
    if (self.failureBlock) {
        dispatch_queue_t queue = self.executeQueue;
        if (!queue) {
            queue = dispatch_get_main_queue();
        }
        
        dispatch_async(queue, ^{
            self.failureBlock(error);
            if (self.completeBlock) {
                self.completeBlock();
            }
        });
        
        self.state = XMMMFutureStateFinished;
    } else {
        self.state = XMMMFutureStateFailed;
        self.error = error;
    }
}

@end
