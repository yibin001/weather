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
  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingString:@"city.archive"];
    
    _FavoriteCity = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}

-(void)SaveFavoriteCitys:(NSDictionary *)city{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingString:@"city.archive"];
    
    _FavoriteCity = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    if (_FavoriteCity == nil) {
        _FavoriteCity = [[NSMutableArray alloc] init];
    }
 
    [_FavoriteCity addObject:city];
    
    [NSKeyedArchiver archiveRootObject:_FavoriteCity toFile:file];
   
}

-(void)Save
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingString:@"city.archive"];
    [NSKeyedArchiver archiveRootObject:self.FavoriteCity toFile:file];

}

@end
