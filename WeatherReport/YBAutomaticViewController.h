//
//  YBAutomaticViewController.h
//  WeatherReport
//
//  Created by yibin on 13-2-28.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface YBAutomaticViewController : UIViewController<CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager *locationManager;
@property  CLLocationCoordinate2D CurrentLocaltion;


@property (weak, nonatomic) IBOutlet UILabel *lblTemp;
@property (weak, nonatomic) IBOutlet UIImageView *imgWeather;
@property (weak, nonatomic) IBOutlet UILabel *lblMinMaxTemp;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *AviLoadding;
@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDegree;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocationIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblWeather;

@property (weak, nonatomic) IBOutlet UILabel *lblSD;

/*
@property (weak,nonatomic)UIImage *imgDay0;
@property (weak,nonatomic)UIImage *imgDay1;
@property (weak,nonatomic)UIImage *imgDay2;
@property (weak,nonatomic)UIImage *imgDay3;



@property (weak,nonatomic)UILabel *lblDay0;
@property (weak,nonatomic)UILabel *lblDay1;
@property (weak,nonatomic)UILabel *lblDay2;
@property (weak,nonatomic)UILabel *lblDay3;
 */
@end
