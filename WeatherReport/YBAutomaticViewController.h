//
//  YBAutomaticViewController.h
//  WeatherReport
//
//  Created by yibin on 13-2-28.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
@interface YBAutomaticViewController : UIViewController<CLLocationManagerDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *HUD;
}
@property (strong,nonatomic) CLLocationManager *locationManager;
@property  CLLocationCoordinate2D CurrentLocaltion;


@property (weak, nonatomic) IBOutlet UILabel *lblTemp;
@property (weak, nonatomic) IBOutlet UIImageView *imgWeather;
@property (weak, nonatomic) IBOutlet UILabel *lblMinMaxTemp;

@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDegree;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocationIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblWeather;

@property (weak, nonatomic) IBOutlet UILabel *lblIntro;

@property (weak, nonatomic) IBOutlet UILabel *lblPM25;


@end
