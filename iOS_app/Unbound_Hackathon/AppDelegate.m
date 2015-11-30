//
//  UnBound Hackathon Sample Code
//
//  SAMPLE CODE FOR BARCLAYS HACKATHON PURPOSES ONLY. CODE, DATA AND INTERFACE PRESENTED
//  IN NO WAY RESEMBLES BARCLAYS PRODUCTION OR TEST APPLICATIONS.
//
//  Copyright © 2015 Barclays Bank PLC. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // check if this has returned from launchpad sharing
    if([url.host isEqualToString:LaunchpadReturnUrlShare]) {
        // do something with the response
        [[NSNotificationCenter defaultCenter] postNotificationName:LaunchpadReturnedNotificationShare object:url userInfo:@{ @"token" : url.query }];
    }
    // check if this has returned from launchpad payment
    if([url.host isEqualToString:LaunchpadReturnUrlPayment]) {
        // do something with the response
        [[NSNotificationCenter defaultCenter] postNotificationName:LaunchpadReturnedNotificationPayment object:url userInfo:@{ @"transactionId" : url.query }];
    }
    return YES;
}

@end
