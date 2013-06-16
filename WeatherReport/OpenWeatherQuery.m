//
//  OpenWeatherQuery.m
//  WeatherReport
//
//  Created by yibin on 13-6-14.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "OpenWeatherQuery.h"


@implementation OpenWeatherQuery
-(NSDictionary *)QueryWeather:(CLLocationDegrees)lat lng:(CLLocationDegrees)lng{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:OPEN_WEATHER_API,lat,lng]];
    
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if ([json[@"cod"] intValue]==200) {
        return json;
    }
    return nil;
}


-(NSDictionary *)QueryWeatherByCity:(NSString *)City{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:OPEN_WEATHER_BY_CITYNAME_API ,[City lowercaseString]]];
    
    
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if ([json[@"cod"] intValue]==200) {
        return json;
    }
    return nil;
}
@end
