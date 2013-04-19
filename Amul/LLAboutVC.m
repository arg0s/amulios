//
//  LLAboutVC.m
//  Amul
//
//  Created by Aravind Krishnaswamy on 10/09/12.
//  Copyright (c) 2012 Aravind Krishnaswamy. All rights reserved.
//

#import "LLAboutVC.h"

@interface LLAboutVC ()

@end

@implementation LLAboutVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        void (^notificationHandler) (NSNotification *) = ^(NSNotification *note){
            NSString* note_name = [note name];
            [GANTracker sendEventWithCategory:@"About" withAction:@"Share_Link" withLabel:note_name withValue:[NSNumber numberWithInt:0]];
            NSLog(@"About>>Share>>%@", note_name);
        };
        
        [[NSNotificationCenter defaultCenter] addObserverForName:@"SHKSendDidStartNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:notificationHandler];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"SHKSendDidFinish" object:nil queue:[NSOperationQueue mainQueue] usingBlock:notificationHandler];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"SHKSendDidFailWithError" object:nil queue:[NSOperationQueue mainQueue] usingBlock:notificationHandler];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"SHKSendDidCancel" object:nil queue:[NSOperationQueue mainQueue] usingBlock:notificationHandler];
    });

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)openShare:(id)sender {
	NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/app/amul-cartoon-ads/id363119867"];

    SHKItem* item = [SHKItem URL:url title:@"Amul Cartoon Ads iPhone app is Awesome!" contentType:SHKURLContentTypeWebpage];
    
    [SHKFacebook shareItem:item];
    [GANTracker sendEventWithCategory:@"About" withAction:@"Share_Link" withLabel:@"iTunes Link" withValue:[NSNumber numberWithInt:0]];
    [GANTracker sendEventWithCategory:@"About" withAction:@"Share_Link" withLabel:@"SHKSendDidStart" withValue:[NSNumber numberWithInt:0]];
    
}

- (IBAction)doneClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sharerStartedSending:(SHKSharer *)sharer
{
    
	NSLog(@"HELLLLLO, anyone home??");
}


@end
