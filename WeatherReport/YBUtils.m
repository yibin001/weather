//
//  YBUtils.m
//  WeatherReport
//
//  Created by yibin on 13-2-16.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "YBUtils.h"
@interface YBUtils()
{
    NSDictionary *dict;
    NSDictionary *weekday;
    NSString *city_archive_path;
}
@end

@implementation YBUtils
@synthesize AllCitys = _AllCitys;
@synthesize AllProvince = _AllProvince;
@synthesize FavoriteCity = _FavoriteCity;
-(id)init{
    self = [super init];
    if (self) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        dict =[NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        city_archive_path = [documentsDirectory stringByAppendingString:@"city.archive"];
    }
    return self;
}

-(void)Load{
    
    _AllCitys = [[NSMutableArray alloc] init];
    _AllProvince= dict.allKeys;
    for (NSString *p in _AllProvince) {
        for (NSDictionary *di in dict[p]) {
            [_AllCitys addObject:di];
        }
    }
}


-(void)LoadFavoriteCitys{
  
    
    
    _FavoriteCity = [NSKeyedUnarchiver unarchiveObjectWithFile:city_archive_path];
}

-(void)SaveFavoriteCitys:(NSDictionary *)city{
        _FavoriteCity = [NSKeyedUnarchiver unarchiveObjectWithFile:city_archive_path];
    if (_FavoriteCity == nil) {
        _FavoriteCity = [[NSMutableArray alloc] init];
    }
 
    [_FavoriteCity addObject:city];
    
    [NSKeyedArchiver archiveRootObject:_FavoriteCity toFile:city_archive_path];
   
}

-(void)Save
{
   
    [NSKeyedArchiver archiveRootObject:self.FavoriteCity toFile:city_archive_path];

}


-(NSString *)GetChineseWeekDay:(NSDate *)date{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
    NSInteger _weekday = [weekdayComponents weekday];
    switch (_weekday) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
            
        default:
            break;
    }
    return @"星期六";
}

@end
