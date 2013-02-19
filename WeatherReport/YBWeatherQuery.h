//
//  YBWeatherQuery.h
//  WeatherReport
//
//  Created by yibin on 13-2-19.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBWeatherQuery : NSObject
-(NSDictionary *)QueryWeather:(NSString *) WithCityCode;
@end
