//
//  XMMMConcreteFutureTests.m
//  XMMMFuture
//
//  Created by kakegawa.atsushi on 2013/10/25.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMMAsyncTestCase.h"
#import "XMMMFutureHeader.h"

@interface XMMMConcreteFutureTests : XMMMAsyncTestCase

@end

@implementation XMMMConcreteFutureTests

#pragma mark - Lifecycle methods

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    self.timeoutDuration = 3.0;
    
    [super tearDown];
}

#pragma mark - Test methods

- (void)testResolveFutureByPromise
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future = promise.future;
    
    NSObject *obj1 = [NSObject new];
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise resolveWithObject:obj1];
    });
    
    [future success:^(id result) {
        XCTAssertEqual(result, obj1, @"Result object should be same as resolved one.");
    } failure:^(NSError *error) {
        XCTFail(@"Failure block should not be called.");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testResolveFutureByFuture
{
    NSObject *obj1 = [NSObject new];
    
    XMMMFuture *future = XMMMCreateFutureWithPromiseBlock(^(XMMMPromise *promise) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [promise resolveWithObject:obj1];
        });
    });
    
    [future success:^(id result) {
        XCTAssertEqual(result, obj1, @"Result object should be same as resolved one.");
    } failure:^(NSError *error) {
        XCTFail(@"Failure block should not be called.");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testResolveFutureByPromiseAlreadyResolved
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future = promise.future;
    
    NSObject *obj1 = [NSObject new];
    [promise resolveWithObject:obj1];
    
    [future success:^(id result) {
        XCTAssertEqual(result, obj1, @"Result object should be same as resolved one.");
    } failure:^(NSError *error) {
        XCTFail(@"Failure block should not be called.");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testResolveFutureByFutureAlreadyResolved
{
    NSObject *obj1 = [NSObject new];
    
    XMMMFuture *future = XMMMCreateFutureWithPromiseBlock(^(XMMMPromise *promise) {
        [promise resolveWithObject:obj1];
    });
    
    [future success:^(id result) {
        XCTAssertEqual(result, obj1, @"Result object should be same as resolved one.");
    } failure:^(NSError *error) {
        XCTFail(@"Failure block should not be called.");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testReject
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future = promise.future;
    
    NSError *error1 = [self error];
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise rejectWithError:error1];
    });
    
    [future success:^(id result) {
        XCTFail(@"Success block should not be called.");
    } failure:^(NSError *error) {
        XCTAssertEqual(error, error1, @"Error object should be same as rejected one.");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testRejectAlreadyRejected
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future = promise.future;
    
    NSError *error1 = [self error];
    [promise rejectWithError:error1];
    
    [future success:^(id result) {
        XCTFail(@"Success block should not be called.");
    } failure:^(NSError *error) {
        XCTAssertEqual(error, error1, @"Error object should be same as rejected one.");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testMap
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future = promise.future;
    
    XMMMFuture *mappedFuture = [future map:^id(id result) {
        return [result stringByAppendingString:@", world!"];
    }];
    
    XCTAssertNotNil(mappedFuture, @"Mapped Future should not be nil.");
    
    NSString *str1 = @"Hello";
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise resolveWithObject:str1];
        [self finishTest];
    });
    
    [mappedFuture success:^(id result) {
        XCTAssertEqualObjects(result, @"Hello, world!", @"");
    } failure:^(NSError *error) {
        XCTFail(@"");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testMapFailed
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future = promise.future;
    
    XMMMFuture *mappedFuture = [future map:^id(id result) {
        XCTFail(@"");
        return nil;
    }];
    
    XCTAssertNotNil(mappedFuture, @"Mapped Future should not be nil.");
    
    NSError *error1 = [self error];
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise rejectWithError:error1];
        [self finishTest];
    });
    
    [mappedFuture success:^(id result) {
        XCTFail(@"");
    } failure:^(NSError *error) {
        XCTAssertEqual(error, error1, @"");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testFlatMap
{
    XMMMPromise *promise1 = [XMMMPromise defaultPromise];
    XMMMFuture *future1 = promise1.future;
    
    NSString *str1 = @"Hello";
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise1 resolveWithObject:str1];
    });
    
    XMMMFuture *composedFuture = [future1 mapWithPromise:^void (id result, XMMMPromise *promise) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [promise resolveWithObject:[result stringByAppendingString:@", world!"]];
        });
    }];
    
    XCTAssertNotNil(composedFuture, @"Composed Future should not be nil.");
    
    [composedFuture success:^(id result) {
        XCTAssertEqualObjects(result, @"Hello, world!", @"");
    } failure:^(NSError *error) {
        XCTFail(@"");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testFlatMapFirstFutureFailed
{
    XMMMPromise *promise1 = [XMMMPromise defaultPromise];
    XMMMFuture *future1 = promise1.future;
    
    NSError *error1 = [self error];
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise1 rejectWithError:error1];
    });
    
    XMMMFuture *composedFuture = [future1 mapWithPromise:^void (id result, XMMMPromise *promise) {
        XCTFail(@"");
    }];
    
    XCTAssertNotNil(composedFuture, @"Composed Future should not be nil.");
    
    [composedFuture success:^(id result) {
        XCTFail(@"");
    } failure:^(NSError *error) {
        XCTAssertEqualObjects(error, error1, @"");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testFlatMapSecondFutureFailed
{
    XMMMPromise *promise1 = [XMMMPromise defaultPromise];
    XMMMFuture *future1 = promise1.future;
    
    NSString *str1 = @"Hello";
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise1 resolveWithObject:str1];
    });
    
    NSError *error1 = [self error];
    
    XMMMFuture *composedFuture = [future1 mapWithPromise:^void (id result, XMMMPromise *promise) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [promise rejectWithError:error1];
        });
    }];
    
    XCTAssertNotNil(composedFuture, @"Composed Future should not be nil.");
    
    [composedFuture success:^(id result) {
        XCTFail(@"");
    } failure:^(NSError *error) {
        XCTAssertEqualObjects(error, error1, @"");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testRecover
{
    XMMMPromise *promise1 = [XMMMPromise defaultPromise];
    XMMMFuture *future1 = promise1.future;
    
    NSError *error1 = [self error];
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise1 rejectWithError:error1];
    });
    
    NSObject *obj = [NSObject new];
    
    XMMMFuture *composedFuture = [future1 recover:^id(NSError *error) {
        return obj;
    }];
    
    XCTAssertNotNil(composedFuture, @"Mapped Future should not be nil.");
    
    [composedFuture success:^(id result) {
        XCTAssertEqual(result, obj, @"");
    } failure:^(NSError *error) {
        XCTFail(@"");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testRecoverSucceeded
{
    XMMMPromise *promise1 = [XMMMPromise defaultPromise];
    XMMMFuture *future1 = promise1.future;
    
    NSObject *obj = [NSObject new];
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise1 resolveWithObject:obj];
    });
    
    XMMMFuture *composedFuture = [future1 recover:^id(NSError *error) {
        XCTFail(@"");
        return nil;
    }];
    
    XCTAssertNotNil(composedFuture, @"Mapped Future should not be nil.");
    
    [composedFuture success:^(id result) {
        XCTAssertEqual(result, obj, @"");
    } failure:^(NSError *error) {
        XCTFail(@"");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testRecoverWith
{
    XMMMPromise *promise1 = [XMMMPromise defaultPromise];
    XMMMFuture *future1 = promise1.future;
    
    NSError *error1 = [self error];
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise1 rejectWithError:error1];
    });
    
    NSObject *obj1 = [NSObject new];
    
    XMMMFuture *composedFuture = [future1 recoverWithPromise:^void (NSError *error, XMMMPromise *promise) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [promise resolveWithObject:obj1];
        });
    }];
    
    XCTAssertNotNil(composedFuture, @"Composed Future should not be nil.");
    
    [composedFuture success:^(id result) {
        XCTAssertEqual(result, obj1, @"");
    } failure:^(NSError *error) {
        XCTFail(@"");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testRecoverWithFirstFutureSucceeded
{
    XMMMPromise *promise1 = [XMMMPromise defaultPromise];
    XMMMFuture *future1 = promise1.future;
    
    NSObject *obj1 = [NSObject new];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise1 resolveWithObject:obj1];
    });
    
    XMMMFuture *composedFuture = [future1 recoverWithPromise:^void (NSError *error, XMMMPromise *promise) {
        XCTFail(@"");
    }];
    
    XCTAssertNotNil(composedFuture, @"Composed Future should not be nil.");
    
    [composedFuture success:^(id result) {
        XCTAssertEqual(result, obj1, @"");
    } failure:^(NSError *error) {
        XCTFail(@"");
    } completed:^{
        [self finishTest];
    }];
}

- (void)testRecoverWithSecondFutureFailed
{
    XMMMPromise *promise1 = [XMMMPromise defaultPromise];
    XMMMFuture *future1 = promise1.future;
    
    NSError *error1 = [self error];
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise1 rejectWithError:error1];
    });
    
    NSError *error2 = [self error];
    
    XMMMFuture *composedFuture = [future1 recoverWithPromise:^void (NSError *error, XMMMPromise *promise) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [promise rejectWithError:error2];
        });
    }];
    
    XCTAssertNotNil(composedFuture, @"Composed Future should not be nil.");
    
    [composedFuture success:^(id result) {
        XCTFail(@"");
    } failure:^(NSError *error) {
        XCTAssertEqual(error, error2, @"");
    } completed:^{
        [self finishTest];
    }];
}

#pragma mark - Helper methods

- (NSError *)error
{
    return [NSError errorWithDomain:@"test" code:1 userInfo:nil];
}

@end
