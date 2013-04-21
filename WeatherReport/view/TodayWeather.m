//
//  TodayWeather.m
//  WeatherReport
//
//  Created by yibin on 13-4-21.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "TodayWeather.h"
#import "UIImageView+AFNetworking.h"
#import "WeatherDetail.h"
@implementation TodayWeather
@synthesize Weather = _Weather;


-(void)setWeather:(NSDictionary *)Weather{
    NSLog(@"%@",Weather);
    if(_Weather!=Weather)
    {
        _Weather = Weather;
    }
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"TodayWeather"
                                                          owner:self
                                                        options:nil];
        self = nibViews[0];
        NSLog(@"haha");
        
    }
    return self;
}


-(void)Render{
    
    self.LabelWeather.text = self.Weather[@"weatherDesc"][0][@"value"];
    [self.ImageViewWeather setImageWithURL:[NSURL URLWithString:self.Weather[@"weatherIconUrl"][0][@"value"]] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
    CGRect frame = self.LabelWeather.frame;
    frame.origin.y+=30;
    frame.size = CGSizeMake(320, 50);
    
    WeatherDetail *detail = [[WeatherDetail alloc] initWithFrame:frame];
    
    
    
    detail.TodayWeather = self.Weather;
    
    [detail Render];
    [self addSubview:detail];
    
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
