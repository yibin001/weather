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


#define SK_URL  @"http://www.weather.com.cn/data/sk/%@.html"
#define SK2_URL @"http://www.weather.com.cn/data/cityinfo/%@.html"
#define ALL_URL @"http://m.weather.com.cn/data/%@.html"

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
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLHeadingFilterNone;
        [self.locationManager startUpdatingLocation];
    }
    rect = [UIScreen mainScreen].applicationFrame;
    return self;
}


-(void)LoadGoogleAPI{
    NSString *apiurl = [NSString stringWithFormat:GOOGLE_MAP_API,self.CurrentLocaltion.latitude,self.CurrentLocaltion.longitude];
    
    NSURL *url = [NSURL URLWithString:apiurl];
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",json);

}



-(void)LoadWeather{
    
    //[self performSelector:@selector(LoadGoogleAPI) withObject:self afterDelay:2];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:SK_URL,currCity[@"citycode"]]];
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *sk =   json[@"weatherinfo"];
    
    
    
    url = [NSURL URLWithString:[NSString stringWithFormat:SK2_URL,currCity[@"citycode"]]];
    data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *sk2 = json[@"weatherinfo"];
    
    
    
    url = [NSURL URLWithString:[NSString stringWithFormat:ALL_URL,currCity[@"citycode"]]];
    data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *all = json[@"weatherinfo"];
    
    
    
    weather_info = @{@"sk":sk,@"sk2":sk2,@"all":all};
    
    self.labelDate.text=weather_info[@"all"][@"date_y"];
    self.labelWeather.text=[NSString stringWithFormat:@"%@ %@%@",weather_info[@"sk2"][@"weather"], weather_info[@"sk"][@"WD"],weather_info[@"sk"][@"WS"]];
    self.labelMinMaxTemp.text= [NSString stringWithFormat:@"最低气温:%@,最高气温:%@",weather_info[@"sk2"][@"temp1"],weather_info[@"sk2"][@"temp2"]];
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
        
    }];
}
-(void)MakeMainView{
    
   
    
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.MainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    self.MainView.backgroundColor = [UIColor colorWithHex:0x009ad6]; //[UIColor colorWithPatternImage:image];
    
    
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
	[self.btnUpdate setFrame:CGRectMake(10, rect.size.height-42, 20, 20)];
	
	[self.btnUpdate addTarget:self action:@selector(Refersh:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.labelUpdateTime = [[UILabel alloc] initWithFrame:CGRectMake(34, rect.size.height-41, 200.0, 20.0)];
    self.labelUpdateTime.backgroundColor = [UIColor clearColor];
    
    

    self.labelUpdateTime.textAlignment = NSTextAlignmentLeft;
    
    self.labelUpdateTime.font = font;
    self.labelUpdateTime.textColor = [UIColor colorWithHex:0xcccccc];
    
    
    self.aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.aiv.frame = CGRectMake(rect.size.width-30, rect.size.height-42, 20, 20);
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
    label.frame = CGRectMake(progress.frame.origin.x+25, progress.frame.origin.y+2, 100.0f, 20.0f);
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
    font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
    
    
    [self MakeLunch];
    
    
    
    
    
    [self MakeMainView];
    self.MainView.hidden=YES;
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





-(void)Refersh:(UIButton *)sender{
   [self.aiv startAnimating];
    
    self.labelUpdateTime.text=@"正在更新......";
    //[self.labelUpdateTime sizeToFit];
    
   
    
       
    [self performSelector:@selector(DelayHide) withObject:self afterDelay:2];
   
    
}

-(void)DelayHide{
    [self LoadWeather];
    [self.aiv stopAnimating];
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
