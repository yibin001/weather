//
//  Const.h
//  WeatherReport
//
//  Created by yibin on 13-4-9.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Const : NSObject


@end
#define LOCAL_WEATHER_KEY @"localweather"

#define WORLD_WEATHER_QUERY_URI @"http://api.worldweatheronline.com/free/v1/weather.ashx?q=%f,%f&format=json&num_of_days=5&key=c5m35zscghrj2subhpx537fk"



#define OPEN_WEATHER_API @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&mode=json&units=metric&cnt=4&lang=zh_cn"
#define OPEN_WEATHER_BY_CITYNAME_API @"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&mode=json&units=metric&cnt=4&lang=zh_cn"
#define OPEN_WEATHER_CURR_API @"http://api.openweathermap.org/data/2.5/weather?q=%@&lang=zh_cn&&units=metric"


#define OPEN_WEATHER_API_ICON @"http://openweathermap.org/img/w/%@.png"

#define ISDEBUG YES
#define DEBUG_CITY_CODE @"101021000"
#define DEFAULT_CITY_CODE @"101010300"
#define DEFAULT_CITY_NAME @"BeiJing,China"

#define PM25_API @"http://pm25api.sinaapp.com/city/%@.json"

//提示信息
#define Updating @"正在更新..."