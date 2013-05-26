//
//  MapKitViewController.m
//  WeatherReport
//
//  Created by yibin on 13-5-26.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "MapKitViewController.h"
#include "convert.h"
#import "YBWeatherQuery.h"
@interface MapKitViewController ()
{
    YBWeatherQuery *GoogleQuery;
}
@end

@implementation MapKitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GoogleQuery = [[YBWeatherQuery alloc] init];
   
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    //    mapView.mapType = MKMapTypeHybrid;
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    LblAddress = [[UILabel alloc ] initWithFrame:CGRectMake(0, 405, 320, 50)];
    LblAddress.numberOfLines = 0;
    LblAddress.font = [UIFont systemFontOfSize:12];
    LblAddress.tag = 1;
    LblAddress.userInteractionEnabled=YES;
    [self.view addSubview:LblAddress];
    
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.delegate = self;
        locationManager.distanceFilter = 50.0f;
        [locationManager startUpdatingLocation];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view.tag==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    CLLocationCoordinate2D marsCoordinate = transform(coordinate);
    
    
    if (wgsPoint) {
        [wgsPoint setCoordinate:coordinate];
    } else {
        wgsPoint = [[MapPoint alloc] initWithCoordinate:coordinate];
        [mapView addAnnotation:wgsPoint];
    }
    
    if (marsPoint) {
        [marsPoint setCoordinate:marsCoordinate];
        [mapView setCenterCoordinate:marsCoordinate animated:YES];
    } else {
        marsPoint = [[MapPoint alloc] initWithCoordinate:marsCoordinate];
        [mapView addAnnotation:marsPoint];
        mapView.region = MKCoordinateRegionMakeWithDistance(marsCoordinate, 100, 100);
    }
    NSDictionary *dict = [GoogleQuery QueryAddress:marsCoordinate.latitude lng:marsCoordinate.longitude];
    
    [locationManager stopUpdatingLocation];
    if([dict[@"status"] isEqualToString:@"OK"]){
        LblAddress.text = dict[@"results"][0][@"formatted_address"];
    
    }
    
}

- (void)viewDidUnload {
    mapView = nil;
    wgsPoint = nil;
    marsPoint = nil;
    locationManager.delegate = nil;
    locationManager = nil;
    LblAddress = nil;
}

@end
