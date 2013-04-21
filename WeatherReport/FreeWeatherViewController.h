//
//  FreeWeatherViewController.h
//  WeatherReport
//
//  Created by yibin on 13-4-21.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TodayWeather.h"
@interface FreeWeatherViewController : UIViewController<CLLocationManagerDelegate,UIScrollViewDelegate>

@property (strong,nonatomic) UIScrollView *ScrollView;


@end
