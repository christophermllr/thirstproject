//
//  SchoolsTableViewController.m
//  Thirst Project
//
//  Created by Christopher Miller on 5/12/14.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "SchoolsTableViewController.h"
#import "AppDelegate.h"

@interface SchoolsTableViewController ()

@property (nonatomic, strong, readwrite) NSArray *schools;

@end

@implementation SchoolsTableViewController

@synthesize filteredSchoolArray;
@synthesize searchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Parse the school data.
    NSError *e = nil;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.schoolData == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An Internet Connection is Required"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return; //TODO send user back to initial view controller?
    }
    
    self.schools = [NSJSONSerialization JSONObjectWithData:appDelegate.schoolData
                                                   options:kNilOptions
                                                     error:&e];
    if (e) {
        NSLog(@"Error : %@", e);
    }
    else {
        self.filteredSchoolArray = [NSMutableArray arrayWithCapacity:[self.schools count]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    NSString *school;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        school = [self.filteredSchoolArray objectAtIndex:indexPath.row];
    } else {
        school = [self.schools objectAtIndex:indexPath.row];
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:school forKey:@"schoolName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SchoolSelected" object:nil userInfo:userInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredSchoolArray count];
    } else {
        return [self.schools count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"schoolCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Check to see whether the normal table or search results table is being displayed and set the school object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [self.filteredSchoolArray objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [self.schools objectAtIndex:indexPath.row];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredSchoolArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    self.filteredSchoolArray = [NSMutableArray arrayWithArray:[self.schools filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
