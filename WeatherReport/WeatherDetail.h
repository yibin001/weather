//
//  WeatherDetail.h
//  WeatherReport
//
//  Created by yibin on 13-4-21.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDetail : UIView




@property (strong,nonatomic) NSDictionary *TodayWeather;
-(void)Render;
@end
