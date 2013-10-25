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
typedef id (^XMMMFutureMapBlock)(id result);
typedef XMMMFuture * (^XMMMFutureFlatMapBlock)(id result);
typedef id (^XMMMFutureRecoverBlock)(NSError *error);
typedef XMMMFuture * (^XMMMFutureRecoverWithBlock)(NSError *error);
typedef void (^XMMMFuturePromiseBlock)(XMMMPromise *promise);

@interface XMMMFuture : NSObject

@property (nonatomic, readonly) BOOL completed;

+ (instancetype)futureWithPromiseBlock:(XMMMFuturePromiseBlock)block;
- (instancetype)initWithPromiseBlock:(XMMMFuturePromiseBlock)block;

- (void)addSuccessObserverWithBlock:(XMMMFutureSuccessBlock)block;
- (void)addFailureObserverWithBlock:(XMMMFutureFailureBlock)block;

- (XMMMFuture *)map:(XMMMFutureMapBlock)block;
- (XMMMFuture *)flatMap:(XMMMFutureFlatMapBlock)block;
- (XMMMFuture *)recover:(XMMMFutureRecoverBlock)block;
- (XMMMFuture *)recoverWith:(XMMMFutureRecoverWithBlock)block;

@end
