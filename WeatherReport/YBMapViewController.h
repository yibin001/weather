//
//  YBMapViewController.h
//  WeatherReport
//
//  Created by yibin on 13-5-4.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface YBMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *TextView;
@property (weak, nonatomic) IBOutlet MKMapView *MapView;

@property  CLLocationCoordinate2D CurrentLocaltion;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

-(void)LoadMapInfo;
@end
