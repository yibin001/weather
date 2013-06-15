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
#import <QuartzCore/QuartzCore.h>
#import "POAPinyin.h"
#import "AFNetworking/AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "SettingViewController.h"
#include "convert.h"
#import "MapKitViewController.h"
#define ISDEBUG YES
#define DEBUG_CITY_CODE @"101021000"
#define DEFAULT_CITY_CODE @"101010300"
#define DEFAULT_CITY_NAME @"BeiJing,China"

#define PM25_API @"http://pm25api.sinaapp.com/city/%@.json"




@interface YBAutomaticViewController ()
{
    NSMutableArray *AllCitys;
    YBUtils *utils;
    NSDictionary *currCity;
    UILabel *lblError;
    CGRect main;
    NSDictionary *weather_info;
    NSDictionary *addr_info;
    
    UIFont *font;
    int tryCount;
    UIImageView *img1,*img2,*img3,*img4,*img5,*img6;
    UILabel *lbl1,*lbl2,*lbl3,*lbl4,*lbl5,*lbl6;
    BOOL IsFoundCity;
    NSString *province;
    UIView *popView;
    BOOL IsSuccess;
    NSString *locality;
    BOOL IsLoadedWeather;
    double FirstTimeStamp;
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
@synthesize lblIntro = _lblIntro;
@synthesize Query = _Query;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        font = [UIFont systemFontOfSize:13.0];
        
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
    NSString *err;
    switch([error code])
    {
        case kCLErrorNetwork:
        {
            err = @"please check your network connection or that you are not in airplane mode" ;
            break;
        }
        case kCLErrorDenied:{
            err =@"请去设置中允许\"简约天气\"使用定位服务\nLocation service is disabled";
            break;
        }
        default:
        {
            err=@"unknown network error";
            break;
        }
    }
    [self LoadError:err];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:err delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    CLLocationCoordinate2D _location = [newLocation coordinate];
    NSLog(@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&mode=json&units=metric&cnt=6&lang=zh_cn",_location.latitude,_location.longitude);
    CLLocationCoordinate2D marsCoordinate =  transform(_location);
    self.CurrentLocaltion = marsCoordinate;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    NSLog(@"精度为:%f",newLocation.horizontalAccuracy);
    
    IsLoadedWeather = NO;
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *place = placemarks[0];
        
        locality = place.locality;
        if (locality ==nil) {
            locality = place.subLocality;
        }
        
        if(locality==nil)
        {
            currCity = @{@"cityname":DEFAULT_CITY_NAME, @"citycode":DEFAULT_CITY_CODE};
            IsFoundCity = NO;
        }
        else
        {
            for (NSDictionary *city in AllCitys) {
                if([locality hasPrefix:city[@"cityname"]]){
                    currCity = city;
                    break;
                    
                }
            }
            
            if(currCity==nil)
            {
                currCity = @{@"cityname":DEFAULT_CITY_NAME, @"citycode":DEFAULT_CITY_CODE};
                IsFoundCity = NO;
            }
            
            if (!IsLoadedWeather) {
                
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    self.Query = [[YBWeatherQuery alloc] initWithCityCode:currCity[@"citycode"]];
                    
                    weather_info = [self.Query QueryWeather];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        addr_info = [self.Query QueryAddress:self.CurrentLocaltion.latitude lng:self.CurrentLocaltion.longitude];
                        NSDictionary *simpleCity =  [YBUtils ConvertToSimpleCity:addr_info];
                        @try {
                            province = [POAPinyin convert:simpleCity[@"city"]];
                            
                            [self QueryPM25:province];
                        }
                        @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        @finally {
                        }
                        
                        
                        [self LoaddingWeather];
                        [self.Query SaveWeatherToLocal:weather_info];
                    });
                });
                IsLoadedWeather = YES;
            }
            
            double curr =  [[NSDate date] timeIntervalSince1970];
            FirstTimeStamp = curr;
            addr_info = [self.Query QueryAddress:self.CurrentLocaltion.latitude lng:self.CurrentLocaltion.longitude];
            NSDictionary *simpleCity =  [YBUtils ConvertToSimpleCity:addr_info];
            NSString *cityname = simpleCity[@"address"];
            
            
            self.lblCityName.text = [NSString stringWithFormat:@"%@",cityname];
            [self.locationManager stopUpdatingLocation];
            
            
            
        }
        
    }];
    
}


