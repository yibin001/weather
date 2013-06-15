//
//  OpenWeatherViewController.m
//  WeatherReport
//
//  Created by yibin on 13-6-14.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "OpenWeatherViewController.h"
#import "OpenWeatherQuery.h"
#import "AFNetworking/AFImageRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "convert.h"
#import "YBWeatherQuery.h"
#import "YBUtils.h"
#import "POAPinyin.h"
#import <QuartzCore/QuartzCore.h>
#define OPEN_WEATHER_API_ICON @"http://openweathermap.org/img/w/%@.png"

@interface OpenWeatherViewController ()
{
    UIFont *font;
    NSDictionary *locationInfo;
    NSDictionary *simpleLocationInfo;
}
@end

@implementation OpenWeatherViewController




-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self.locationManager stopUpdatingLocation];
    NSString *err;
    switch([error code])
    {
        case kCLErrorNetwork:
        {
            err = @"please check your network connection or that you are not in airplane mode" ;
            break;
        }
        case kCLErrorDenied:{
            err =@"请去设置中允许\"简约天气\"使用定位服务\nLocation service is disabled";
            break;
        }
        default:
        {
            err=@"unknown network error";
            break;
        }
    }
     
    [SVProgressHUD showErrorWithStatus:err];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    self.currentLocation = transform([newLocation coordinate]);
    
    [self.locationManager stopUpdatingLocation];
       
    
    
    [self LoadWeather];
}

-(void)LoadWeather{
    OpenWeatherQuery *query = [[OpenWeatherQuery alloc] init];
    YBWeatherQuery *_query = [[YBWeatherQuery alloc] init];
    
    locationInfo =  [_query QueryAddress:(self.currentLocation.latitude) lng:self.currentLocation.longitude];
    simpleLocationInfo = [YBUtils ConvertToSimpleCity:locationInfo];
    
    NSString *_citycode = [POAPinyin convert:simpleLocationInfo[@"city"]];
    
    //self.Weather= [query QueryWeather:self.currentLocation.latitude lng:self.currentLocation.longitude];
    self.Weather = [query QueryWeatherByCity:_citycode];
    [self InitControls];
    
}
-(void)InitControls{
    
    UILabel *cityname = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 320.0f, 20.0f)];
    cityname.text = [NSString stringWithFormat:@"%@",simpleLocationInfo[@"city"]];
    cityname.tag = 1;
    cityname.textAlignment = NSTextAlignmentCenter;
    cityname.font = [UIFont systemFontOfSize:20.0f];
       
    
    UIView *todayView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 320, 200)];
    
    
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 10.0f, 200.0f, 50.0f)];
    description.tag = 0;
    description.font = [UIFont systemFontOfSize:25.0f];
    
    
    
    
    
    
    
    
    NSDictionary *today = self.Weather[@"list"][0];
    
    description.text = today[@"weather"][0][@"description"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 50.0f, 50.0f)];
    NSString *imgurl = [NSString stringWithFormat:OPEN_WEATHER_API_ICON,today[@"weather"][0][@"icon"]];
    [imageView setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
    imageView.tag = 100;
    
    
    
    UILabel *currTemp = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 60.0f, 300.0f, 20.0f)];
    currTemp.text = [NSString stringWithFormat:@"最低气温:%d℃,最高气温:%d℃",[today[@"temp"][@"min"] integerValue],[today[@"temp"][@"max"] integerValue]];
    currTemp.tag = 2;
    currTemp.font = font;
    UILabel *pressure = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 90.0f, 300.0f, 20.0f)];
    pressure.text = [NSString stringWithFormat:@"气压:%@,云量:%@%%",today[@"pressure"],today[@"clouds"]];
    pressure.tag = 3;
    pressure.font = font;
    
    
    UILabel *humidity = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 120.0f, 320.0f, 20.0f)];
    humidity.text = [NSString stringWithFormat:@"湿度:%@%%",today[@"humidity"]];
    humidity.tag = 4;
    humidity.font = font;
    
    UILabel *speed = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 150.0f, 320.0f, 20.0f)];
    speed.text = [NSString stringWithFormat:@"风速:%@千米/小时",today[@"speed"]];
    speed.tag = 5;
    speed.font = font;
    
    
    UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 460.0-50.0, 300.0f, 20.0f)];
    location.font = [UIFont systemFontOfSize:12];
    location.text = [NSString stringWithFormat:@"当前位置:%@" , [YBUtils ConvertToSimpleCity:locationInfo][@"address"]];
     
    location.tag = 6;
    
    [todayView sizeToFit];
    [todayView addSubview:location];
    [todayView addSubview:speed];
    [todayView addSubview:humidity];
    [todayView addSubview:pressure];
    [todayView addSubview:currTemp];
    [todayView addSubview:description];
    [todayView addSubview:imageView];
    [self.view addSubview:cityname];
    
    [self.view addSubview:todayView];
   
    
    
//    todayView.layer.borderWidth = 1;
//    todayView.layer.cornerRadius = 5;
//    todayView.layer.masksToBounds=YES;
    
    //渲染未来3天的天气
    NSArray *moreWeather = self.Weather[@"list"];
    UIFont *smallFont = [UIFont systemFontOfSize:13.0f];
    for (int i=1; i<4; i++) {
        CGRect frame = CGRectMake(10.0f, 250.0f, 93.0f, 120.0f);
        if (i>1) {
            frame.origin.x = (93.0+20.f)*(i-1);// 93.0f*(i-1)+20.0f*(i-1);
            if(i==3)
                frame.origin.x-=10.0f;
        }
        
        UIView *view = [[UIView alloc] init];
        
        view.frame = frame;
        
        UILabel *lbldate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 93.0, 15.0f)];
        lbldate.font =smallFont;
        lbldate.textAlignment = NSTextAlignmentCenter;
        
        NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
        [nsdf2 setDateStyle:NSDateFormatterShortStyle];
        [nsdf2 setDateFormat:@"YYYY-MM-dd"];
        
        NSDate *currdate = [[NSDate alloc] initWithTimeIntervalSinceNow:i*24*60*60];
        
        lbldate.text =  [nsdf2 stringFromDate:currdate];
        [view addSubview:lbldate];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 50.0f, 50.0f)];
        NSString *imgurl = [NSString stringWithFormat:OPEN_WEATHER_API_ICON,moreWeather[i][@"weather"][0][@"icon"]];
        [imageView setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
        [view addSubview:imageView];
        
        
        UILabel *day = [[UILabel alloc] init];
        day.frame = CGRectMake(0, 72.0f, 93, 20);
        day.backgroundColor = [UIColor whiteColor];
        day.textAlignment = NSTextAlignmentCenter;
        day.font =smallFont;
        day.text = moreWeather[i][@"weather"][0][@"description"];
        
        UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(0, 95.0f, 93, 20)];
        temp.textAlignment = NSTextAlignmentCenter;
        temp.font = smallFont;
        temp.text = [NSString stringWithFormat:@"%d℃-%d℃",[moreWeather[i][@"temp"][@"min"] integerValue],[moreWeather[i][@"temp"][@"max"] integerValue]];
        [view addSubview:temp];
       
        
        [view addSubview:day];
        [self.view addSubview:view];
    }
    
    
    
    
    [SVProgressHUD dismiss];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"正在加载......"];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    font = [UIFont systemFontOfSize:16.0f];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
