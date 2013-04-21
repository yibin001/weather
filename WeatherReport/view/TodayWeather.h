//
//  TodayWeather.h
//  WeatherReport
//
//  Created by yibin on 13-4-21.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayWeather : UIView
@property (weak, nonatomic) IBOutlet UILabel *LabelCityName;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewWeather;

@property (weak, nonatomic) IBOutlet UILabel *LabelWeather;



@property (strong,nonatomic) NSDictionary *Weather;

-(void)Render;
@end
