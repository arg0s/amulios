//
//  LLAppDelegate.m
//  Amul
//
//  Created by Aravind Krishnaswamy on 10/09/12.
//  Copyright (c) 2012 Aravind Krishnaswamy. All rights reserved.
//

#import "LLAppDelegate.h"
#import "LLAmulSHKConfigurator.h"
#import "SHKConfiguration.h"
#import "Amul.h"

@implementation LLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    LLAmulSHKConfigurator *configurator = [[LLAmulSHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    [SHK flushOfflineQueue];
    //Init Airship launch options
    NSMutableDictionary *takeOffOptions = [[NSMutableDictionary alloc] init];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    // Disabling for now so we can enable after user accepts T&Cs
    [UAPush setDefaultPushEnabledValue:YES];
    [UAirship takeOff:takeOffOptions];

    // Register for notifications
    [[UAPush shared]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert)];
    
    [[UAPush shared] setAutobadgeEnabled:YES];
    [[UAPush shared] resetBadge];
    
    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    
    if (!!userInfo){
        [self application:application didReceiveRemoteNotification:userInfo];
    }

    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 10;
    // Optional: set debug to YES for extra debugging information.
    //[GAI sharedInstance].debug = YES;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-35664860-2"];
    
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [UAirship land];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"application:didRegisterForRemoteNotificationsWithDevicetoken:%@", deviceToken);
    // Updates the device token and registers the token with UA
    
    UALOG(@"APN device token: %@", deviceToken);
    
    [[UAPush shared] registerDeviceToken:deviceToken];
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"most_recent_device_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSNumber* session_count = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_count"];
    NSString* new_session_count = [[NSNumber numberWithInt:([session_count intValue] + 1)] stringValue];

    
    // Set some commonly used tags
    NSMutableArray *tags = [UATagUtils createTags:
                            (UATagTypeTimeZoneAbbreviation
                             | UATagTypeLanguage
                             | UATagTypeCountry
                             | UATagTypeDeviceType)];
    
    [tags addObject:new_session_count];
    
    [[UAPush shared] setTags:[NSArray arrayWithArray:tags]]; // localupdate
    [[UAPush shared] updateRegistration];//update server
   
}


-(void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failing in APNS registration: %@",error);
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError:%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"application:didReceiveRemoteNotification");
    //   [[UAPush shared] handleNotification:userInfo
    //                      applicationState:application.applicationState];
    [[UAPush shared] resetBadge]; // zero badge after push received
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"most_recent_remote_notification"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString* payload = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (!!payload) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Amul Ad!" message:payload delegate:self cancelButtonTitle:@"Browse Ads" otherButtonTitles:nil];
        [alert show];
    }
}



+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 1;
    [iRate sharedInstance].usesUntilPrompt = 2;
}

@end
