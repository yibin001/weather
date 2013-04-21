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
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:WORLD_WEATHER_QUERY_URI,self.CCLC.latitude,self.CCLC.longitude]];
        
        
        
        
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
        self.Weather = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil][@"data"];
        
       dispatch_async(dispatch_get_main_queue(), ^{
           self.LabelWeather.text = self.Weather[@"current_condition"][0][@"weatherDesc"][0][@"value"];
           [self.ImageViewWeather setImageWithURL:[NSURL URLWithString:self.Weather[@"current_condition"][0][@"weatherIconUrl"][0][@"value"]] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
           CGRect frame = self.LabelWeather.frame;
           frame.origin.y+=30;
           frame.size = CGSizeMake(320, 50);
           
           WeatherDetail *detail = [[WeatherDetail alloc] initWithFrame:frame];
          
           
           self.LabelReportTime.text = [NSString stringWithFormat:@"发布时间：%@",self.Weather[@"current_condition"][0][@"observation_time"]];
           
           self.LabelReportTime.frame = CGRectMake(frame.origin.x, 380, 200, 20);
           detail.TodayWeather = self.Weather[@"current_condition"][0];
           
           [detail Render];
           [self.view addSubview:detail];
       });
    });
    
    
    
    
    
    

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
    [self setLabelCity:nil];
    [self setLabelWeather:nil];
    [self setImageViewWeather:nil];
    [self setLabelReportTime:nil];
    [super viewDidUnload];
}
@end
