//
//  YBWeatherQuery.h
//  WeatherReport
//
//  Created by yibin on 13-2-19.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface YBWeatherQuery : NSObject
{
    NSString *cityCode;
}
@property (strong,nonatomic) NSDictionary *google_location;


-(id)initWithCityCode:(NSString *)_cityCode;
-(NSDictionary *)QueryWeather;
-(NSDictionary *)LoadWeatherFromLocal;
-(void)SaveWeatherToLocal:(NSDictionary *)Weather;
-(NSDictionary *)QueryAddress:(CLLocationDegrees)lat lng:(CLLocationDegrees)lng;
@end
