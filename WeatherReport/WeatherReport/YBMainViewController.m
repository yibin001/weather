//
//  YBMainViewController.m
//  WeatherReport
//
//  Created by yibin on 13-2-16.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "YBMainViewController.h"
#import "YBUtils.h"
#import "UIColor+HEX.h"

@interface YBMainViewController ()
{
    NSMutableArray *AllCitys;
    NSDictionary *currCity;
    UIActivityIndicatorView *progress;
    BOOL IsLoading;
    UIButton *reload;
    CGRect rect;
    UIFont *font;
    NSDictionary *weather_info;
}
@end

@implementation YBMainViewController
@synthesize locationManager = _locationManager;
@synthesize labelCity = _labelCity;
@synthesize labelUpdateTime = _labelUpdateTime;
@synthesize labelTemp = _labelTemp;
@synthesize labelSD = _labelSD;
@synthesize labelWeather = _labelWeather;
@synthesize labelMinMaxTemp = _labelMinMaxTemp;
@synthesize aiv = _aiv;
@synthesize LunchView = _LunchView;
@synthesize MainView = _MainView;
@synthesize btnUpdate = _btnUpdate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 1000.0f;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLHeadingFilterNone;
        [self.locationManager startUpdatingLocation];
    }
    rect = [UIScreen mainScreen].applicationFrame;
    return self;
}




-(void)LoadWeather{
    
    [self MakeMainView];
    self.LunchView.hidden = YES;
    [self.aiv  setHidden:YES];
    
    self.btnUpdate.hidden = NO;
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *place = placemarks[0];
        
        NSString *locality = place.locality;
        if (locality ==nil) {
            locality = place.subLocality;
        }
        if(locality==nil)
        {
            [self UnableLoadGPS];
            return;
        }
        for (NSDictionary *city in AllCitys) {
            if([locality hasPrefix:city[@"cityname"]]){
                self.title = city[@"cityname"];
                [self.locationManager stopUpdatingLocation];
                currCity = city;
                
                [self LoadWeather];
                break;
            }
        }
        
    }];
}
-(void)MakeMainView{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.weather.com.cn/data/sk/%@.html",currCity[@"citycode"]]];
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *sk =   json[@"weatherinfo"];
    
    
    
    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.weather.com.cn/data/cityinfo/%@.html",currCity[@"citycode"]]];
    data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *sk2 = json[@"weatherinfo"];
    
    
    
    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",currCity[@"citycode"]]];
    data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *all = json[@"weatherinfo"];
    
    
    
    weather_info = @{@"sk":sk,@"sk2":sk2,@"all":all};
    
    //    [all release];
    //    [sk release];
    //    [sk2 release];
    
    
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.MainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.labelCity = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
    self.labelCity.text = [NSString stringWithFormat:@"%@",self.title];
    self.labelCity.textAlignment = NSTextAlignmentLeft;
    self.labelCity.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    
    
    self.labelDate = [[UILabel alloc] initWithFrame:CGRectMake(bounds.size.width-160, 10, bounds.size.width-160, 20)];
    self.labelDate.textAlignment = NSTextAlignmentRight;
    self.labelDate.text=weather_info[@"all"][@"date_y"];
    
    
    
    self.labelWeather = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 200, 20)];
    self.labelWeather.text=[NSString stringWithFormat:@"%@ %@%@",weather_info[@"sk2"][@"weather"], weather_info[@"sk"][@"WD"],weather_info[@"sk"][@"WS"]];
    self.labelWeather.font = font;
    
    self.labelMinMaxTemp = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 200, 20)];
    self.labelMinMaxTemp.text= [NSString stringWithFormat:@"最低气温:%@,最高气温:%@",weather_info[@"sk2"][@"temp1"],weather_info[@"sk2"][@"temp2"]];
    self.labelMinMaxTemp.font = font;
    
    
    self.labelTemp = [[UILabel alloc] initWithFrame:CGRectMake((bounds.size.width-220)/2, 120, 220, 100)];
    self.labelTemp.text=weather_info[@"sk"][@"temp"];
    self.labelTemp.textAlignment = NSTextAlignmentCenter;
    self.labelTemp.font = [UIFont fontWithName:@"verdana" size:100.0f];
    
    
    
    self.labelSD = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 150.0, 20.0)];
    self.labelSD.text = [NSString stringWithFormat:@"湿度:%@" ,weather_info[@"sk"][@"SD"]];
    self.labelSD.font = font;
    
    
    
    
    self.btnUpdate = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [self.btnUpdate setBackgroundColor:[UIColor clearColor]];
	[self.btnUpdate setFrame:CGRectMake(10, rect.size.height-30, 20, 20)];
	[self.btnUpdate setTitle:[NSString stringWithFormat:@"更新于%@ %@",all[@"date_y"], weather_info[@"sk"][@"time"]] forState:UIControlStateNormal];
	[self.btnUpdate addTarget:self action:@selector(Refersh) forControlEvents:UIControlEventTouchUpInside];     [self.btnUpdate setTintColor:[UIColor redColor]];
    
    
    self.labelUpdateTime = [[UILabel alloc] initWithFrame:CGRectMake(32, rect.size.height-31, 200.0, 20.0)];
    
    
    
    self.labelUpdateTime.textAlignment = NSTextAlignmentLeft;
    self.labelUpdateTime.text = [NSString stringWithFormat:@"更新于%@ %@",weather_info[@"all"][@"date_y"], weather_info[@"sk"][@"time"]];
    self.labelUpdateTime.font = font;
    self.labelUpdateTime.textColor = [UIColor colorWithHex:0xcccccc alpha:0.7f];
    
    
    self.aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.aiv.frame = CGRectMake(rect.size.width-40, rect.size.height-30, 20, 20);
    self.aiv.hidden = YES;
    [self.MainView addSubview:self.aiv];
    
    
    
    [self.MainView addSubview:self.labelUpdateTime];
    [self.MainView addSubview:self.btnUpdate];
    [self.MainView addSubview:self.labelSD];
    [self.MainView addSubview:self.labelTemp];
    [self.MainView addSubview:self.labelMinMaxTemp];
    [self.MainView addSubview:self.labelWeather];
    [self.MainView addSubview:self.labelDate];
    [self.MainView addSubview:self.labelCity];
    [self.view addSubview:self.MainView];
    
}

