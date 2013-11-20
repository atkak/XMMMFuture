//
//  XMMMFuture.m
//  XMMMFuture
//
//  Created by KAKEGAWA Atsushi on 2013/10/22.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMFuture.h"
#import "XMMMPromise.h"

@implementation XMMMFuture

- (void)success:(XMMMFutureSuccessBlock)successBlock failure:(XMMMFutureFailureBlock)failureBlock completed:(XMMMFutureCompleteBlock)completeBlock
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%s is not overriden at subclass", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

- (void)success:(XMMMFutureSuccessBlock)successBlock failure:(XMMMFutureFailureBlock)failureBlock completed:(XMMMFutureCompleteBlock)completeBlock queue:(dispatch_queue_t)queue
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%s is not overriden at subclass", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

- (XMMMFuture *)map:(XMMMFutureMapBlock)block
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%s is not overriden at subclass", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

- (XMMMFuture *)mapWithPromise:(XMMMFutureMapWithPromiseBlock)block
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%s is not overriden at subclass", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

- (XMMMFuture *)recover:(XMMMFutureRecoverBlock)block
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%s is not overriden at subclass", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

- (XMMMFuture *)recoverWithPromise:(XMMMFutureRecoverWithPromiseBlock)block
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%s is not overriden at subclass", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

@end

XMMMFuture *XMMMCreateFutureWithPromiseBlock(XMMMFuturePromiseBlock block)
{
    NSCParameterAssert(block != nil);
    
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future = promise.future;
    
    block(promise);
    
    return future;
}
