//
//  YBMapViewController.m
//  WeatherReport
//
//  Created by yibin on 13-5-4.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "YBMapViewController.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"

@interface YBMapViewController ()

@end

@implementation YBMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)LoadMapInfo{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",self.CurrentLocaltion.latitude,self.CurrentLocaltion.longitude]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        @try {
            NSArray *array = JSON[@"results"];
            
            NSString *address = array[0][@"formatted_address"];
            
            self.TextView.text =[NSString stringWithFormat:@"%f,%f\n%@",self.CurrentLocaltion.latitude,self.CurrentLocaltion.longitude, address];
        }
        @catch (NSException *exception) {
            self.TextView.text = [NSString stringWithFormat:@"%@",exception];
        }
        @finally {
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        self.TextView.text = [NSString stringWithFormat:@"%@",error];
    }];
    
    
    
    [operation start];
}
-(void)viewWillAppear:(BOOL)animated{
    [SVProgressHUD showWithStatus:@"正在加载......"];
    [self LoadMapInfo];
    [SVProgressHUD dismiss];
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
