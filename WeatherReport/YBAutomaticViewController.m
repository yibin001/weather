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
    
    
    
    if(IsLoad) return;
    
    if (!currCity) {
        [self LoadError:@"Unable load GPS"];
        return;
    }
    YBWeatherQuery *query = [[YBWeatherQuery alloc] initWithCityCode:currCity[@"citycode"]];
    weather_info = [query QueryWeather];
    
    NSString *imgName = weather_info[@"sk2"][@"img1"];
    imgName = [imgName stringByReplacingOccurrencesOfString:@"b" withString:@"a"];
    imgName = [imgName stringByReplacingOccurrencesOfString:@"c" withString:@"a"];
    imgName = [imgName stringByReplacingOccurrencesOfString:@"d" withString:@"a"];
    imgName = [imgName stringByReplacingOccurrencesOfString:@"n" withString:@"a"];
    imgName = [imgName stringByReplacingOccurrencesOfString:@"gif" withString:@"png"];
    
    self.imgWeather.frame = CGRectMake(40, 10, 100, 100);
    self.imgWeather.image = [UIImage imageNamed:imgName];
    self.lblMinMaxTemp.frame = CGRectMake(40, 80, 100, 30);
 
    
    self.lblTemp.frame = CGRectMake(150, 10, 100, 100);
    self.lblTemp.font = [UIFont fontWithName:@"verdana" size:95.0];
    
    self.lblWeather.text = weather_info[@"sk2"][@"weather"];
    self.lblWeather.font = font;
    self.lblUpdateTime.font = font;
    self.lblSD.text = [NSString stringWithFormat:@"湿度:%@", weather_info[@"sk"][@"SD"]];
    self.lblSD.font = font;
    self.lblUpdateTime.font = font;
    self.lblDegree.frame = CGRectMake(220, 20, 20, 20);
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
    NSLog(@"%@",cityname);
    self.lblCityName.text = [NSString stringWithFormat:@"当前位置:%@",cityname];
    self.imgLocationIcon.frame = CGRectMake(10, main.size.height-50-68, 20, 20);
    self.imgLocationIcon.image = [UIImage imageNamed:@"location.png"];
    CGRect iconRect = self.imgLocationIcon.frame;
    iconRect.origin.x+=25;
    iconRect.size.width = 200.0;
    
    self.lblCityName.frame = iconRect;
    self.lblCityName.textAlignment = NSTextAlignmentLeft;
    [self.lblCityName sizeToFit];
    self.lblCityName.font = [UIFont systemFontOfSize:12.0];
    
    
    int min = MIN([weather_info[@"sk2"][@"temp1"] intValue], [weather_info[@"sk2"][@"temp2"] intValue]);
    int max = MAX([weather_info[@"sk2"][@"temp1"] intValue], [weather_info[@"sk2"][@"temp2"] intValue]);
    self.lblMinMaxTemp.text= [NSString stringWithFormat:@"%d / %d",min,max];
    self.lblTemp.text=weather_info[@"sk"][@"temp"];

    self.lblUpdateTime.text = [NSString stringWithFormat:@"更新于%@ %@", weather_info[@"all"][@"date_y"], weather_info[@"sk"][@"time"]];
    self.lblUpdateTime.font = [UIFont systemFontOfSize:12.0];
    self.lblUpdateTime.textColor = [UIColor grayColor];
    self.lblUpdateTime.frame = CGRectMake(10, main
                                          .size.height-50-46, 200, 20);
    
        [self _initLabel];
    
    [self.AviLoadding stopAnimating];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}


