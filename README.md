#XMMMFuture
XMMMFuture is the Objective-C implementation of Future-Promise pattern. Future encapsulates the results of calculation in the future, and it makes possible to the composition of calculation.

##Installation with CocoaPods
Add XMMMFuture to your Podfile.

``` objective-c
pod 'XMMMFuture'
```

Run CocoaPods.

``` objective-c
$ pod install
```

##Requirement

- iOS 5 or later
- ARC

##Usage
###Create Future

`XMMMCreateFutureWithPromiseBlock` function creates Future object.

``` objective-c
XMMMFuture *future = XMMMCreateFutureWithPromiseBlock(^(XMMMPromise *promise) {
    // async process
});
```

You can also retrieve Future by creating Promise which owns Future. 

``` objective-c
XMMMPromise *promise = [XMMMPromise defaultPromise];
XMMMFuture *future = promise.future;
```

###Handle results of the calculation

``` objective-c
[future success:^(id result) {
    // When calculation succeeds, this block is called.
} failure:^(NSError *error) {
    // When calculation fails, this block is called.
} completed:^{
    // When calculation completes, this block is called, regardless of success or failure.
}];
```

###Complete the calculation 
XMMMPromise has a method `resolveWithObject:' and it lets a calculation success.

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

XMMMPromise also has a method `rejectWithError:' and it lets a calculation failure.

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

###Map the result

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

###Map the result to asynchronous calculation

``` objective-c
XMMMFuture *future = XMMMCreateFutureWithPromiseBlock(^(XMMMPromise *promise) {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [promise resolveWithObject:@"Hello"];
    });
});

XMMMFuture *composedFuture = [future flatMap:^XMMMFuture *(id result) {
    XMMMPromise *innerPromise = [XMMMPromise defaultPromise];
    XMMMFuture *innerFuture = innerPromise.future;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [innerPromise resolveWithObject:[result stringByAppendingString:@", world!"]];
    });
    
    return innerFuture;
}];

[composedFuture success:^(id result) {
    NSLog(result); // Hello, world!
} failure:nil completed:nil];
```


