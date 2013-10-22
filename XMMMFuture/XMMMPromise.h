//
//  XMMMPromise.h
//  XMMMFuture
//
//  Created by KAKEGAWA Atsushi on 2013/10/22.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMFuture.h"

@interface XMMMPromise : XMMMFuture

@property (nonatomic, readonly) XMMMFuture *future;

+ (instancetype)promise;

- (void)resolve:(id)result;
- (void)reject:(NSError *)error;

@end
