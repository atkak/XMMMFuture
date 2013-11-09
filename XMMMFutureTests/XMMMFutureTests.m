//
//  XMMMFutureTests.m
//  XMMMFutureTests
//
//  Created by KAKEGAWA Atsushi on 2013/10/22.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMMFutureHeader.h"

@interface XMMMFutureTests : XCTestCase

@end

@implementation XMMMFutureTests

#pragma mark - Lifecycle methods

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
    XMMMFuture *future = XMMMCreateFutureWithPromiseBlock(^(XMMMPromise *promise) {
        XCTAssertNotNil(promise, @"Promise should not be nil.");
    });
    
    XCTAssertNotNil(future, @"Future should not be nil.");
}

- (void)testCreationWithNil
{
    XCTAssertThrows(XMMMCreateFutureWithPromiseBlock(nil), @"Creating Future with nil blocks should raise Exception.");
}

@end
