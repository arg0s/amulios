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

#define AMUL_S3_JSON @"http://d1832ahxutkhx9.cloudfront.net/amul.json" 

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadModel{
    
    [[LRResty client] get:AMUL_S3_JSON withBlock:^(LRRestyResponse *response) {
        if ([response status] == 200){
            NSError* error;
            id responseObj = [NSJSONSerialization JSONObjectWithData:[[response asString] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
            NSLog(@"Sections: %i", [responseObj count]);
            self.data = responseObj;
            [[self tableView] reloadData];
            [[self picker] reloadAllComponents];
            [[self tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else{
            NSLog(@"Unable to load data feed");
            BlockAlertView* alert = [[BlockAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to load cartoon ads. Please try again later!"];
            [alert addButtonWithTitle:@"OK" block:^(void){
                exit(1);
            }];
            [alert show];
        }
    }];
    
}

- (void)viewDidLoad
{
    [self loadModel];
    [super viewDidLoad];
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
    static NSString *CellIdentifier = @"cartoon";
    LLCartoonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    NSDictionary* cartoon  = [[[data objectAtIndex:[indexPath section]] objectForKey:@"topicals"] objectAtIndex:[indexPath row]];
    NSString* labelString = [cartoon objectForKey:@"alt"];
    NSString* imageString = [NSString stringWithFormat:@"http://amul.com%@", [cartoon objectForKey:@"src"]];
    [[cell image] setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"pattern"]];
    [[cell label] setText:labelString];
    return cell;
}
#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.0;
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - Picker Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:row];
    [[self tableView] scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    [[self tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}


@end