-(void)MakeLunch{
    
    self.LunchView   = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.LunchView.backgroundColor = [UIColor colorWithHex:0xcccccc alpha:0.8f];
    if(progress==nil)
    {
        progress=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
                  UIActivityIndicatorViewStyleGray];
        progress.center=CGPointMake(self.LunchView.center.x-25,self.LunchView.center.y);
        
        [self.LunchView addSubview:progress];
    }
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    
    label.text=@"加载中.";
    label.frame = CGRectMake(progress.frame.origin.x+25, progress.frame.origin.y, 100.0f, 20.0f);
    label.font = font;
    [label sizeToFit];
    label.textColor = [UIColor colorWithHex:0x000000];
    [self.LunchView addSubview:label];
    [self.view addSubview:self.LunchView];
    [progress startAnimating];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    font = [UIFont fontWithName:@"verdana" size:13.0f];
    
    [self MakeLunch];
    
    
    YBUtils *utils = [[YBUtils alloc] init];
    [utils Load];
    AllCitys = [utils AllCitys];
    // Do any additional setup after loading the view from its nib.
}



-(void)UnableLoadGPS{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((rect.size.width-200)/2, (rect.size.height-40)/2, 200.0f, 40.0f)];
    label.text=@"无法加载您的位置信息";
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    
    
}

-(void)StopLoadding{
    
    if(progress!=nil)
    {
        [progress stopAnimating];
        progress.hidden = YES;
    }
    else
        NSLog(@"shit");
}

-(void)Back{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)Refersh{
    self.btnUpdate.hidden = YES;
    self.labelUpdateTime.text=@"加载中";
    self.aiv.hidden = NO;
    [self.aiv startAnimating];
    [self LoadWeather];
    NSString *msg = [NSString stringWithFormat:@"为什么这个进度条设为hidden=YES没有用？ %@",weather_info[@"sk"][@"time"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"啊哦" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    //[msg release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLabelCity:nil];
    [self setLabelUpdateTime:nil];
    [self setLabelTemp:nil];
    [self setLabelSD:nil];
    [self setLabelWeather:nil];
    [self setLabelDate:nil];
    [self setLabelMinMaxTemp:nil];
    [super viewDidUnload];
}
@end
