//
//  XMMMAsyncTestCase.m
//  XMMMFuture
//
//  Created by kakegawa.atsushi on 2013/10/25.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMAsyncTestCase.h"

@interface XMMMAsyncTestCase ()

@property (atomic) BOOL completed;

@end

@implementation XMMMAsyncTestCase

- (void)setUp
{
    [super setUp];
    
    self.completed = NO;
}

- (void)tearDown
{
    double delayInSeconds = self.timeoutDuration;
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

- (void)finishTest
{
    self.completed = YES;
}

@end
