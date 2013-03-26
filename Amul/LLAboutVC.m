//
//  LLAboutVC.m
//  Amul
//
//  Created by Aravind Krishnaswamy on 10/09/12.
//  Copyright (c) 2012 Aravind Krishnaswamy. All rights reserved.
//

#import "LLAboutVC.h"
#import "SHKFacebook.h"

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
	SHKItem *item = [SHKItem URL:url title:@"Amul Cartoon Ads is Awesome!"];
    
	// Get the ShareKit action sheet
//	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
	// Display the action sheet
	//[actionSheet showFromToolbar:self.navigationController.toolbar];
    //[SHKFacebook shareItem:item];

}
@end
