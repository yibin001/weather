//
//  YBSingleWeatherViewController.m
//  WeatherReport
//
//  Created by yibin on 13-2-22.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "YBSingleWeatherViewController.h"
#import "YBWeatherQuery.h"
@interface YBSingleWeatherViewController ()
{
    UIActivityIndicatorView *loadding;
}
@end
@implementation YBSingleWeatherViewController
@synthesize lblCityName = _lblCityName;
@synthesize lblDateWeek = _lblDateWeek;
@synthesize lblWeather = _lblWeather;
@synthesize lblTemp = _lblTemp;
@synthesize lblCurrTemp = _lblCurrTemp;
@synthesize lblSD = _lblSD;
@synthesize lblLastUpdate = _lblLastUpdate;
@synthesize city = _city;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)Bind{
    YBWeatherQuery *query = [[YBWeatherQuery alloc] initWithCityCode:self.city[@"citycode"]];
    NSDictionary *weather_info = [query QueryWeather];
    self.lblDateWeek.text= [NSString stringWithFormat:@"%@ %@", weather_info[@"all"][@"date_y"],weather_info[@"all"][@"week"]];
    self.lblWeather.text=[NSString stringWithFormat:@"%@ %@%@",weather_info[@"sk2"][@"weather"], weather_info[@"sk"][@"WD"],weather_info[@"sk"][@"WS"]];
    
    
    
    int min = MIN([weather_info[@"sk2"][@"temp1"] intValue], [weather_info[@"sk2"][@"temp2"] intValue]);
    int max = MAX([weather_info[@"sk2"][@"temp1"] intValue], [weather_info[@"sk2"][@"temp2"] intValue]);
    self.lblTemp.text= [NSString stringWithFormat:@"最低气温:%d,最高气温:%d",min,max];
    self.lblCurrTemp.text=weather_info[@"sk"][@"temp"];
    
    self.lblCityName.text = [NSString stringWithFormat:@"%@",self.city[@"cityname"]];
    self.lblSD.text = [NSString stringWithFormat:@"湿度:%@" ,weather_info[@"sk"][@"SD"]];
    //[self.btnUpdate setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    self.lblLastUpdate.text = [NSString stringWithFormat:@"更新于%@ %@",weather_info[@"all"][@"date_y"], weather_info[@"sk"][@"time"]];
    self.lblLastUpdate.frame = CGRectMake(30, self.view.frame.size.height-30, 300, 20);
    self.lblLastUpdate.textAlignment = NSTextAlignmentLeft;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    btn.frame = CGRectMake(10, self.view.frame.size.height-30, 20, 20);
    btn.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:btn];
        
    
    //[self.lblLastUpdate sizeToFit];
    [loadding stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    loadding = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   
    loadding.frame = CGRectMake(10, self.view.frame.size.height-30, 20, 20);
    self.lblLastUpdate.text=@"正在更新......";
    [loadding startAnimating];
    [self.view addSubview:loadding];
    NSLog(@"%@ updated",self.city[@"cityname"]);
    //[self performSelector:@selector(Bind) withObject:self afterDelay:0.5];
    //[self performSelector:@selector(Bind) withObject:self];
   // [self performSelector:@selector(Bind) onThread:[NSThread mainThread] withObject:self waitUntilDone:NO];
    [self performSelectorInBackground:@selector(Bind) withObject:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblCityName:nil];
    [self setLblDateWeek:nil];
    [self setLblWeather:nil];
    [self setLblTemp:nil];
    [self setLblCurrTemp:nil];
    [self setLblSD:nil];
    [self setLblLastUpdate:nil];
    [super viewDidUnload];
}
@end
