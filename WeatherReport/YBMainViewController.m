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

- (void)viewDidLoad
{
    self.ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.ScrollView setContentSize:CGSizeMake(320, 960)];
    self.ScrollView.delegate = self;
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.showsVerticalScrollIndicator = YES;
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    YBAutomaticViewController *WeatherMain = [[YBAutomaticViewController alloc] init];
    [self.ScrollView addSubview:WeatherMain];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
