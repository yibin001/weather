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
#import "CheckNetwork.h"
#import "YBWeatherQuery.h"

#define GOOGLE_MAP_API @"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true"

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
    BOOL HasNetwork;
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
@synthesize CurrentLocaltion = _CurrentLocaltion;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 1000.0f;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.locationManager.distanceFilter = kCLHeadingFilterNone;
        [self.locationManager startUpdatingLocation];
          HasNetwork = [CheckNetwork isExistenceNetwork];
        if(!HasNetwork)
            [self.locationManager stopUpdatingLocation];
    }
    rect = [UIScreen mainScreen].applicationFrame;
    return self;
}





-(void)LoadWeather{
    YBWeatherQuery *weatherQuery = [[YBWeatherQuery alloc] initWithCityCode:currCity[@"citycode"]];
    weather_info = [weatherQuery QueryWeather];
    self.labelDate.text= [NSString stringWithFormat:@"%@ %@", weather_info[@"all"][@"date_y"],weather_info[@"all"][@"week"]];
    self.labelWeather.text=[NSString stringWithFormat:@"%@ %@%@",weather_info[@"sk2"][@"weather"], weather_info[@"sk"][@"WD"],weather_info[@"sk"][@"WS"]];
    
    
    
    int min = MIN([weather_info[@"sk2"][@"temp1"] intValue], [weather_info[@"sk2"][@"temp2"] intValue]);
    int max = MAX([weather_info[@"sk2"][@"temp1"] intValue], [weather_info[@"sk2"][@"temp2"] intValue]);
    self.labelMinMaxTemp.text= [NSString stringWithFormat:@"最低气温:%d,最高气温:%d",min,max];
    self.labelTemp.text=weather_info[@"sk"][@"temp"];
    
    self.labelCity.text = [NSString stringWithFormat:@"%@",self.title];
    self.labelSD.text = [NSString stringWithFormat:@"湿度:%@" ,weather_info[@"sk"][@"SD"]];
    [self.btnUpdate setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    self.labelUpdateTime.text = [NSString stringWithFormat:@"更新于%@ %@",weather_info[@"all"][@"date_y"], weather_info[@"sk"][@"time"]];
    
    [self.labelDate sizeToFit];
    CGRect _rect = self.labelDate.frame;
    _rect.origin.x = rect.size.width-_rect.size.width-10;
    self.labelDate.frame = _rect;
    self.MainView.hidden=NO;
    self.LunchView.hidden = YES;
    self.btnUpdate.hidden = NO;    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
   
    
    
    self.CurrentLocaltion= [newLocation coordinate];
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
        if(currCity==nil)
            [self UnableLoadGPS];
     
    }];
}
-(void)MakeMainView{
    
    
    
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.MainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //    UIGraphicsBeginImageContext(self.view.frame.size);
    //    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.bounds];
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    //self.MainView.backgroundColor = [UIColor colorWithHex:0x009ad6]; //[UIColor colorWithPatternImage:image];
    
    
    self.labelCity = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
    self.labelCity.backgroundColor = [UIColor clearColor];
    self.labelCity.textAlignment = NSTextAlignmentLeft;
    self.labelCity.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    
    
    self.labelDate = [[UILabel alloc] initWithFrame:CGRectMake(bounds.size.width-160, 10, bounds.size.width-160, 20)];
    self.labelDate.textAlignment = NSTextAlignmentRight;
    self.labelDate.backgroundColor = [UIColor clearColor];
    
    
    self.labelWeather = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 200, 20)];
    self.labelWeather.backgroundColor = [UIColor clearColor];
    self.labelWeather.font = font;
    
    self.labelMinMaxTemp = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 200, 20)];
    self.labelMinMaxTemp.backgroundColor = [UIColor clearColor];
    self.labelMinMaxTemp.font = font;
    
    
    self.labelTemp = [[UILabel alloc] initWithFrame:CGRectMake((bounds.size.width-220)/2, 100, 220, 120)];
    
    self.labelTemp.textAlignment = NSTextAlignmentCenter;
    self.labelTemp.font = [UIFont fontWithName:@"Georgia-Italic" size:100.0f];
    
    self.labelTemp.backgroundColor = [UIColor clearColor];
    UILabel *lbl0 = [[UILabel alloc] init];
    lbl0.text=@"℃";
    lbl0.font = [UIFont boldSystemFontOfSize:24.0];
    lbl0.frame = CGRectMake(220, 120, 30, 30);
    lbl0.backgroundColor = [UIColor clearColor];
    [self.MainView addSubview:lbl0];
    
    
    self.labelSD = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 150.0, 20.0)];
    self.labelSD.font = font;
    self.labelSD.backgroundColor =[UIColor clearColor];// [UIColor colorWithPatternImage:[UIImage imageNamed:@"sun.big.png"]];
    
    
    
    self.btnUpdate = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [self.btnUpdate setBackgroundColor:[UIColor clearColor]];
	[self.btnUpdate setFrame:CGRectMake(10, rect.size.height-79, 20, 20)];
	
	[self.btnUpdate addTarget:self action:@selector(Refersh:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.labelUpdateTime = [[UILabel alloc] initWithFrame:CGRectMake(34, rect.size.height-79, 200.0, 20.0)];
    self.labelUpdateTime.backgroundColor = [UIColor clearColor];
    
    
    
    self.labelUpdateTime.textAlignment = NSTextAlignmentLeft;
    
    self.labelUpdateTime.font = font;
    self.labelUpdateTime.textColor = [UIColor colorWithHex:0xcccccc];
    
    
    self.aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.aiv.frame = self.btnUpdate.frame;
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
    //self.LunchView.backgroundColor = [UIColor colorWithHex:0x009ad6];
    
    
    if(progress==nil)
    {
        progress=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
                  UIActivityIndicatorViewStyleGray];
        progress.center=CGPointMake(self.LunchView.center.x-25,self.LunchView.center.y-49);
        
        [self.LunchView addSubview:progress];
    }
    UILabel *label = [[UILabel alloc] init];
    label.tag = 1;
    label.backgroundColor = [UIColor clearColor];
    
    label.text=!HasNetwork ? @"没有找到网络连接" : @"加载中.";
    label.frame = CGRectMake(progress.frame.origin.x+25, progress.frame.origin.y+2, 100.0f, 20.0f);
    label.font = font;
    [label sizeToFit];
    if(!HasNetwork){
        label.center = self.LunchView.center;
        [progress stopAnimating];
    }
    else
        [progress startAnimating];
    [self.LunchView addSubview:label];
    [self.view addSubview:self.LunchView];
    
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
     [self MakeLunch];
    
    if (!HasNetwork) {
        [self.locationManager stopUpdatingLocation];        
        return;
        
    }
    
    
   
    
    
    
    
    
    [self MakeMainView];
    
    self.MainView.hidden=YES;
    YBUtils *utils = [[YBUtils alloc] init];
    [utils Load];
    AllCitys = [utils AllCitys];
    // Do any additional setup after loading the view from its nib.
}



-(void)UnableLoadGPS{
    [self.locationManager stopUpdatingLocation];
    for (UIView *view in self.LunchView.subviews) {
        view.hidden = YES;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((rect.size.width-200)/2, (rect.size.height-49)/2, 200.0f, 40.0f)];
    label.text=@"无法加载您的位置信息";
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    [progress stopAnimating];
   
    [self.view addSubview:label];
    
    
}





-(void)Refersh:(UIButton *)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.aiv startAnimating];
    self.btnUpdate.hidden = YES;
    self.labelUpdateTime.text=@"正在更新......";
    //[self.labelUpdateTime sizeToFit];
    
    
    
    
    [self performSelector:@selector(DelayHide) withObject:self afterDelay:1];
    
    
}

-(void)DelayHide{
    [self LoadWeather];
    [self.aiv stopAnimating];
    self.btnUpdate.hidden = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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