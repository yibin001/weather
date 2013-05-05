//
//  YBMainViewController.m
//  WeatherReport
//
//  Created by yibin on 13-5-5.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "YBMainViewController.h"
#import "YBAutomaticViewController.h"
@interface YBMainViewController ()

@end

@implementation YBMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)Reload{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.ScrollView = [[UIScrollView alloc ] initWithFrame:CGRectMake(0, 0, 320, 300)];
    YBAutomaticViewController *autoView = [[YBAutomaticViewController alloc] init];
    [self.ScrollView addSubview:autoView];
    self.ScrollView.contentSize = CGSizeMake(320, 800);
    [self.view addSubview:self.ScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
