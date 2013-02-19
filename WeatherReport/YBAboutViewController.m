//
//  YBAboutViewController.m
//  WeatherReport
//
//  Created by yibin on 13-2-19.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "YBAboutViewController.h"
#import "YBSelectCityViewController.h"
@interface YBAboutViewController ()

@end

@implementation YBAboutViewController
@synthesize lblVersion = _lblVersion;
@synthesize navigation = _navigation;

-(void)PopSelected{
    YBSelectCityViewController *s = [[YBSelectCityViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:s animated:YES];
    //[self presentModalViewController:s animated:YES];
}


-(void)MakeButton{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(PopSelected)];
    UIBarButtonItem *buttonItem = rightButton;
    self.navigationItem.rightBarButtonItem = buttonItem;
   
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
                
//        YBSelectCityViewController *selected = [[YBSelectCityViewController alloc] initWithNibName:nil bundle:nil];
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"城市";
    [self MakeButton];
    self.lblVersion = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.lblVersion.numberOfLines = 2;
    self.lblVersion.text = @"敬请期待......";
    self.lblVersion.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.lblVersion];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
