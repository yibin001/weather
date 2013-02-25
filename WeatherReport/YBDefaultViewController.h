//
//  YBDefaultViewController.h
//  WeatherReport
//
//  Created by yibin on 13-2-22.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBSingleWeatherViewController.h"
@interface YBDefaultViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    BOOL pageControllIsChangingPage;
    NSMutableArray *WeatherViews;
    NSArray *images;
    NSMutableArray *citys;
}

-(void)changePage : (id)sender;

-(void)setupPage;
@end
