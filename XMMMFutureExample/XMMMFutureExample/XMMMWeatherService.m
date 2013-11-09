//
//  XMMMWeatherService.m
//  XMMMFutureExample
//
//  Created by KAKEGAWA Atsushi on 2013/11/09.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMWeatherService.h"
#import <AFNetworking/AFNetworking.h>

@implementation XMMMWeatherService

- (XMMMFuture *)weatherDataForCity:(XMMMWeatherServiceCity)city
{
    NSString *cityName;
    
    switch (city) {
        case XMMMWeatherServiceCityTokyo:
            cityName = @"tokyo,jp";
            break;
        case XMMMWeatherServiceCityYokohama:
            cityName = @"yokohamo,jp";
            break;
        default:
            NSAssert(NO, @"Invalid city: %d", city);
            break;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?q=%@", cityName];
    
    XMMMPromise *promise = [XMMMPromise defaultPromise];
    XMMMFuture *future = promise.future;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [responseObject[@"cod"] integerValue];
        if (code == 200) {
            [promise resolveWithObject:responseObject];
        } else {
            NSString *message = responseObject[@"message"];
            NSDictionary *userInfo = nil;
            if (message) {
                userInfo = @{NSLocalizedDescriptionKey: message};
            }
            
            NSError *error = [NSError errorWithDomain:@"XMMMWeatherServiceErrorDomain"
                                                 code:code
                                             userInfo:userInfo];
            
            [promise rejectWithError:error];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [promise rejectWithError:error];
    }];
    
    return future;
}

@end
