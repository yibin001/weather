//
//  OpenWeatherQuery.h
//  WeatherReport
//
//  Created by yibin on 13-6-14.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface OpenWeatherQuery : NSObject
-(NSDictionary *)QueryWeather:(CLLocationDegrees )lat lng:(CLLocationDegrees )lng;
-(NSDictionary *)QueryWeatherByCity:(NSString *)City;
@end
