//
//  FreeWeatherViewController.m
//  WeatherReport
//
//  Created by yibin on 13-4-21.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "FreeWeatherViewController.h"
#import <MapKit/MapKit.h>
@interface FreeWeatherViewController ()
@property CLLocationManager *LocationManager;
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

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    
    
    NSLog(@"%@",newLocation);
    
    [self.LocationManager stopUpdatingLocation];
    NSLog([NSString stringWithFormat:WORLD_WEATHER_QUERY_URI,newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
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
    NSLog(@"start");
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLabelCity:nil];
    [self setLabelWeather:nil];
    [super viewDidUnload];
}
@end
