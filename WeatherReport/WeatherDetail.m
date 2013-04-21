//
//  WeatherDetail.m
//  WeatherReport
//
//  Created by yibin on 13-4-21.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "WeatherDetail.h"

@interface WeatherDetail()
{
    UILabel *LabelShidu;
    UILabel *LabelWind;
    UILabel *LabelTemp;
    UILabel *LabelVisibility;
    UILabel *LabelCloud;
}
@end


@implementation WeatherDetail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)Render{
    LabelWind = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    LabelWind.backgroundColor = [UIColor clearColor];
    LabelWind.text = [NSString stringWithFormat:@"风向：%@，风速：%@km/h", self.TodayWeather[@"winddir16Point"],self.TodayWeather[@"windspeedKmph"]];
    LabelShidu = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 200, 20)];
    LabelShidu.text  =[NSString stringWithFormat:@"湿度：%@%%",self.TodayWeather[@"humidity"]];
    LabelShidu.backgroundColor = [UIColor clearColor];
    LabelTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 200, 20)];
    LabelTemp.text  = [NSString stringWithFormat:@"当前气温：%@℃", self.TodayWeather[@"temp_C"]];
    LabelTemp.backgroundColor = [UIColor clearColor];
    LabelVisibility = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 200, 20)];
    LabelVisibility.text = [NSString stringWithFormat:@"能见度：%@ 米",self.TodayWeather[@"visibility"]];
    LabelVisibility.backgroundColor = [UIColor clearColor];
    LabelCloud  = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 200, 20)];
    LabelCloud.text = [NSString stringWithFormat:@"天空云量：%@%%",self.TodayWeather[@"cloudcover"]];
    LabelCloud.backgroundColor = [UIColor clearColor];
    [self addSubview:LabelCloud];
    [self addSubview:LabelVisibility];
    [self addSubview:LabelTemp];
    [self addSubview:LabelShidu];
    [self addSubview:LabelWind];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
