//
//  LLCartoonTableCell.m
//  Amul
//
//  Created by Aravind Krishnaswamy on 10/09/12.
//  Copyright (c) 2012 Aravind Krishnaswamy. All rights reserved.
//

#import "LLCartoonTableCell.h"

@implementation LLCartoonTableCell
@synthesize image;
@synthesize label;
@synthesize alt;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClickShareButton:(id)sender {
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        void (^notificationHandler) (NSNotification *) = ^(NSNotification *note){
            NSString* note_name = [note name];
            [GANTracker sendEventWithCategory:@"Share_Tile_Progress" withAction:alt withLabel:note_name withValue:[NSNumber numberWithInt:0]];
            NSLog(@"Tile>>Share_Tile>>%@", note_name);
        };
        
        [[NSNotificationCenter defaultCenter] addObserverForName:@"SHKSendDidStartNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:notificationHandler];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"SHKSendDidFinish" object:nil queue:[NSOperationQueue mainQueue] usingBlock:notificationHandler];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"SHKSendDidFailWithError" object:nil queue:[NSOperationQueue mainQueue] usingBlock:notificationHandler];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"SHKSendDidCancel" object:nil queue:[NSOperationQueue mainQueue] usingBlock:notificationHandler];
    });
    

    
    UIImage *backgroundImage = [[self image] image];
    UIImage *watermarkImage = [UIImage imageNamed:@"AppStore.png"];
    
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    [watermarkImage drawInRect:CGRectMake(0, backgroundImage.size.height - watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    SHKItem *item = [SHKItem image:result title:@"Check out this awesome cartoon from the Amul Cartoon Ads iPhone app!"];
    [SHKFacebook shareItem:item];
    [GANTracker sendEventWithCategory:@"Tile" withAction:@"Share_Tile" withLabel:alt withValue:[NSNumber numberWithInt:0]];
    [GANTracker sendEventWithCategory:@"Share_Tile_Progress" withAction:alt withLabel:@"SHKSendDidStart" withValue:[NSNumber numberWithInt:0]];
}
@end
