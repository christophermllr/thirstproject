//
//  WellViewController.m
//  Thirst Project
//
//  Created by Christopher Miller on 11/3/13.
//  Edited by Kevin Kinnebrew 2/12/14
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "CountryViewController.h"
#import "InfoViewController.h"
#import "DeviceUtils.h"
#import "AppDelegate.h"
#import "ThirstProjectConfig.h"
#import "Reachability.h"
#import "Country.h"
#import "CountryBuilder.h"
#import "WellsViewController.h"

@interface CountryViewController ()

@property (nonatomic, strong) NSArray *countries;

@end

@implementation CountryViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self parseCountries];
    
    // Set Navbar color for iOS6/7.
    if ([DeviceUtils isiOS7OrGreater]) {
        self.navigationController.navigationBar.barTintColor = [ThirstProjectConfig defaultColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    } else {
        self.navigationController.navigationBar.tintColor = [ThirstProjectConfig defaultColor];
    }
}

-(void)parseCountries
{
    NSError *error = nil;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.countryData == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An Internet Connection is Required"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return; //TODO send user back to initial view controller?
    }
    
    self.countries = [CountryBuilder countriesFromJSON:appDelegate.countryData error:&error];
    if (error != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"An error occurred while parsing the list of countries."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return; //TODO send user back to initial view controller?
    }
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_countries count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO incomplete
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryCell"];
    
        
    Country *country = [self.countries objectAtIndex:indexPath.row];
    // Name of country to cell
    cell.textLabel.text = country.countryName;
    
    return cell;
}

#pragma mark - InfoViewControllerDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showDetails"] &&
       [segue.destinationViewController respondsToSelector:@selector(setCountry:)]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Country *country = [self.countries objectAtIndex:path.row];
        [segue.destinationViewController performSelector:@selector(setCountry:)withObject:country];
    }
}

@end
