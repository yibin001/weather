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


-(NSString *)AppName{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

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
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
            
        default:
            break;
    }
    return @"周六";
}

+(NSString *)convertChinaTimeStringByiOSDate:(NSDate *)localDate withFormat:(NSString *)format
{
    NSDateFormatter *formatter    =  [[NSDateFormatter alloc] init];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *chinaDate = [formatter stringFromDate:localDate];
    return chinaDate;
}

+(NSDictionary *)ConvertToSimpleCity:(NSDictionary *)GoogleMap{
    
    @autoreleasepool {
        
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"address"] = @"";
    dict[@"city"] = @"";
    dict[@"country"] = @"";
    if([GoogleMap[@"status"] isEqualToString:@"OK"])
    {
        NSArray *compare = [NSArray arrayWithObjects:@"sublocality",@"political", nil];
        NSArray *compare_1 =  [NSArray arrayWithObjects:@"locality",@"political", nil];
        NSArray *data = GoogleMap[@"results"];
        for (NSDictionary *item in data) {
            if ([item[@"types"] isEqualToArray:compare]) {
                dict[@"address"] = item[@"formatted_address"];
                for (NSDictionary *_item in item[@"address_components"]) {
                    if([_item[@"types"] isEqualToArray:compare_1])
                    {
                        dict[@"city"] = _item[@"long_name"];
                    }
                    if([_item[@"types"] isEqualToArray:[NSArray arrayWithObjects:@"country",@"political", nil]])
                    {
                        
                        dict[@"country"] = _item[@"long_name"];
                    }
                   
                }
                
                break;
            }
        }
    }
    return dict;
    }
}

+(NSDictionary *)ConvertPM25ToString:(NSNumber *)Num{
    int i = [Num intValue];
    if(i>=0 && i <=50)
    {
        return @{@"rank":@"0",@"summary": @"优"};
    }
    if (i>50 && i<101) {
         return @{@"rank":@"1",@"summary": @"良"};
      
    }
    if (i>100 && i<151) {
       
           return @{@"rank":@"2",@"summary": @"轻微污染"};
    }
    if(i>151 && i<201)
        
       return @{@"rank":@"3",@"summary": @"轻度污染"};
    if (i>200 && i<251) {
       
           return @{@"rank":@"4",@"summary": @"中度污染"};
    }
    if(i>250 && i<301){
       
           return @{@"rank":@"5",@"summary": @"中度重污染"};
    }
    if(i>300 && i<501)
       
       return @{@"rank":@"6",@"summary": @"重污染"};
    return @{@"rank":@"7",@"summary": @"极度污染"};
   
}


+(NSString *)ChineseToPinYin:(NSString *)Chinaese{
    NSMutableString *string = [@"你好" mutableCopy];
    NSLog(@"Before: %@", string); // Before: 你好
    CFStringTransform((__bridge CFMutableStringRef)string, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"After: %@", string);  // After: nǐ hǎo
    CFStringTransform((__bridge CFMutableStringRef)string, NULL, kCFStringTransformStripDiacritics, NO);
    NSLog(@"Striped: %@", string); // Striped: ni hao
    return string;
}

@end
