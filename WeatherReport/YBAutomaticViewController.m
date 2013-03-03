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
#import "CheckNetwork.h"
#import "MBProgressHUD.h"


#define ISDEBUG YES;
#define DEBUG_CITY_CODE @"101021000";

@interface YBAutomaticViewController ()
{
    NSMutableArray *AllCitys;
    YBUtils *utils;
    NSDictionary *currCity;
    UILabel *lblError;
    CGRect main;
    NSDictionary *weather_info;
    NSDictionary *addr_info;
    BOOL IsLoad;
    UIFont *font;
    UIActivityIndicatorView *loadding;
    UIImageView *img1,*img2,*img3,*img4;
    UILabel *lbl1,*lbl2,*lbl3,*lbl4;
}
@end

@implementation YBAutomaticViewController
@synthesize lblTemp = _lblTemp;
@synthesize imgWeather = _imgWeather;
@synthesize lblMinMaxTemp = _lblMinMaxTemp;

@synthesize lblCityName = _lblCityName;
@synthesize lblUpdateTime = _lblUpdateTime;
@synthesize lblDegree = _lblDegree;
@synthesize locationManager = _locationManager;
@synthesize CurrentLocaltion = _CurrentLocaltion;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        font = [UIFont systemFontOfSize:13.0];
        
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
                YBWeatherQuery *query = [[YBWeatherQuery alloc] init];
                addr_info = [query QueryAddress:self.CurrentLocaltion.latitude lng:self.CurrentLocaltion.longitude];

                
                [self LoaddingWeather];
                IsLoad = YES;
                break;
            }
        }
        if(currCity==nil)
                [self LoadError:@"Unable load your location"];
        
    }];
}


-(void)Start{
    
   
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1000.0f;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = kCLHeadingFilterNone;
    [self.locationManager startUpdatingLocation];
    
}

-(void)LoadError:(NSString *)message{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   
    if(!lblError){
        lblError = [[UILabel alloc] initWithFrame:CGRectMake((main.size.width-200)/2, (main.size.height-20)/2, 200, 20)];
        
        lblError.backgroundColor = [UIColor clearColor];
        lblError.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lblError];
    }
    lblError.text = message;
    [loadding stopAnimating];
}

