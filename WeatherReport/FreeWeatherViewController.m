//
//  FreeWeatherViewController.m
//  WeatherReport
//
//  Created by yibin on 13-4-21.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "FreeWeatherViewController.h"
#import <MapKit/MapKit.h>
#import "UIImageView+AFNetworking.h"
#import "WeatherDetail.h"
#import "TodayWeather.h"
@interface FreeWeatherViewController ()
@property CLLocationManager *LocationManager;
@property CLLocationCoordinate2D CCLC;
@property NSMutableDictionary  *Weather;
@end

@implementation FreeWeatherViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
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
    NSLog(@"%@",err);
}
-(void)LoadWeather{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:WORLD_WEATHER_QUERY_URI,self.CCLC.latitude,self.CCLC.longitude]];
    self.TodayWeather = [[TodayWeather alloc] init];
    
    
    
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    self.Weather = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil][@"data"];
    self.TodayWeather.Weather = self.Weather[@"current_condition"][0];
    [self.view addSubview:self.TodayWeather];

    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    
    self.CCLC = newLocation.coordinate;
    
    [self.LocationManager stopUpdatingLocation];
    
    
    [self LoadWeather];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.LocationManager = [[CLLocationManager alloc] init];
    self.LocationManager.delegate = self;
    self.LocationManager.distanceFilter = 1000.0f;
    self.LocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.LocationManager.distanceFilter = kCLHeadingFilterNone;
    [self.LocationManager startUpdatingLocation];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}
@end
