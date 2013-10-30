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

- (void)setSuccessHandlerWithBlock:(XMMMFutureSuccessBlock)block
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%s is not overriden at subclass", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

- (void)setFailureHandlerWithBlock:(XMMMFutureFailureBlock)block
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

- (XMMMFuture *)flatMap:(XMMMFutureFlatMapBlock)block
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

- (XMMMFuture *)recoverWith:(XMMMFutureRecoverWithBlock)block
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%s is not overriden at subclass", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

@end

XMMMFuture *XMMMCreateFutureWithPromiseBlock(XMMMFuturePromiseBlock block)
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future = promise.future;
    
    block(promise);
    
    return future;
}