-(void)LoaddingWeather{
    
    
    if(loadding.isAnimating)
        [loadding stopAnimating];
    
    
    if (!currCity) {
        [self LoadError:@"Unable load GPS"];
        return;
    }
    if(IsLoad) return;
    YBWeatherQuery *query = [[YBWeatherQuery alloc] initWithCityCode:currCity[@"citycode"]];
    weather_info = [query QueryWeather];
    
    NSString *imgName = weather_info[@"sk2"][@"img1"];
    
    
    NSError *error;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"(b|c|d|n)" options:NSRegularExpressionCaseInsensitive error:&error ];
    
    NSMutableString *tmp_string = [NSMutableString stringWithString:imgName];
    
    [regex replaceMatchesInString:tmp_string options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, tmp_string.length) withTemplate:@"a"];
    imgName = tmp_string;
    
       
    imgName = [imgName stringByReplacingOccurrencesOfString:@"gif" withString:@"png"];
    
    self.imgWeather.frame = CGRectMake(60, 5, 100, 100);
    self.imgWeather.image = [UIImage imageNamed:imgName];
  
    self.imgWeather.contentMode = UIViewContentModeCenter;
    self.lblMinMaxTemp.frame = CGRectMake(60, 90, 100, 30);
 
    
    self.lblTemp.frame = CGRectMake(165, 10, 130, 130);
    
    self.lblTemp.font = [UIFont fontWithName:@"verdana" size:80.0];
    self.lblTemp.textAlignment = NSTextAlignmentLeft;
    self.lblTemp.text=weather_info[@"sk"][@"temp"];
    self.lblWeather.text = [NSString stringWithFormat:@"%@,湿度:%@,%@%@", weather_info[@"sk2"][@"weather"],weather_info[@"sk"][@"SD"],weather_info[@"sk"][@"WD"],weather_info[@"sk"][@"WS"]];
    
    self.lblWeather.font = [UIFont  fontWithName:@"Helvetica" size:14];
    self.lblWeather.textAlignment = NSTextAlignmentLeft;
    
    
    self.lblWeather.frame = CGRectMake(10, 150, 200, 20);
    
    self.lblUpdateTime.font = font;
    
    
    
    self.lblUpdateTime.font = font;
    self.lblDegree.frame = CGRectMake(245, 20, 20, 20);
    if (self.lblTemp.text.length<2) {
        self.lblDegree.frame = CGRectMake(210, 20, 20, 20);
    }
    self.lblDegree.hidden = NO;
    self.lblDegree.textAlignment = NSTextAlignmentLeft;
    
    NSString *cityname = weather_info[@"all"][@"city"];
    
    if(addr_info){
        if([addr_info[@"status"] isEqualToString:@"OK"]){
            NSArray *arr = addr_info[@"results"];
            if(arr.count>3)
            {
                NSDictionary *dict = arr[arr.count-4];
                cityname =  dict[@"formatted_address"];
                
            }
        }
    }
    //NSLog(@"%@",cityname);
    self.lblCityName.text = [NSString stringWithFormat:@"%@",cityname];
    self.imgLocationIcon.frame = CGRectMake(10, main.size.height-50-68, 20, 20);
   
    self.imgLocationIcon.image = [UIImage imageNamed:@"location.png"];
    CGRect iconRect = self.imgLocationIcon.frame;
    iconRect.origin.x+=25;
    iconRect.size.width = 200.0;
    
    self.lblCityName.frame = iconRect;
    self.lblCityName.textAlignment = NSTextAlignmentLeft;
    
    self.lblCityName.font = [UIFont systemFontOfSize:12.0];
    
    
    int min = MIN([weather_info[@"sk2"][@"temp1"] intValue], [weather_info[@"sk2"][@"temp2"] intValue]);
    int max = MAX([weather_info[@"sk2"][@"temp1"] intValue], [weather_info[@"sk2"][@"temp2"] intValue]);
    self.lblMinMaxTemp.text= [NSString stringWithFormat:@"%d℃ / %d℃",min,max];
    

    self.lblUpdateTime.text = [NSString stringWithFormat:@"更新于%@ %@", weather_info[@"all"][@"date_y"], weather_info[@"sk"][@"time"]];
    self.lblUpdateTime.font = [UIFont systemFontOfSize:12.0];
    self.lblUpdateTime.textColor = [UIColor grayColor];
    self.lblUpdateTime.textAlignment = NSTextAlignmentLeft;
    self.lblUpdateTime.frame = CGRectMake(10, main.size.height-50-46, 200, 20);
    
    [self Render4Days];
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}


-(void)_initLableAndImgView{
    UIColor *background = [UIColor clearColor];
    lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 230, 70, 60)];
    
    img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 180, 60, 60)];
    
   
    lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(85, 230, 70, 60)];
    img2 = [[UIImageView alloc] initWithFrame:CGRectMake(90, 180, 60, 60)];
    lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(165, 230, 70, 60)];

    img3 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 180, 60, 60)];
    lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(245, 230, 70, 60)];
    img4 = [[UIImageView alloc] initWithFrame:CGRectMake(250, 180, 60, 60)];

    
    
    lbl1.backgroundColor = background;
    lbl2.backgroundColor = background;
    lbl3.backgroundColor = background;
    lbl4.backgroundColor = background;
    [self.view addSubview:img1];
    [self.view addSubview:lbl1];
    [self.view addSubview:img2];
    [self.view addSubview:lbl2];
    [self.view addSubview:img3];
    [self.view addSubview:lbl3];
    [self.view addSubview:img4];
    [self.view addSubview:lbl4];
   
}


