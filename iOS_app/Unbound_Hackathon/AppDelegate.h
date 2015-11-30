//
//  UnBound Hackathon Sample Code
//
//  SAMPLE CODE FOR BARCLAYS HACKATHON PURPOSES ONLY. CODE, DATA AND INTERFACE PRESENTED
//  IN NO WAY RESEMBLES BARCLAYS PRODUCTION OR TEST APPLICATIONS.
//
//  Copyright © 2015 Barclays Bank PLC. All rights reserved.
//

#import <UIKit/UIKit.h>

// Needs to be defined in the info.plist so that Launchpad can use it to return upon completion
static NSString *const UnboundUrlSchemeHost = @"unbound://";

static NSString *const LaunchpadReturnUrlShare = @"launchpad-return-url-share";
static NSString *const LaunchpadReturnUrlPayment = @"launchpad-return-url-payment";
static NSString *const LaunchpadReturnedNotificationShare = @"LaunchpadReturnedNotificationShare";
static NSString *const LaunchpadReturnedNotificationPayment = @"LaunchpadReturnedNotificationPayment";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

