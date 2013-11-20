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
+ (instancetype)futureWithFuture:(XMMMFuture *)future mapWithPromiseBlock:(XMMMFutureMapWithPromiseBlock)block;
+ (instancetype)futureWithFuture:(XMMMFuture *)future recoverBlock:(XMMMFutureRecoverBlock)block;
+ (instancetype)futureWithFuture:(XMMMFuture *)future recoverWithPromiseBlock:(XMMMFutureRecoverWithPromiseBlock)block;
- (instancetype)initWithFuture:(XMMMFuture *)future mapBlock:(XMMMFutureMapBlock)block;
- (instancetype)initWithFuture:(XMMMFuture *)future mapWithPromiseBlock:(XMMMFutureMapWithPromiseBlock)block;
- (instancetype)initWithFuture:(XMMMFuture *)future recoverBlock:(XMMMFutureRecoverBlock)block;
- (instancetype)initWithFuture:(XMMMFuture *)future recoverWithPromiseBlock:(XMMMFutureRecoverWithPromiseBlock)block;

@end
