//
//  UnBound Hackathon Sample Code
//
//  SAMPLE CODE FOR BARCLAYS HACKATHON PURPOSES ONLY. CODE, DATA AND INTERFACE PRESENTED
//  IN NO WAY RESEMBLES BARCLAYS PRODUCTION OR TEST APPLICATIONS.
//
//  Copyright © 2015 Barclays Bank PLC. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayReturnedToken:) name:LaunchpadReturnedNotificationShare object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayReturnedPaymentAuthorisation:) name:LaunchpadReturnedNotificationPayment object:nil];


    /// Tallysticks integration via WEBVIEW

    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;

    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8888"]];
    [self.webView loadRequest:request];



    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    //[self.webView loadRequest:[NSURLRequest requestWithURL:url]];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private


- (void)displayReturnedPaymentAuthorisation:(NSNotification *)notification {
    NSURL *url = notification.object;
    NSString *query = url.query;
    
    NSLog(@"Got back reference number: \n\n%@\n\n", query);
    
    NSString *jsString = [NSString stringWithFormat:@"$('.data').html('%@')", query];
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

- (NSString *)stringForArray:(NSArray *)array {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - Public

- (IBAction)pressedBasicToken:(id)sender {
    NSString *amountVal = [self.webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"invoice[amount]\"]').val()"];
    NSString *refVal = [self.webView stringByEvaluatingJavaScriptFromString:@"$('input[name=\"invoice[id]\"]').val()"];


    // SIMPLE PAYMENT
    NSString *merchantId = @"1544247154466553"; // 9956235654444678
    NSString *amount = amountVal;
    NSString *reference = refVal;
    NSString *returnUrl = [NSString stringWithFormat:@"%@%@", UnboundUrlSchemeHost, LaunchpadReturnUrlPayment];
    NSString *urlString = [NSString stringWithFormat:@"launchpad://payment?merchantId=%@&amount=%@&reference=%@&returnUrl=%@", merchantId, amount, reference, returnUrl];
    NSLog(@"%@", urlString);
    NSURL *URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:URL];


    // GET TOKEN
    // NSString *participantId = @"1248751651984582";
    // NSString *accessLevel = @"basic";
    // NSString *displayName = @"Unbound Hackathon App";
    // NSString *returnUrl = [NSString stringWithFormat:@"%@%@", UnboundUrlSchemeHost, LaunchpadReturnUrlShare];
    // NSString *urlString = [NSString stringWithFormat:@"launchpad://token?participantId=%@&accessLevel=%@&displayName=%@&returnUrl=%@", participantId, accessLevel, displayName, returnUrl];
    // NSURL *URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // [[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)pressedPaymentToken:(id)sender {
    NSString *participantId = @"1248751651984582";
    NSString *accessLevel = @"full";
    NSString *displayName = @"Unbound Hackathon App";
    NSString *returnUrl = [NSString stringWithFormat:@"%@%@", UnboundUrlSchemeHost, LaunchpadReturnUrlShare];
    NSString *urlString = [NSString stringWithFormat:@"launchpad://token?participantId=%@&accessLevel=%@&displayName=%@&returnUrl=%@", participantId, accessLevel, displayName, returnUrl];
    NSURL *URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)pressedSimplePayment:(id)sender {
    NSString *merchantId = @"1544247154466553";
    NSString *amount = @"1.5";
    NSString *reference = @"REF12345";
    NSString *returnUrl = [NSString stringWithFormat:@"%@%@", UnboundUrlSchemeHost, LaunchpadReturnUrlPayment];
    NSString *urlString = [NSString stringWithFormat:@"launchpad://payment?merchantId=%@&amount=%@&reference=%@&returnUrl=%@", merchantId, amount, reference, returnUrl];
    NSLog(@"%@", urlString);
    NSURL *URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)pressedPaymentWithMetaData:(id)sender {
    NSString *merchantId = @"1544247154466553";
    NSString *amount = @"1.5";
    NSString *reference = @"REF12345";
    NSString *metadata = [self stringForArray:@[ @{ @"key" : @"test1", @"value" : @"value1" }, @{ @"key" : @"test2", @"value" : @"value2" } ]];
    NSString *tags = [self stringForArray:@[ @"holiday", @"savings" ]];
    NSString *returnUrl = [NSString stringWithFormat:@"%@%@", UnboundUrlSchemeHost, LaunchpadReturnUrlPayment];
    NSString *urlString = [NSString stringWithFormat:@"launchpad://payment?merchantId=%@&amount=%@&reference=%@&metadata=%@&tags=%@&returnUrl=%@", merchantId, amount, reference, metadata, tags, returnUrl];
    NSURL *URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:URL];
}

@end
