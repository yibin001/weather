//
//  WeatherData.h
//  WeatherReport
//
//  Created by yibin on 13-6-15.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject
+(NSInteger)LoadSource;
+(void)SetSource:(NSInteger)SourceID;
@end
