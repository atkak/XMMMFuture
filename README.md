https://travis-ci.org/xiongmaomaomao/XMMMFuture.png?branch=master

#XMMMFuture
XMMMFuture is the Objective-C implementation of the Future - Promise pattern. The Future object encapsulates a result of calculation in the future, and it makes possible to a composition of calculation.

##Installation with CocoaPods
Add XMMMFuture to your Podfile.

```
pod 'XMMMFuture', :git => 'https://github.com/xiongmaomaomao/XMMMFuture.git'
```

##Requirement

- iOS 5 or later
- ARC

##Usage
###Create Future for asynchronous calculation

The `XMMMCreateFutureWithPromiseBlock` function creates a Future object with a block which has a Promise object with arguments.

``` objective-c
XMMMFuture *future = XMMMCreateFutureWithPromiseBlock(^(XMMMPromise *promise) {
    // async calculation
});
```

You can also obtain a Future object from a Promise object which manages it.

``` objective-c
XMMMPromise *promise = [XMMMPromise defaultPromise];
XMMMFuture *future = promise.future;
```

###Create Future for synchronous long calculation

This feature will be supported in future releases.

###Handle results of calculation

``` objective-c
[future success:^(id result) {
    // When calculation succeeds, this block is called.
} failure:^(NSError *error) {
    // When calculation fails, this block is called.
} completed:^{
    // When calculation completes, this block is called, regardless of success or failure.
}];
```

###Complete a calculation 

XMMMPromise has the method `resolveWithObject:` which lets a calculation success.

``` objective-c
XMMMFuture *future = XMMMCreateFutureWithPromiseBlock(^(XMMMPromise *promise) {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [promise resolveWithObject:@"Foo"];
    });
});

// Print "Foo" after 2 second delay
[future success:^(id result) {
    NSLog(result); 
} failure:nil completed:nil];
```

XMMMPromise also has the method `rejectWithError:` which lets a calculation failure.

``` objective-c
XMMMFuture *future = XMMMCreateFutureWithPromiseBlock(^(XMMMPromise *promise) {
    // Simulates an asynchronous calculation
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [promise rejectWithError:error];
    });
});

// Print error description after 2 second delay
[future success:nil failure:^(NSError *error) {
    NSLog(@"%@", error.localizedDescription);
} completed:nil];
```

###Map a result

``` objective-c
XMMMFuture *future = XMMMCreateFutureWithPromiseBlock(^(XMMMPromise *promise) {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [promise resolveWithObject:@"Hello"];
    });
});

XMMMFuture *mappedFuture = [future map:^id(id result) {
    return [result stringByAppendingString:@", world!"];
}];

[future success:^(id result) {
    NSLog(result); // Hello, world!
} failure:nil completed:nil];
```

###Map a result to asynchronous calculation

``` objective-c
XMMMFuture *future = XMMMCreateFutureWithPromiseBlock(^(XMMMPromise *promise) {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [promise resolveWithObject:@"Hello"];
    });
});

XMMMFuture *composedFuture = [future mapWithPromise:^void (id result, XMMMPromise *promise) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise resolveWithObject:[result stringByAppendingString:@", world!"]];
    });
}];

[composedFuture success:^(id result) {
    NSLog(result); // Hello, world!
} failure:nil completed:nil];
```

###Recover an error and map a result

``` objective-c
XMMMFuture *future = XMMMCreateFutureWithPromiseBlock(^(XMMMPromise *promise) {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [promise rejectWithError:error];
    });
});

XMMMFuture *composedFuture = [future recover:^id(NSError *error) {
    return @"Recovered!";
}];

[future success:^(id result) {
    NSLog(result); // Recovered!
} failure:nil completed:nil];
```

###Recover an error and map a result to asynchronous calculation

``` objective-c
XMMMFuture *future = XMMMCreateFutureWithPromiseBlock(^(XMMMPromise *promise) {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [promise rejectWithError:error];
    });
});

XMMMFuture *composedFuture = [future recoverWithPromise:^void (NSError *error, XMMMPromise *promise) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [promise resolveWithObject:@"Recovered!"];
    });
}];

[composedFuture success:^(id result) {
    NSLog(result); // Recovered!
} failure:nil completed:nil];
```

##License
This software is released under the MIT License, see LICENSE.txt.
