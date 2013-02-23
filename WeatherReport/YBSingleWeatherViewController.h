//
//  YBSingleWeatherViewController.h
//  WeatherReport
//
//  Created by yibin on 13-2-22.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBSingleWeatherViewController : UIViewController

@property (strong,nonatomic) NSDictionary *city;

@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
@property (weak, nonatomic) IBOutlet UILabel *lblDateWeek;
@property (weak, nonatomic) IBOutlet UILabel *lblWeather;
@property (weak, nonatomic) IBOutlet UILabel *lblTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblSD;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;




-(IBAction)ReLoadBind:(id)sender;
//绑定天气
-(void)Bind;


@end
