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
            //   NSLog(@"娌℃湁缃戠粶");
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=TRUE;
            //   NSLog(@"姝ｅ湪浣跨敤3G缃戠粶");
            break;
        case ReachableViaWiFi:
			isExistenceNetwork=TRUE;
            //  NSLog(@"姝ｅ湪浣跨敤wifi缃戠粶");
            break;
    }
//	if (!isExistenceNetwork) {
//		UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:@"璀﹀憡" message:@"缃戠粶涓嶅瓨鍦�" delegate:self cancelButtonTitle:@"纭" otherButtonTitles:nil,nil];
//		[myalert show];
//		[myalert release];
//	}
	return isExistenceNetwork;
}
@end