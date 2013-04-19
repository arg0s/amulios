//
//  LLCartoonsTableVC.h
//  Amul
//
//  Created by Aravind Krishnaswamy on 10/09/12.
//  Copyright (c) 2012 Aravind Krishnaswamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Amul.h"

@interface LLCartoonsTableVC : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
    
    id data;
    UIPickerView *picker;
    UIView *infoView;
    NSMutableArray* expandedCells;
}

@property (nonatomic, strong) id data;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (nonatomic, strong) NSMutableArray* expandedCells;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnCalendar;

- (IBAction)showPicker:(id)sender;

@end