-(void)Start{
    if(!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 10.0f;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //self.locationManager.distanceFilter = kCLDistanceFilterNone;
        
    }
    IsSuccess = NO;
    if(![self CheckNetwork])
        
        return;
    IsSuccess = YES;
    [self.locationManager startUpdatingLocation];
}

-(void)RemoveError{
    lblError.backgroundColor = [UIColor clearColor];
    lblError.text = @"";
    
}

-(void)LoadError:(NSString *)message{
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(!lblError){
        lblError = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, main.size.width, main.size.height-46)];
        lblError.numberOfLines = 0;
        lblError.lineBreakMode = UILineBreakModeWordWrap;
        
        lblError.textAlignment = NSTextAlignmentCenter;
        lblError.tag = 100;
        [self.view addSubview:lblError];
        
    }
    lblError.backgroundColor = [UIColor whiteColor];
    lblError.text = message;
    
}

-(void)QueryPM25 :(NSString *)citypy{
    if ([citypy isEqualToString:@""]) {
        return;
    }
    citypy = [citypy lowercaseString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:PM25_API,citypy]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if([JSON[@"code"] intValue] ==0)
        {
            NSArray *array = JSON[@"data"];
            if(array.count > 0)
            {
                NSDictionary *pm25 = [YBUtils ConvertPM25ToString:[NSNumber numberWithInt:[array[0][@"aqi"] intValue]]];
                self.lblPM25.text = [NSString stringWithFormat:@"%@ (pm2.5值 - %@)",pm25[@"summary"],array[0][@"aqi"]];
                
            }
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"%@",error);
        NSLog(@"%@",JSON);
        NSLog(@"%d",response.statusCode);
    }];
    
    
    
    [operation start];
}


-(NSString*)appName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    }
    return appName;
}



-(BOOL)CheckNetwork{
    if (![CheckNetwork isExistenceNetwork]) {
        [self LoadError:@"没有网络连接\nNo network connection"];
        return NO;
    }
    return YES;
}

-(BOOL)CheckGPSWithBoth:(BOOL)Both{
    BOOL enable = YES;
    if(![CLLocationManager locationServicesEnabled])
    {
        
        
        
        [self LoadError:@"请去设置中开启定位服务\nLocation service is disabled."];
        
        enable =  NO;
    }
    else
    {
        if(Both)
        {
            if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
                
                [self LoadError:@"请去设置中允许\"简约天气\"使用定位服务\nLocation service is disabled"];
                enable =  NO;
            }
        }
    }
    return enable;
}

