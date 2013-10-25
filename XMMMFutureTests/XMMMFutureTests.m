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

@property (atomic) BOOL completed;

@end

@implementation XMMMFutureTests

#pragma mark - Lifecycle methods

- (void)setUp
{
    [super setUp];
    
    self.completed = NO;
}

- (void)tearDown
{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        XCTFail(@"timed out.");
        [self finishTest];
    });
    
    do {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    } while (!self.completed);
    
    [super tearDown];
}

#pragma mark - Test methods

- (void)testCreationByPromise
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    
    XCTAssertNotNil(promise, @"Promise should not be nil.");

    XMMMFuture *future = promise.future;
    
    XCTAssertNotNil(future, @"Future should not be nil.");
    
    [self finishTest];
}

- (void)testCreationByFuture
{
    XMMMFuture *future = [XMMMFuture futureWithPromiseBlock:^(XMMMPromise *promise) {
        XCTAssertNotNil(promise, @"Promise should not be nil.");
    }];
    
    XCTAssertNotNil(future, @"Future should not be nil.");
    
    [self finishTest];
}

- (void)testResolve
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future = promise.future;

    NSObject *obj1 = [NSObject new];
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise resolveWithObject:obj1];
    });
    
    [future addSuccessObserverWithBlock:^(id result) {
        XCTAssertEqual(result, obj1, @"Result object should be same as resolved one.");
        [self finishTest];
    }];
    
    [future addFailureObserverWithBlock:^(NSError *error) {
        XCTFail(@"Failure block should not be called.");
        [self finishTest];
    }];
}

- (void)testResolveFuture
{
    NSObject *obj1 = [NSObject new];
    
    XMMMFuture *future = [XMMMFuture futureWithPromiseBlock:^(XMMMPromise *promise) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [promise resolveWithObject:obj1];
        });
    }];
    
    [future addSuccessObserverWithBlock:^(id result) {
        XCTAssertEqual(result, obj1, @"Result object should be same as resolved one.");
        [self finishTest];
    }];
    
    [future addFailureObserverWithBlock:^(NSError *error) {
        XCTFail(@"Failure block should not be called.");
        [self finishTest];
    }];
}

- (void)testResolveAlreadyResolved
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future = promise.future;
    
    NSObject *obj1 = [NSObject new];
    [promise resolveWithObject:obj1];
    
    [future addSuccessObserverWithBlock:^(id result) {
        XCTAssertEqual(result, obj1, @"Result object should be same as resolved one.");
        [self finishTest];
    }];
    
    [future addFailureObserverWithBlock:^(NSError *error) {
        XCTFail(@"Failure block should not be called.");
        [self finishTest];
    }];
}

- (void)testResolveFutureAlreadyResolved
{
    NSObject *obj1 = [NSObject new];
    
    XMMMFuture *future = [XMMMFuture futureWithPromiseBlock:^(XMMMPromise *promise) {
        [promise resolveWithObject:obj1];
    }];
    
    [future addSuccessObserverWithBlock:^(id result) {
        XCTAssertEqual(result, obj1, @"Result object should be same as resolved one.");
        [self finishTest];
    }];
    
    [future addFailureObserverWithBlock:^(NSError *error) {
        XCTFail(@"Failure block should not be called.");
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
    
    [future addSuccessObserverWithBlock:^(id result) {
        XCTFail(@"Success block should not be called.");
        [self finishTest];
    }];
    
    [future addFailureObserverWithBlock:^(NSError *error) {
        XCTAssertEqual(error, error1, @"Error object should be same as rejected one.");
        [self finishTest];
    }];
}

- (void)testRejectAlreadyRejected
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future = promise.future;
    
    NSError *error1 = [self error];
    [promise rejectWithError:error1];
    
    [future addSuccessObserverWithBlock:^(id result) {
        XCTFail(@"Success block should not be called.");
        [self finishTest];
    }];
    
    [future addFailureObserverWithBlock:^(NSError *error) {
        XCTAssertEqual(error, error1, @"Error object should be same as rejected one.");
        [self finishTest];
    }];
}

- (void)testMap
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future1 = promise.future;
    
    XMMMFuture *future2 = [future1 map:^id(id result) {
        return [result stringByAppendingString:@", world!"];
    }];
    
    XCTAssertNotNil(future2, @"Mapped Future should not be nil.");
    
    NSString *str1 = @"Hello";
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise resolveWithObject:str1];
        [self finishTest];
    });
    
    [future2 addSuccessObserverWithBlock:^(id result) {
        XCTAssertEqualObjects(result, @"Hello, world!", @"");
    }];
    
    [future2 addFailureObserverWithBlock:^(NSError *error) {
        XCTFail(@"");
    }];
}

