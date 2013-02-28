//
//  YBAutomaticViewController.m
//  WeatherReport
//
//  Created by yibin on 13-2-28.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "YBAutomaticViewController.h"
#import "YBUtils.h"
#import "YBWeatherQuery.h"
@interface YBAutomaticViewController ()
{
    NSMutableArray *AllCitys;
    YBUtils *utils;
    NSDictionary *currCity;
    UILabel *lblError;
    CGRect main;
    NSDictionary *weather_info;
}
@end

@implementation YBAutomaticViewController
@synthesize lblTemp = _lblTemp;
@synthesize imgWeather = _imgWeather;
@synthesize lblMinMaxTemp = _lblMinMaxTemp;
@synthesize AviLoadding = _AviLoadding;
@synthesize lblCityName = _lblCityName;
@synthesize lblUpdateTime = _lblUpdateTime;
@synthesize lblDegree = _lblDegree;
@synthesize locationManager = _locationManager;
@synthesize CurrentLocaltion = _CurrentLocaltion;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
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
            [self LoadError:@"Unable load GPS"];
            return;
        }
        for (NSDictionary *city in AllCitys) {
            if([locality hasPrefix:city[@"cityname"]]){
                
                [self.locationManager stopUpdatingLocation];
                currCity = city;
                
                [self LoaddingWeather];
                break;
            }
        }
        if(currCity==nil)
                [self LoadError:@"Unable load GPS"];
        
    }];
}


-(void)Start{
    
    if(!self.AviLoadding.isAnimating)
        [self.AviLoadding startAnimating];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1000.0f;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = kCLHeadingFilterNone;
    [self.locationManager startUpdatingLocation];
    
}

-(void)LoadError:(NSString *)message{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.AviLoadding stopAnimating];
    if(!lblError){
        lblError = [[UILabel alloc] initWithFrame:CGRectMake((main.size.width-200)/2, (main.size.height-20)/2, 200, 20)];
        
        lblError.backgroundColor = [UIColor clearColor];
        lblError.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lblError];
    }
    lblError.text = message;
    
}

-(void)LoaddingWeather{
    if (!currCity) {
        [self LoadError:@"Unable load GPS"];
        return;
    }
    YBWeatherQuery *query = [[YBWeatherQuery alloc] initWithCityCode:currCity[@"citycode"]];
    weather_info = [query QueryWeather];
    
    
    self.imgWeather.frame = CGRectMake(55, 20, 50, 50);
    self.imgWeather.image = [UIImage imageNamed:@"a0.png"];
    self.lblMinMaxTemp.frame = CGRectMake(30, 70, 100, 30);
    //self.lblMinMaxTemp.backgroundColor = [UIColor redColor];
    
    self.lblTemp.frame = CGRectMake(140, 10, 120, 100);
    self.lblTemp.font = [UIFont fontWithName:@"verdana" size:80.0];
    //self.lblTemp.backgroundColor = [UIColor blueColor];
    
    self.lblDegree.frame = CGRectMake(250, 20, 20, 20);
    self.lblDegree.hidden = NO;
    
    self.lblCityName.text = weather_info[@"all"][@"city"];
    
    int min = MIN([weather_info[@"sk2"][@"temp1"] intValue], [weather_info[@"sk2"][@"temp2"] intValue]);
    int max = MAX([weather_info[@"sk2"][@"temp1"] intValue], [weather_info[@"sk2"][@"temp2"] intValue]);
    self.lblMinMaxTemp.text= [NSString stringWithFormat:@"%d / %d",min,max];
    self.lblTemp.text=weather_info[@"sk"][@"temp"];

    self.lblUpdateTime.text = [NSString stringWithFormat:@"更新于%@ %@",weather_info[@"all"][@"date_y"], weather_info[@"sk"][@"time"]];
    self.lblUpdateTime.font = [UIFont systemFontOfSize:12.0];
    self.lblUpdateTime.frame = CGRectMake((main.size.width-200)/2, main
                                          .size.height-50-46, 200, 20);
    
    [self _initLabel];
    
    [self.AviLoadding stopAnimating];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}


-(void)_initLabel{
    UIFont *font = [UIFont systemFontOfSize:11.0];
        UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 150, 70, 20)];
        lbl1.textAlignment = NSTextAlignmentCenter;
    lbl1.font = font;
    lbl1.text = weather_info[@"all"][@"weather1"];// @"今天";
        lbl1.backgroundColor = [UIColor redColor];
        [self.view addSubview:lbl1];
    lbl1.numberOfLines = 2;
    lbl1.contentMode = UIViewContentModeLeft;
    
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(85, 150, 70, 20)];
    lbl2.textAlignment = NSTextAlignmentCenter;
    lbl2.text =  weather_info[@"all"][@"weather2"];// @"明天";
    lbl2.backgroundColor = [UIColor redColor];
    lbl2.font = font;
    [self.view addSubview:lbl2];
    
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(165, 150, 70, 20)];
    lbl3.textAlignment = NSTextAlignmentCenter;
    lbl3.text = weather_info[@"all"][@"weather3"];// @"后天";
    lbl3.backgroundColor = [UIColor redColor];
    lbl3.font = font;
    [self.view addSubview:lbl3];

    
    UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(245, 150, 70, 20)];
    lbl4.textAlignment = NSTextAlignmentCenter;
    lbl4.text = weather_info[@"all"][@"weather4"];// @"day 1";
    lbl4.backgroundColor = [UIColor redColor];
    lbl4.font = font;
    [self.view addSubview:lbl4];

    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    main = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor colorWithRed:77.0/255 green:194.0/255 blue:212.0/255 alpha:1.0];// [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    self.lblDegree.hidden = YES;
    self.AviLoadding.frame = CGRectMake(10, 10, 20, 20);
    self.AviLoadding.hidesWhenStopped = YES;
    [self.AviLoadding startAnimating];
   
    
    utils = [[YBUtils alloc] init];
    
    [utils Load];
    AllCitys = utils.AllCitys;
    
    
    
    self.title = @"Weather";

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(BtnPress:)];
    self.navigationItem.leftBarButtonItem.tag = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(BtnPress:)];
    self.navigationItem.rightBarButtonItem.tag = 1;
    [self Start];
    // Do any additional setup after loading the view from its nib.
}

-(void)BtnPress:(UIBarItem *)sender{
    if(sender.tag==0)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self performSelector:@selector(LoaddingWeather) withObject:self afterDelay:1];
    }
    else
        return;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblTemp:nil];
    [self setImgWeather:nil];
    [self setLblMinMaxTemp:nil];
    [self setAviLoadding:nil];
    [self setLblCityName:nil];
    [self setLblUpdateTime:nil];
    [self setLblDegree:nil];
    [super viewDidUnload];
}
@end