-(void)LoaddingWeather{
    [self RemoveError];
    
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
    
    
    self.lblWeather.frame = CGRectMake(10, 140, 320, 20);
    
    
    self.lblPM25.frame = CGRectMake(10, 170, 320, 20);
    self.lblPM25.font = [UIFont boldSystemFontOfSize:14];
    
    
    
    self.lblUpdateTime.font = font;
    
    
    
    self.lblUpdateTime.font = font;
    self.lblDegree.frame = CGRectMake(245, 20, 20, 20);
    if (self.lblTemp.text.length<2) {
        self.lblDegree.frame = CGRectMake(210, 20, 20, 20);
    }
    self.lblDegree.hidden = NO;
    self.lblDegree.textAlignment = NSTextAlignmentLeft;
    if(!IsFoundCity)
    {
        // cityname = DEFAULT_CITY_NAME;
    }
    
    
    
    
    self.imgLocationIcon.frame = CGRectMake(5, main.size.height-85, 20, 20);
    
    self.imgLocationIcon.image = [UIImage imageNamed:@"location.png"];
    CGRect iconRect = self.imgLocationIcon.frame;
    iconRect.origin.x+=25;
    //iconRect.origin.y-=5;
    iconRect.size.width = 300.0;
    iconRect.size.height = 20.0;
    self.lblCityName.frame = iconRect;
    self.lblCityName.textAlignment = NSTextAlignmentLeft;
    
    self.lblCityName.font = [UIFont systemFontOfSize:12.0];
    
    
    int min = MIN([weather_info[@"sk2"][@"temp1"] intValue], [weather_info[@"sk2"][@"temp2"] intValue]);
    int max = MAX([weather_info[@"sk2"][@"temp1"] intValue], [weather_info[@"sk2"][@"temp2"] intValue]);
    self.lblMinMaxTemp.text= [NSString stringWithFormat:@"%d℃ / %d℃",min,max];
    
    
    
    self.lblUpdateTime.text = [NSString stringWithFormat:@"发布于%@ %@", [YBUtils convertChinaTimeStringByiOSDate:[NSDate date] withFormat:@"yyyy-MM-dd"], weather_info[@"sk"][@"time"]];
    self.lblUpdateTime.font = [UIFont systemFontOfSize:12.0];
    self.lblUpdateTime.textColor = [UIColor grayColor];
    self.lblUpdateTime.textAlignment = NSTextAlignmentLeft;
    
    
    
    
    self.lblIntro.font = font;
    self.lblIntro.text = weather_info[@"all"][@"index_d"];
    self.lblIntro.frame = CGRectMake(40, main.size.height-110, main.size.width-40, 60);
    //NSLog(@"%@",weather_info[@"all"][@"index_d"]);
    
    //self.lblIntro.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"coat"]];
    
    self.lblIntro.lineBreakMode = UILineBreakModeWordWrap;
    NSString *index_d = [NSString stringWithFormat:@"%@:%@", weather_info[@"all"][@"index"], weather_info[@"all"][@"index_d"]];
    CGSize size = {main.size.width-10,2000};
    CGSize labelsize = [index_d sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    self.lblIntro.frame = CGRectMake(10,main.size.height-130, labelsize.width, labelsize.height);
    [self Render4Days];
    
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [SVProgressHUD dismiss];
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.ScrollView.frame.size.width;
    
    int page =fabs(self.ScrollView.contentOffset.x / pageWidth);
    self.PageControl.currentPage = page;
    
}



- (IBAction)changePage:(id)sender {
    
    int page = self.PageControl.currentPage;
    
    [self.ScrollView setContentOffset:CGPointMake(310 * page, 0)];
    
}

-(void)_initLableAndImgView{
    
    CGRect frame = CGRectMake(5, 220, main.size.width-10, 100);
    
    self.ScrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.ScrollView.contentSize = CGSizeMake(620, 100);
    self.ScrollView.delegate = self;
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.layer.borderWidth = 1;
    self.ScrollView.layer.cornerRadius = 5;
    self.ScrollView.layer.masksToBounds=YES;
    frame.origin.y+=60;
    self.PageControl = [[UIPageControl alloc] initWithFrame:frame];
    self.PageControl.numberOfPages = 2;
    if([self.PageControl respondsToSelector:@selector(pageIndicatorTintColor)]){
        self.PageControl.pageIndicatorTintColor = [UIColor grayColor];
    }
    if ([self.PageControl respondsToSelector:@selector(currentPageIndicatorTintColor)]) {
        self.PageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    }
    self.PageControl.userInteractionEnabled = YES;
    [self.PageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.PageControl];
    UIColor *background = [UIColor  clearColor];
    lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 100, 60)];
    lbl1.backgroundColor = [UIColor yellowColor];
    img1 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 0, 30, 30)];
    
    
    
    img2 = [[UIImageView alloc] initWithFrame:CGRectMake(140, 0, 30, 30)];
    lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(105, 30, 100, 60)];
    
    img3 = [[UIImageView alloc] initWithFrame:CGRectMake(245, 0, 30, 30)];
    lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 100, 60)];
    
    
    
    img4 = [[UIImageView alloc] initWithFrame:CGRectMake(343, 0, 30, 30)];
    lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(310, 30, 100, 60)];
    
    
    
    img5 = [[UIImageView alloc] initWithFrame:CGRectMake(450, 0, 30, 30)];
    lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(415, 30, 100, 60)];
    lbl5.backgroundColor = background;
    
    
    img6 = [[UIImageView alloc] initWithFrame:CGRectMake(545, 0, 30, 30)];
    lbl6 = [[UILabel alloc] initWithFrame:CGRectMake(510, 30, 100, 60)];
    lbl6.backgroundColor = background;
    
    lbl1.backgroundColor = background;
    lbl2.backgroundColor = background;
    lbl3.backgroundColor = background;
    lbl4.backgroundColor = background;
    
    [self.view addSubview:self.ScrollView];
    
    
    
    
    
    
    
    [self.ScrollView addSubview:img1];
    [self.ScrollView addSubview:lbl1];
    [self.ScrollView addSubview:img2];
    [self.ScrollView addSubview:lbl2];
    [self.ScrollView addSubview:img3];
    [self.ScrollView addSubview:lbl3];
    [self.ScrollView addSubview:img4];
    [self.ScrollView addSubview:lbl4];
    [self.ScrollView addSubview:img5];
    [self.ScrollView addSubview:lbl5];
    [self.ScrollView addSubview:img6];
    [self.ScrollView addSubview:lbl6];
    
    
    
}


