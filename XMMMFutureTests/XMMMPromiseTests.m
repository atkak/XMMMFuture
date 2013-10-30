//
//  XMMMPromiseTests.m
//  XMMMFuture
//
//  Created by kakegawa.atsushi on 2013/10/25.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMMFutureHeader.h"

@interface XMMMPromiseTests : XCTestCase

@end

@implementation XMMMPromiseTests

- (void)setUp
{
    [super setUp];
    
}

- (void)tearDown
{
    
    [super tearDown];
}

#pragma mark - Test methods

- (void)testCreation
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    
    XCTAssertNotNil(promise, @"Promise should not be nil.");
    
    XMMMFuture *future = promise.future;
    
    XCTAssertNotNil(future, @"Future should not be nil.");
}

@end
