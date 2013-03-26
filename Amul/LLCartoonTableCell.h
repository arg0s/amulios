//
//  LLCartoonTableCell.h
//  Amul
//
//  Created by Aravind Krishnaswamy on 10/09/12.
//  Copyright (c) 2012 Aravind Krishnaswamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Amul.h"

@interface LLCartoonTableCell : UITableViewCell{
    
    UIImageView *image;
    UILabel *label;
}

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *label;

- (IBAction)didClickShareButton:(id)sender;

@end
