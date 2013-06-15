//
//  SettingViewController.m
//  WeatherReport
//
//  Created by yibin on 13-6-15.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "SettingViewController.h"
#import "WeatherData.h"
#import "SVProgressHUD.h"
@interface SettingViewController ()
{
   
}
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)Load{
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"国家气象局",@"OpenWeather"]];
    self.segment.frame = CGRectMake(5, 40, 300, 40);
    self.segment.selectedSegmentIndex = [WeatherData LoadSource];
    [self.segment addTarget:self action:@selector(SetSource:) forControlEvents:UIControlEventValueChanged];
    self.segment.tag = 100;
    [self.view addSubview:self.segment];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"数据源设定";
    [self Load];
    
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(Done:)];
    self.navigationItem.rightBarButtonItem = done;
    
	// Do any additional setup after loading the view.
}

-(IBAction)SetSource :(UISegmentedControl *)sender
{
    
    [WeatherData SetSource:sender.selectedSegmentIndex];
    [SVProgressHUD showSuccessWithStatus:@"设定成功,下次启动时生效."];
}

-(IBAction)Done:(id)sender
{
    [SVProgressHUD dismiss];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES];
    
    UISegmentedControl *_seg = (UISegmentedControl *)[self.view viewWithTag:100];
    if(_seg)
    {
        _seg.selectedSegmentIndex = [WeatherData LoadSource];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
