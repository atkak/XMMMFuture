//
//  XMMMFutureTests.m
//  XMMMFutureTests
//
//  Created by KAKEGAWA Atsushi on 2013/10/22.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMMFuture.h"
#import "XMMMPromise.h"

@interface XMMMFutureTests : XCTestCase

@end

@implementation XMMMFutureTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPromiseCreation
{
    XMMMPromise *promise = [XMMMPromise promise];
    
    XCTAssertNotNil(promise, @"Instance should not be nil.");
}

- (void)testFutureCreation
{
    XMMMPromise *promise = [XMMMPromise promise];
    XMMMFuture *future = promise.future;
    
    XCTAssertNotNil(future, @"Future should not be nil.");
}

- (void)testResolve
{
    XMMMPromise *promise = [XMMMPromise promise];
    XMMMFuture *future = promise.future;

    NSObject *obj1 = [NSObject new];
    
    [future success:^(id result) {
        XCTAssertEqual(result, obj1, @"Result object should be same as resolved one.");
    }];
    
    [future failure:^(NSError *error) {
        XCTFail(@"Failure block should not be called.");
    }];
    
    [promise resolve:obj1];
}

- (void)testReject
{
    XMMMPromise *promise = [XMMMPromise promise];
    XMMMFuture *future = promise.future;
    
    NSError *error1 = [NSError errorWithDomain:@"test" code:1 userInfo:nil];
    
    [future success:^(id result) {
        XCTFail(@"Success block should not be called.");
    }];
    
    [future failure:^(NSError *error) {
        XCTAssertEqual(error, error1, @"Error object should be same as rejected one.");
    }];
    
    [promise reject:error1];
}

- (void)testMap
{
    XMMMPromise *promise = [XMMMPromise promise];
    XMMMFuture *future1 = promise.future;
    
    NSString *str1 = @"Hello";
    
    XMMMFuture *future2 = [future1 map:^id(id result) {
        return [result stringByAppendingString:@", world!"];
    }];
    
    XCTAssertNotNil(future2, @"Mapped Future should not be nil.");
    
    [future2 success:^(id result) {
        XCTAssertEqualObjects(result, @"Hello, world!", @"");
    }];
    
    [promise resolve:str1];
}

//- (void)testFlatMap
//{
//    XMMMPromise *promise1 = [XMMMPromise promise];
//    XMMMFuture *future1 = promise1.future;
//    
//    NSString *str1 = @"Hello";
//    
//    XMMMFuture *future3 = [future1 flatMap:^XMMMFuture *(id result) {
//        XMMMPromise *promise2 = [XMMMPromise promise];
//        XMMMFuture *future2 = promise2.future;
//        
//        [promise2 resolve:[result stringByAppendingString:@", world!"]];
//        return future2;
//    }];
//}

@end
