//
//  MapKitViewController.h
//  WeatherReport
//
//  Created by yibin on 13-5-26.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapPoint.h"

@interface MapKitViewController : UIViewController <CLLocationManagerDelegate> {
    MKMapView *mapView;
    CLLocationManager *locationManager;
    MapPoint* marsPoint;
    MapPoint* wgsPoint;
    UILabel *LblAddress;
}

@end
