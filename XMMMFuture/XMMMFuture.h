//
//  XMMMFuture.h
//  XMMMFuture
//
//  Created by KAKEGAWA Atsushi on 2013/10/22.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMMMFuture;

typedef void (^XMMMFutureSuccessBlock)(id result);
typedef void (^XMMMFutureFailureBlock)(NSError *error);

@interface XMMMFuture : NSObject

@property (nonatomic, readonly) BOOL completed;

- (void)success:(XMMMFutureSuccessBlock)block;
- (void)failure:(XMMMFutureFailureBlock)block;

@end
