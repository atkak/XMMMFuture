//
//  XMMMMappedFuture.h
//  XMMMFuture
//
//  Created by KAKEGAWA Atsushi on 2013/10/23.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMConcreteFuture.h"

@interface XMMMMappedFuture : XMMMConcreteFuture

+ (instancetype)futureWithFuture:(XMMMFuture *)future mapBlock:(XMMMFutureMapBlock)block;
+ (instancetype)futureWithFuture:(XMMMFuture *)future flatMapBlock:(XMMMFutureFlatMapBlock)block;
+ (instancetype)futureWithFuture:(XMMMFuture *)future recoverBlock:(XMMMFutureRecoverBlock)block;
+ (instancetype)futureWithFuture:(XMMMFuture *)future recoverWithBlock:(XMMMFutureRecoverWithBlock)block;
- (instancetype)initWithFuture:(XMMMFuture *)future mapBlock:(XMMMFutureMapBlock)block;
- (instancetype)initWithFuture:(XMMMFuture *)future flatMapBlock:(XMMMFutureFlatMapBlock)block;
- (instancetype)initWithFuture:(XMMMFuture *)future recoverBlock:(XMMMFutureRecoverBlock)block;
- (instancetype)initWithFuture:(XMMMFuture *)future recoverWithBlock:(XMMMFutureRecoverWithBlock)block;

@end
