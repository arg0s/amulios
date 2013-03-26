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
	return @"460600007296628";
}

- (NSString*)facebookLocalAppId {
	return @"5628c24dc0235fca52b1fe93a300dd85";
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
