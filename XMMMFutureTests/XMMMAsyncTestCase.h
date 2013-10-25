//
//  XMMMAsyncTestCase.h
//  XMMMFuture
//
//  Created by kakegawa.atsushi on 2013/10/25.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XMMMAsyncTestCase : XCTestCase

@property (nonatomic) NSTimeInterval timeoutDuration;

- (void)finishTest;

@end
