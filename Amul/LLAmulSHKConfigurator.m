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

- (NSArray*)defaultFavoriteURLSharers {
    return [NSArray arrayWithObjects:@"SHKTwitter",@"SHKFacebook", @"SHKMail", nil];
}

- (NSString*)twitterConsumerKey {
	return @"l1X0roMFqr6Qr3mwhzqBg";
}

- (NSString*)twitterSecret {
	return @"6R16ri2MMx5nwCuVqfKU51dMrkm4vD6WryCuXGjdXxM";
}
// You need to set this if using OAuth, see note above (xAuth users can skip it)
- (NSString*)twitterCallbackUrl {
	return @"";
}
// To use xAuth, set to 1
- (NSNumber*)twitterUseXAuth {
	return [NSNumber numberWithInt:1];
}


@end