-(void)Render4Days{
    
    
    
    
    img1.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img1"]]];
    img1.contentMode = UIViewContentModeCenter;
    lbl1.text = [NSString stringWithFormat:@"%@\n%@\n%@",  @"今天",weather_info[@"all"][@"temp1"],weather_info[@"all"][@"weather1"]];
    
    lbl1.numberOfLines = 0;
    lbl1.lineBreakMode = UILineBreakModeWordWrap;
    lbl1.font = font;
    lbl1.textAlignment = NSTextAlignmentCenter;
    img2.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img3"]]];
    img2.contentMode = UIViewContentModeCenter;
    lbl2.textAlignment = NSTextAlignmentCenter;
    
    NSString *weekday = [utils GetChineseWeekDay:[[NSDate alloc] initWithTimeIntervalSinceNow:1*24*60*60]];
    lbl2.text = [NSString stringWithFormat:@"%@\n%@\n%@",weekday, weather_info[@"all"][@"temp2"],weather_info[@"all"][@"weather2"] ];
    
    lbl2.font = font;
    lbl2.numberOfLines = 0;
    lbl2.lineBreakMode = UILineBreakModeWordWrap;
    weekday = [utils GetChineseWeekDay:[[NSDate alloc] initWithTimeIntervalSinceNow:2*24*60*60]];
    lbl3.textAlignment = NSTextAlignmentCenter;
    lbl3.text = [NSString stringWithFormat:@"%@\n%@\n%@",weekday,weather_info[@"all"][@"temp3"],weather_info[@"all"][@"weather3"] ];
    
    lbl3.font = font;
    lbl3.numberOfLines = 0;
    lbl3.lineBreakMode = UILineBreakModeWordWrap;
    img3.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img5"]]];
    img3.contentMode = UIViewContentModeCenter;
    
    weekday = [utils GetChineseWeekDay:[[NSDate alloc] initWithTimeIntervalSinceNow:3*24*60*60]];
    
    
    
    lbl4.textAlignment = NSTextAlignmentCenter;
    lbl4.text = [NSString stringWithFormat:@"%@\n%@\n%@",weekday, weather_info[@"all"][@"temp4"] ,weather_info[@"all"][@"weather4"]];
    
    lbl4.font = font;
    lbl4.numberOfLines = 0;
    lbl4.lineBreakMode = UILineBreakModeWordWrap;
    
    img4.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img7"]]];
    img4.contentMode = UIViewContentModeCenter;
    
    
    
    
    weekday = [utils GetChineseWeekDay:[[NSDate alloc] initWithTimeIntervalSinceNow:4*24*60*60]];
    lbl5.textAlignment = NSTextAlignmentCenter;
    lbl5.text = [NSString stringWithFormat:@"%@\n%@\n%@",weekday, weather_info[@"all"][@"temp5"] ,weather_info[@"all"][@"weather5"]];
    
    lbl5.font = font;
    lbl5.numberOfLines = 0;
    lbl5.lineBreakMode = UILineBreakModeWordWrap;
    
    img5.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img9"]]];
    img5.contentMode = UIViewContentModeCenter;
    
    weekday = [utils GetChineseWeekDay:[[NSDate alloc] initWithTimeIntervalSinceNow:5*24*60*60]];
    lbl6.textAlignment = NSTextAlignmentCenter;
    lbl6.text = [NSString stringWithFormat:@"%@\n%@\n%@",weekday, weather_info[@"all"][@"temp6"] ,weather_info[@"all"][@"weather6"]];
    
    lbl6.font = font;
    lbl6.numberOfLines = 0;
    lbl6.lineBreakMode = UILineBreakModeWordWrap;
    
    img6.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%@s.png",weather_info[@"all"][@"img11"]]];
    img6.contentMode = UIViewContentModeCenter;
    self.ScrollView.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    UIButton *setting = [UIButton buttonWithType:UIButtonTypeInfoDark];
    setting.frame = CGRectMake(280, 10, 20, 20);
    [setting addTarget:self action:@selector(ToSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setting];
    
}


-(IBAction)ToSetting :(id)sender
{
    SettingViewController *set = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:set animated:YES];
}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSString *lat=[[NSString alloc] initWithFormat:@"%f",userLocation.coordinate.latitude];
    NSString *lng=[[NSString alloc] initWithFormat:@"%f",userLocation.coordinate.longitude];
    
    NSLog(@"%@,%@",lat,lng);
    
}

