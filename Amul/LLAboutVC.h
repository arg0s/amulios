//
//  LLAboutVC.h
//  Amul
//
//  Created by Aravind Krishnaswamy on 10/09/12.
//  Copyright (c) 2012 Aravind Krishnaswamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Amul.h"


@interface LLAboutVC : UIViewController<SHKSharerDelegate>
- (IBAction)openShare:(id)sender;
- (IBAction)doneClicked:(id)sender;

@end