-(void)Render4Days{
   
    
    
   
    img1.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img1"]]];
    img1.contentMode = UIViewContentModeCenter;
    lbl1.text = [NSString stringWithFormat:@"%@\n%@\n%@",  @"今天",weather_info[@"all"][@"weather1"],weather_info[@"all"][@"temp1"]];
   
    lbl1.numberOfLines = 0;
    lbl1.lineBreakMode = UILineBreakModeWordWrap;
    lbl1.font = font;
    lbl1.textAlignment = NSTextAlignmentCenter;
    img2.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img3"]]];
    img2.contentMode = UIViewContentModeCenter;
    lbl2.textAlignment = NSTextAlignmentCenter;
    
    NSString *weekday = [utils GetChineseWeekDay:[[NSDate alloc] initWithTimeIntervalSinceNow:1*24*60*60]];
    lbl2.text = [NSString stringWithFormat:@"%@\n%@\n%@",weekday, weather_info[@"all"][@"weather2"],weather_info[@"all"][@"temp2"] ];
   
    lbl2.font = font;
    lbl2.numberOfLines = 0;
    lbl2.lineBreakMode = UILineBreakModeWordWrap;
    weekday = [utils GetChineseWeekDay:[[NSDate alloc] initWithTimeIntervalSinceNow:2*24*60*60]];
    lbl3.textAlignment = NSTextAlignmentCenter;
    lbl3.text = [NSString stringWithFormat:@"%@\n%@\n%@",weekday, weather_info[@"all"][@"weather3"],weather_info[@"all"][@"temp3"] ];
   
    lbl3.font = font;
    lbl3.numberOfLines = 0;
    lbl3.lineBreakMode = UILineBreakModeWordWrap;
    img3.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img5"]]];
    img3.contentMode = UIViewContentModeCenter;
    weekday = [utils GetChineseWeekDay:[[NSDate alloc] initWithTimeIntervalSinceNow:3*24*60*60]];
    lbl4.textAlignment = NSTextAlignmentCenter;
    lbl4.text = [NSString stringWithFormat:@"%@\n%@\n%@",weekday, weather_info[@"all"][@"weather4"],weather_info[@"all"][@"temp4"] ];
   
    lbl4.font = font;
    lbl4.numberOfLines = 0;
    lbl4.lineBreakMode = UILineBreakModeWordWrap;

    img4.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img7"]]];
    img4.contentMode = UIViewContentModeCenter;
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    main = [UIScreen mainScreen].bounds;
    self.title = @"Weather";
    IsLoad = NO;
    loadding = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadding.frame = CGRectMake((main.size.width-20)/2, (main.size.height-40)/2, 20, 20);
    loadding.hidesWhenStopped = YES;
    [loadding startAnimating];
    [self.view addSubview:loadding];
   
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    
    
    self.lblDegree.hidden = YES;
       
    if (![CheckNetwork isExistenceNetwork]) {
        [self LoadError:@"No network connection"];
        return;
    }
    utils = [[YBUtils alloc] init];
    
    [utils Load];
    AllCitys = utils.AllCitys;
    
    [self _initLableAndImgView];
    
   

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(BtnPress:)];
    self.navigationItem.leftBarButtonItem.tag = 0;
    
    
    [self performSelector:@selector(Start) withObject:self afterDelay:2];
   
    
}

-(void)BtnPress:(UIBarItem *)sender{
    if(sender.tag==0)
    {
        IsLoad = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        [HUD showWhileExecuting:@selector(LoaddingWeather) onTarget:self withObject:nil animated:YES];
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
    
    [self setLblCityName:nil];
    [self setLblUpdateTime:nil];
    [self setLblDegree:nil];
    [self setImgLocationIcon:nil];
    [self setLblWeather:nil];
    
    [super viewDidUnload];
}
@end