-(void)_initLabel{
    UIImageView *img1,*img2,*img3,*img4;
    
    
    
    
   
    UIColor *background = [UIColor clearColor];
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 210, 70, 60)];
    img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, 60, 60)];
    img1.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img1"]]];
    img1.contentMode = UIViewContentModeCenter;
    [self.view addSubview:img1];
    
    lbl1.textAlignment = NSTextAlignmentCenter;
    lbl1.font = font;
    lbl1.text = [NSString stringWithFormat:@"%@\n%@\n%@",  @"今天",weather_info[@"all"][@"weather1"],weather_info[@"all"][@"temp1"]];
    
    lbl1.backgroundColor = background;
    [self.view addSubview:lbl1];
    lbl1.numberOfLines = 0;
    lbl1.lineBreakMode = UILineBreakModeWordWrap;
    
    
    
    
    img2 = [[UIImageView alloc] initWithFrame:CGRectMake(90, 150, 60, 60)];
    img2.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img3"]]];
    img2.contentMode = UIViewContentModeCenter;
    [self.view addSubview:img2];
    
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(85, 210, 70, 60)];
    lbl2.textAlignment = NSTextAlignmentCenter;
    
    lbl2.text = [NSString stringWithFormat:@"%@\n%@\n%@",@"明天", weather_info[@"all"][@"weather2"],weather_info[@"all"][@"temp2"] ];
    lbl2.backgroundColor = background;
    lbl2.font = font;
    lbl2.numberOfLines = 0;
    lbl2.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:lbl2];
    
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(165, 210, 70, 60)];
    lbl3.textAlignment = NSTextAlignmentCenter;
    lbl3.text = [NSString stringWithFormat:@"%@\n%@\n%@",@"后天", weather_info[@"all"][@"weather3"],weather_info[@"all"][@"temp3"] ];
    
    lbl3.backgroundColor = background;
    lbl3.font = font;
    lbl3.numberOfLines = 0;
    lbl3.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:lbl3];
    
    img3 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 150, 60, 60)];
    img3.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img5"]]];
    img3.contentMode = UIViewContentModeCenter;
    [self.view addSubview:img3];
    

    
    UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(245, 210, 70, 60)];
    lbl4.textAlignment = NSTextAlignmentCenter;
    lbl4.text = [NSString stringWithFormat:@"%@\n%@\n%@",@"大后天", weather_info[@"all"][@"weather4"],weather_info[@"all"][@"temp4"] ];
    lbl4.backgroundColor = background;
    lbl4.font = font;
    lbl4.numberOfLines = 0;
    lbl4.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:lbl4];
    img4 = [[UIImageView alloc] initWithFrame:CGRectMake(250, 150, 60, 60)];
    img4.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img7"]]];
    img4.contentMode = UIViewContentModeCenter;
    [self.view addSubview:img4];
    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    IsLoad = NO;
    
    main = [UIScreen mainScreen].bounds;
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.lblDegree.hidden = YES;
    self.AviLoadding.frame = CGRectMake(10, 10, 20, 20);
    self.AviLoadding.hidesWhenStopped = YES;
    
    
    if (![CheckNetwork isExistenceNetwork]) {
        [self.AviLoadding stopAnimating];
      
        [self LoadError:@"No network connection"];
        return;
    }
    
    
    [self.AviLoadding startAnimating];
   
    
    utils = [[YBUtils alloc] init];
    
    [utils Load];
    AllCitys = utils.AllCitys;
    
    
    
    self.title = @"Weather";

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(BtnPress:)];
    self.navigationItem.leftBarButtonItem.tag = 0;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(BtnPress:)];
//    self.navigationItem.rightBarButtonItem.tag = 1;
    [self Start];
    

    NSDate *today = [NSDate date];

    NSCalendar*       calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents* components =  [calendar components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
    components.day = 3;
    NSDate* newDate = [calendar dateByAddingComponents: components toDate: today options: 0];
    NSLog(@"%d",components.weekday);
    // Do any additional setup after loading the view from its nib.
}

-(void)BtnPress:(UIBarItem *)sender{
    if(sender.tag==0)
    {
        IsLoad = NO;
        [self.AviLoadding startAnimating];
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
    [self setImgLocationIcon:nil];
    [self setLblWeather:nil];
    [self setLblSD:nil];
    [super viewDidUnload];
}
@end
