//
//  OpenWeatherViewController.h
//  WeatherReport
//
//  Created by yibin on 13-6-14.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface OpenWeatherViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

@property  CLLocationCoordinate2D currentLocation;
@property (nonatomic,strong) NSDictionary *Weather;
@end
