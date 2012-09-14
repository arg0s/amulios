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

    return YES;
}

+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].usesUntilPrompt = 15;
}

@end
