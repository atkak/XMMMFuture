//
//  XMMMViewController.m
//  XMMMFutureExample
//
//  Created by KAKEGAWA Atsushi on 2013/11/09.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMViewController.h"
#import "XMMMWeatherService.h"

@interface XMMMViewController ()

@property (nonatomic) XMMMWeatherService *weatherService;

@end

@implementation XMMMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.weatherService = [XMMMWeatherService new];
    
    XMMMFuture *future = [self.weatherService weatherDataForCity:XMMMWeatherServiceCityTokyo];
    [future success:^(id result) {
        NSLog(@"%@", result);
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    } completed:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
