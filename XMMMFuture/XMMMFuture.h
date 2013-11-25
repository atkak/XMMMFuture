//
//  XMMMFuture.h
//  XMMMFuture
//
//  Created by KAKEGAWA Atsushi on 2013/10/22.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMMMFuture;
@class XMMMPromise;

typedef void (^XMMMFutureSuccessBlock)(id result);
typedef void (^XMMMFutureFailureBlock)(NSError *error);
typedef void (^XMMMFutureCompleteBlock)();

typedef id (^XMMMFutureMapBlock)(id result);
typedef XMMMFuture * (^XMMMFutureMapForFutureBlock)(id result);
typedef void (^XMMMFutureMapWithPromiseBlock)(id result, XMMMPromise *promise);
typedef id (^XMMMFutureRecoverBlock)(NSError *error);
typedef XMMMFuture * (^XMMMFutureRecoverForFutureBlock)(NSError *error);
typedef void (^XMMMFutureRecoverWithPromiseBlock)(NSError *error, XMMMPromise *promise);

typedef void (^XMMMFuturePromiseBlock)(XMMMPromise *promise);

@interface XMMMFuture : NSObject

@property (nonatomic, readonly) BOOL completed;

- (void)success:(XMMMFutureSuccessBlock)successBlock
        failure:(XMMMFutureFailureBlock)failureBlock
      completed:(XMMMFutureCompleteBlock)completeBlock;
- (void)success:(XMMMFutureSuccessBlock)successBlock
        failure:(XMMMFutureFailureBlock)failureBlock
      completed:(XMMMFutureCompleteBlock)completeBlock
          queue:(dispatch_queue_t)queue;

- (XMMMFuture *)map:(XMMMFutureMapBlock)block;
- (XMMMFuture *)mapForFuture:(XMMMFutureMapForFutureBlock)block;
- (XMMMFuture *)mapWithPromise:(XMMMFutureMapWithPromiseBlock)block;
- (XMMMFuture *)recover:(XMMMFutureRecoverBlock)block;
- (XMMMFuture *)recoverForFuture:(XMMMFutureRecoverForFutureBlock)block;
- (XMMMFuture *)recoverWithPromise:(XMMMFutureRecoverWithPromiseBlock)block;

@end

XMMMFuture *XMMMCreateFutureWithPromiseBlock(XMMMFuturePromiseBlock block);
