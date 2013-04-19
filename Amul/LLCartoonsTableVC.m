//
//  LLCartoonsTableVC.m
//  Amul
//
//  Created by Aravind Krishnaswamy on 10/09/12.
//  Copyright (c) 2012 Aravind Krishnaswamy. All rights reserved.
//

#import "LLCartoonsTableVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Amul.h"

@interface LLCartoonsTableVC ()


@end

@implementation LLCartoonsTableVC

@synthesize  data;
@synthesize picker;
@synthesize expandedCells;

#define AMUL_S3_JSON @"http://d1832ahxutkhx9.cloudfront.net/amul.json"
#define AMUL_S3_JSON_LIVE @"http://akiaiwzoruprm2wjp2jq-amul-bucket.s3.amazonaws.com/amul.json"

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadModel{
    
    [[DejalActivityView activityViewForView:self.view withLabel:@"Say makkan..."] setShowNetworkActivityIndicator:YES];
    
    [[LRResty client] get:AMUL_S3_JSON withBlock:^(LRRestyResponse *response) {
        [DejalActivityView removeView];
        if ([response status] == 200){
            NSError* error;
            id responseObj = [NSJSONSerialization JSONObjectWithData:[[response asString] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
            NSLog(@"Sections: %i", [responseObj count]);
            self.data = responseObj;
            self.expandedCells = [NSMutableArray array];
            [[self tableView] reloadData];
            [[self picker] reloadAllComponents];
            [[self tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [[self btnCalendar] setEnabled:YES];
        }
        else{
            NSLog(@"Unable to load data feed");
            BlockAlertView* alert = [[BlockAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to load cartoon ads. Please try again later!"];
            [alert addButtonWithTitle:@"OK" block:^(void){
//                exit(1);
            }];
            [alert show];
        }
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNumber* session_count = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_count"];

    if ([session_count intValue]==0) {
        // Create the walkthrough view controller
        LAWalkthroughViewController *walkthrough = LAWalkthroughViewController.new;
        walkthrough.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        walkthrough.backgroundImage = [UIImage imageNamed:@"tour-bg1@2x"];
        
        // Create pages of the walkthrough from XIBs
        [walkthrough addPageWithNibName:@"TourView1" bundle:nil];
        [walkthrough addPageWithNibName:@"TourView2" bundle:nil];
        [walkthrough addPageWithNibName:@"TourView3" bundle:nil];
        [walkthrough addPageWithNibName:@"TourView4" bundle:nil];
        [walkthrough addPageWithNibName:@"TourView5" bundle:nil];
        [walkthrough addPageWithNibName:@"TourView6" bundle:nil];
        [walkthrough addPageWithNibName:@"TourView7" bundle:nil];
        
        // Use text for the next button
        walkthrough.nextButtonText = @"Next >";
        
        // Add the walkthrough view to your view controller's view
        [self addChildViewController:walkthrough];
        [self.view addSubview:walkthrough.view];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"walkthrough_complete" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [walkthrough.view removeFromSuperview];
            [self loadModel];
            int new_session_count = [session_count intValue] + 1;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:new_session_count] forKey:@"session_count"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
    else{
        int new_session_count = [session_count intValue] + 1;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:new_session_count] forKey:@"session_count"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loadModel];
    }
    
    
}

- (void)viewDidUnload
{
    [self setPicker:nil];
    [self setInfoView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (!!data)
        return [data count];
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!!data){
        return [[[data objectAtIndex:section] objectForKey:@"topicals"] count];
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLCartoonTableCell *cell;
    if ([expandedCells containsObject:indexPath]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cartoonMax"];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cartoon"];
    }
    // Configure the cell...

    if (![indexPath row]&&![indexPath section]) {
        [[cell viewWithTag:1983] setHidden:NO];
    }
    else{
        [[cell viewWithTag:1983] setHidden:YES];
    }
    
    NSDictionary* cartoon  = [[[data objectAtIndex:[indexPath section]] objectForKey:@"topicals"] objectAtIndex:[indexPath row]];
    NSString* labelString = [cartoon objectForKey:@"description"];
    if(!labelString)
        labelString = [cartoon objectForKey:@"alt"];
    NSString* alt = [cartoon objectForKey:@"alt"];
    alt = alt?alt:@"";
    NSString* imageString = [NSString stringWithFormat:@"http://amul.com%@", [cartoon objectForKey:@"src"]];
    [[cell image] setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"pattern"]];
    [[cell label] setText:labelString];
    [cell setAlt:alt];
    
    [GANTracker sendEventWithCategory:@"Carousel"
                        withAction:@"ViewTile"
                         withLabel:alt
                         withValue:[NSNumber numberWithInt:[indexPath row]]];
    
    return cell;
}
#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([expandedCells containsObject:indexPath]) {
        return 232.0;
    }
    return 188.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (!!data) {
        return [[data objectAtIndex:section] objectForKey:@"year"];
    } else {
        return @"Loading...";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

    NSDictionary* cartoon  = [[[data objectAtIndex:[indexPath section]] objectForKey:@"topicals"] objectAtIndex:[indexPath row]];
    NSString* alt = [cartoon objectForKey:@"alt"];
    alt = alt?alt:@"";

    if ([expandedCells containsObject:indexPath]) {
        [expandedCells removeObject:indexPath];
        [GANTracker sendEventWithCategory:@"Tile"
                               withAction:@"UnselectTile"
                                withLabel:alt
                                withValue:[NSNumber numberWithInt:[indexPath row]]];

    }
    else{
        [expandedCells addObject:indexPath];
        [GANTracker sendEventWithCategory:@"Tile"
                               withAction:@"SelectTile"
                                withLabel:alt
                                withValue:[NSNumber numberWithInt:[indexPath row]]];
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Picker Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:row];
    [[self tableView] scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    if (!!data) {
        [GANTracker sendEventWithCategory:@"Calendar" withAction:@"Selected_Year" withLabel:[[data objectAtIndex:row] objectForKey:@"year"] withValue:[NSNumber numberWithInt:row]];
    }
    [self dismissActionSheet:pickerView];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (!!data) {
        return [[data objectAtIndex:row] objectForKey:@"year"];
    } else {
        return @"Loading...";
    }
    return nil;
}

#pragma mark - Picker Data Source

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (!!data) {
        return [data count];
    } else {
        return 0;
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (IBAction)showPicker:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    self.picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    self.picker.showsSelectionIndicator = YES;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    int row = [[[[self tableView] indexPathsForVisibleRows] objectAtIndex:0] section];
    [[self picker] selectRow:row inComponent:0 animated:NO];
    
    [actionSheet addSubview:self.picker];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
}

- (void) dismissActionSheet:(id) sender{
    UIActionSheet* actionSheet = (UIActionSheet *)[sender superview];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


@end