- (void)viewDidLoad
{
    tryCount = 0;
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.Query = [[YBWeatherQuery alloc] init];
    [SVProgressHUD showWithStatus:@"正在更新..."];
    
    IsFoundCity = YES;
    
    
    main = [UIScreen mainScreen].bounds;
    self.title = @"简约天气";
    
    
    //    self.mpview = [[MKMapView alloc ] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //    self.mpview.showsUserLocation = YES;
    //    self.mpview.mapType = MKMapTypeStandard;
    //    self.mpview.delegate = self;
    //    [self.view addSubview:self.mpview];
    //
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(BtnPress:)];
    self.navigationItem.rightBarButtonItem.tag = 0;
    
    
    
    if(![self CheckNetwork])
    {
        [SVProgressHUD showErrorWithStatus:@"没有网络连接\nno network connection"];
        [self LoadError:@"没有网络连接\nno network connection"];
        return;
    }
    
    FirstTimeStamp = (double)[[NSDate date] timeIntervalSince1970];
    
    self.lblDegree.hidden = YES;
    utils = [[YBUtils alloc] init];
    
    [utils Load];
    AllCitys = utils.AllCitys;
    
    [self _initLableAndImgView];
    
    
    weather_info =  [self.Query LoadWeatherFromLocal];
    if(weather_info)
    {
        
        [self LoaddingWeather];
        [SVProgressHUD showWithStatus:@"正在更新..."];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ToMapDetail:)];
    
    singleTap.numberOfTouchesRequired = 1;
    [self.imgLocationIcon addGestureRecognizer:singleTap];
    self.imgLocationIcon.userInteractionEnabled =NO;// YES;
    // self.lblCityName.text = @"正在定位......";
    self.lblCityName.numberOfLines=1;
    [self Start];
    
    self.ReloadImage =[[UIButton alloc] init];
    self.ReloadImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reload"]];
    self.ReloadImage.frame = CGRectMake(5, main.size.height-50, 20, 20);
    [self.ReloadImage addTarget:self action:@selector(BtnPress:) forControlEvents:UIControlEventTouchUpInside];
    self.lblUpdateTime.frame = CGRectMake(30, main.size.height-50, 200, 20);
    
    
    
    
    [self.view addSubview:self.ReloadImage];
    
    
    
}

-(IBAction)ToMapDetail  :(id)sender
{
    MapKitViewController *map = [[MapKitViewController alloc] init];
    [self.navigationController pushViewController:map animated:YES];
}

-(void)BtnPress:(UIButton *)sender{
    if(sender.tag==0)
    {
        
        IsLoadedWeather = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [SVProgressHUD showWithStatus:@"正在更新..."];
        [self Start];
    }
    else if(sender.tag==10)
    {
        
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [self CheckGPSWithBoth:NO];
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
    
    [self setLblIntro:nil];
    [self setLblPM25:nil];
    [super viewDidUnload];
}
@end
