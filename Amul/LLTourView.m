//
//  LLTourView.m
//  Amul
//
//  Created by Aravind Krishnaswamy on 19/04/13.
//  Copyright (c) 2013 Aravind Krishnaswamy. All rights reserved.
//

#import "LLTourView.h"

@implementation LLTourView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)btnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"walkthrough_complete" object:nil];
}
@end
