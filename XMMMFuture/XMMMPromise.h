//
//  XMMMPromise.h
//  XMMMFuture
//
//  Created by KAKEGAWA Atsushi on 2013/10/22.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMFuture.h"

@interface XMMMPromise : NSObject

@property (nonatomic, readonly) XMMMFuture *future;
@property (nonatomic, readonly) BOOL completed;

+ (instancetype)defaultPromise;

- (void)resolveWithObject:(id)result;
- (void)rejectWithError:(NSError *)error;

@end
