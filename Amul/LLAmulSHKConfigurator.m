//
//  LLAmulSHKConfigurator.m
//  Amul
//
//  Created by Aravind Krishnaswamy on 11/09/12.
//  Copyright (c) 2012 Aravind Krishnaswamy. All rights reserved.
//

#import "LLAmulSHKConfigurator.h"

@implementation LLAmulSHKConfigurator

- (NSString*)facebookAppId {
	return @"XXXXXXXXXXXXXXXXXXX";
}

- (NSString*)facebookLocalAppId {
	return @"XXXXXXXXXXXXXXXXXXXXXXX";
}

- (NSString*)appName {
	return @"Amul Cartoon Ads";
}

- (NSString*)appURL {
	return @"http://itunes.apple.com/us/app/amul-cartoon-ads/id363119867";
}


- (NSArray*)facebookListOfPermissions {
    return [NSArray arrayWithObjects:@"publish_stream", @"user_about_me", @"user_birthday",nil];
}

@end
