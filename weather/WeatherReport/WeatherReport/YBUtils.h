//
//  YBUtils.h
//  WeatherReport
//
//  Created by yibin on 13-2-16.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBUtils : NSObject
@property (nonatomic,strong) NSMutableArray *AllCitys;
@property (nonatomic,strong) NSArray *AllProvince;
-(void) Load;
@end
