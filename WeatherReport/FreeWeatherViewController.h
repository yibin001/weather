//
//  FreeWeatherViewController.h
//  WeatherReport
//
//  Created by yibin on 13-4-21.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface FreeWeatherViewController : UIViewController<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *LabelCity;
@property (weak, nonatomic) IBOutlet UILabel *LabelWeather;

@end
