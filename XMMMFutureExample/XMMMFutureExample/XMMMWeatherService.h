//
//  XMMMWeatherService.h
//  XMMMFutureExample
//
//  Created by KAKEGAWA Atsushi on 2013/11/09.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMMMFuture/XMMMFutureHeader.h>

typedef NS_ENUM(NSInteger, XMMMWeatherServiceCity) {
    XMMMWeatherServiceCityTokyo,
    XMMMWeatherServiceCityYokohama
};

@interface XMMMWeatherService : NSObject

- (XMMMFuture *)weatherDataForCity:(XMMMWeatherServiceCity)city;

@end
