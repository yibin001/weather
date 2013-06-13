//
//  YBWeatherQuery.m
//  WeatherReport
//
//  Created by yibin on 13-2-19.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//
#define SK_URL  @"http://www.weather.com.cn/data/sk/%@.html"
#define SK2_URL @"http://www.weather.com.cn/data/cityinfo/%@.html"
#define ALL_URL @"http://m.weather.com.cn/data/%@.html"


#define GOOGLE_MAP_API @"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true"
#define BAIDU_MAP_API @"http://api.map.baidu.com/geocoder/v2/?ak=CCb2bb072cc0a8fa208bee76622e52ab&location=%f,%f&output=json&pois=0"
#define TENCENT_WEATHER_API @"http://sou.qq.com/online/get_weather.php?city=%@"
#define OPEN_WEATHER_API_ICON @"http://openweathermap.org/img/w/%s.png"
#define OPEN_WEATHER_API @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&mode=json&units=metric&cnt=6&lang=zh_cn"

#import "YBWeatherQuery.h"
#import <MapKit/MapKit.h>
#import "AFJSONRequestOperation.h"



@interface  YBWeatherQuery()
{
    NSDictionary *location;
}
@end

@implementation YBWeatherQuery


-(NSDictionary *)QueryAddressByBaiDuAPI:(CLLocationCoordinate2D)geolocation{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:BAIDU_MAP_API,geolocation.latitude,geolocation.longitude]];
    NSLog(@"%@",url);
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    return json;
}

-(NSDictionary *)QueryAddress:(CLLocationDegrees )lat lng:(CLLocationDegrees )lng{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:GOOGLE_MAP_API,lat,lng]];
    //NSLog(OPEN_WEATHER_API,lat,lng);
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
       return json;
    
}

-(id)initWithCityCode:(NSString *)_cityCode{
    cityCode = _cityCode;
    return self;
}


-(id)initWithCityName:(NSString *)_cityName{
    cityName = _cityName;
    return self;
}



-(NSDictionary *)QueryByCityName{    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:TENCENT_WEATHER_API,cityName]];
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return json;
}

-(NSDictionary *)QueryByCityCode{
    
   
    
    NSDictionary *weather_info = nil;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:SK_URL,cityCode]];
   
      
    
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *sk =   json[@"weatherinfo"];
    url = [NSURL URLWithString:[NSString stringWithFormat:SK2_URL,cityCode]];
    
    data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *sk2 = json[@"weatherinfo"];
    
    url = [NSURL URLWithString:[NSString stringWithFormat:ALL_URL,cityCode]];
    NSLog(@"%@",url);
    data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *all = json[@"weatherinfo"];
    weather_info = @{@"sk":sk,@"sk2":sk2,@"all":all};
    return weather_info;
}

-(NSDictionary *)LoadWeatherFromLocal{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return (NSDictionary *)[ud objectForKey:LOCAL_WEATHER_KEY];
    
}
-(void)SaveWeatherToLocal:(NSDictionary *)Weather{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:Weather forKey:LOCAL_WEATHER_KEY];
}
-(NSDictionary *)QueryWeather{
    if (cityCode!=nil) {
        return [self QueryByCityCode];
    }
    return [self QueryByCityName];
}

@end
