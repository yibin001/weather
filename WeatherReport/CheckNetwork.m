//
//  CheckNetwork.m
//  WeatherReport
//
//  Created by yibin on 13-2-18.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "CheckNetwork.h"

#import "CheckNetwork.h"
#import "Reachability.h"
@implementation CheckNetwork
+(BOOL)isExistenceNetwork
{
	BOOL isExistenceNetwork;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork=FALSE;
            
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=TRUE;
                       break;
        case ReachableViaWiFi:
			isExistenceNetwork=TRUE;
           
            break;
    }

	return isExistenceNetwork;
}
@end