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
@property (nonatomic,strong) NSMutableArray *FavoriteCity;
@property (readonly, nonatomic,strong) NSString *AppName;
-(void) Load;
-(void) LoadFavoriteCitys;
-(void) SaveFavoriteCitys :(NSDictionary *)city;
-(void) Save;
-(NSString *)GetChineseWeekDay:(NSDate *)date;
+(NSString *)convertChinaTimeStringByiOSDate:(NSDate *)localDate withFormat:(NSString *)format;


+(NSDictionary *)ConvertPM25ToString : (NSNumber *)Num;

+(NSDictionary *)ConvertToSimpleCity:(NSDictionary *)GoogleMap;

+(NSString *)ChineseToPinYin:(NSString *)Chinaese;

@end
