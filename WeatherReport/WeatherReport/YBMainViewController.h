//
//  YBMainViewController.h
//  WeatherReport
//
//  Created by yibin on 13-2-16.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface YBMainViewController : UIViewController<CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager *locationManager;

@property (retain, nonatomic) IBOutlet UILabel *labelCity;
@property (retain, nonatomic) IBOutlet UILabel *labelUpdateTime;
@property (retain, nonatomic) IBOutlet UILabel *labelTemp;
@property (retain, nonatomic) IBOutlet UILabel *labelSD;
@property (retain, nonatomic) IBOutlet UILabel *labelWeather;
@property (retain, nonatomic) IBOutlet UILabel *labelDate;
@property (retain, nonatomic) IBOutlet UILabel *labelMinMaxTemp;



@property (retain,nonatomic) UIActivityIndicatorView *aiv;
@property (retain,nonatomic) UIButton *btnUpdate;

@property (strong,nonatomic) UIView *LunchView;
@property (strong,nonatomic) UIView *MainView;
@end
