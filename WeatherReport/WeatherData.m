//
//  WeatherData.m
//  WeatherReport
//
//  Created by yibin on 13-6-15.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "WeatherData.h"
#define WEATHER_SOURCE_KEY @"WeatherSource"
@implementation WeatherData
+(NSInteger)LoadSource{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud integerForKey:WEATHER_SOURCE_KEY];
}

+(void)SetSource:(NSInteger)SourceID{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:SourceID forKey:WEATHER_SOURCE_KEY];
}
@end