- (void)testMapFailed
{
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future1 = promise.future;
    
    XMMMFuture *future2 = [future1 map:^id(id result) {
        XCTFail(@"");
        return nil;
    }];
    
    XCTAssertNotNil(future2, @"Mapped Future should not be nil.");
    
    NSError *error1 = [self error];
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise rejectWithError:error1];
        [self finishTest];
    });
    
    [future2 addSuccessObserverWithBlock:^(id result) {
        XCTFail(@"");
    }];
    
    [future2 addFailureObserverWithBlock:^(NSError *error) {
        XCTAssertEqual(error, error1, @"");
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
    
    XMMMFuture *composedFuture = [future1 flatMap:^XMMMFuture *(id result) {
        XMMMPromise *promise2 = [XMMMPromise defaultPromise];
        XMMMFuture *future2 = promise2.future;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [promise2 resolveWithObject:[result stringByAppendingString:@", world!"]];
        });
        
        return future2;
    }];
    
    XCTAssertNotNil(composedFuture, @"Composed Future should not be nil.");
    
    [composedFuture addSuccessObserverWithBlock:^(id result) {
        XCTAssertEqualObjects(result, @"Hello, world!", @"");
        [self finishTest];
    }];
    
    [composedFuture addFailureObserverWithBlock:^(NSError *error) {
        XCTFail(@"");
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
    
    XMMMFuture *composedFuture = [future1 flatMap:^XMMMFuture *(id result) {
        XCTFail(@"");
        return nil;
    }];
    
    XCTAssertNotNil(composedFuture, @"Composed Future should not be nil.");
    
    [composedFuture addSuccessObserverWithBlock:^(id result) {
        XCTFail(@"");
        [self finishTest];
    }];
    
    [composedFuture addFailureObserverWithBlock:^(NSError *error) {
        XCTAssertEqualObjects(error, error1, @"");
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
    
    XMMMFuture *composedFuture = [future1 flatMap:^XMMMFuture *(id result) {
        XMMMPromise *promise2 = [XMMMPromise defaultPromise];
        XMMMFuture *future2 = promise2.future;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [promise2 rejectWithError:error1];
        });
        
        return future2;
    }];
    
    XCTAssertNotNil(composedFuture, @"Composed Future should not be nil.");
    
    [composedFuture addSuccessObserverWithBlock:^(id result) {
        XCTFail(@"");
        [self finishTest];
    }];
    
    [composedFuture addFailureObserverWithBlock:^(NSError *error) {
        XCTAssertEqualObjects(error, error1, @"");
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
    
    [composedFuture addSuccessObserverWithBlock:^(id result) {
        XCTAssertEqual(result, obj, @"");
        [self finishTest];
    }];
    
    [composedFuture addFailureObserverWithBlock:^(NSError *error) {
        XCTFail(@"");
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
    
    [composedFuture addSuccessObserverWithBlock:^(id result) {
        XCTAssertEqual(result, obj, @"");
        [self finishTest];
    }];
    
    [composedFuture addFailureObserverWithBlock:^(NSError *error) {
        XCTFail(@"");
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
    
    XMMMFuture *composedFuture = [future1 recoverWith:^XMMMFuture *(NSError *error) {
        XMMMPromise *promise2 = [XMMMPromise defaultPromise];
        XMMMFuture *future2 = promise2.future;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [promise2 resolveWithObject:obj1];
        });
        
        return future2;
    }];
    
    XCTAssertNotNil(composedFuture, @"Composed Future should not be nil.");
    
    [composedFuture addSuccessObserverWithBlock:^(id result) {
        XCTAssertEqual(result, obj1, @"");
        [self finishTest];
    }];
    
    [composedFuture addFailureObserverWithBlock:^(NSError *error) {
        XCTFail(@"");
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
    
    XMMMFuture *composedFuture = [future1 recoverWith:^XMMMFuture *(NSError *error) {
        XCTFail(@"");
        return nil;
    }];
    
    XCTAssertNotNil(composedFuture, @"Composed Future should not be nil.");
    
    [composedFuture addSuccessObserverWithBlock:^(id result) {
        XCTAssertEqual(result, obj1, @"");
        [self finishTest];
    }];
    
    [composedFuture addFailureObserverWithBlock:^(NSError *error) {
        XCTFail(@"");
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
    
    XMMMFuture *composedFuture = [future1 recoverWith:^XMMMFuture *(NSError *error) {
        XMMMPromise *promise2 = [XMMMPromise defaultPromise];
        XMMMFuture *future2 = promise2.future;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [promise2 rejectWithError:error2];
        });
        
        return future2;
    }];
    
    XCTAssertNotNil(composedFuture, @"Composed Future should not be nil.");
    
    [composedFuture addSuccessObserverWithBlock:^(id result) {
        XCTFail(@"");
        [self finishTest];
    }];
    
    [composedFuture addFailureObserverWithBlock:^(NSError *error) {
        XCTAssertEqual(error, error2, @"");
        [self finishTest];
    }];
}

#pragma mark - Helper methods

- (void)finishTest
{
    self.completed = YES;
}

- (NSError *)error
{
    return [NSError errorWithDomain:@"test" code:1 userInfo:nil];
}

@end
