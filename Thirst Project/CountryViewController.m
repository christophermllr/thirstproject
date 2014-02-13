//
//  WellViewController.m
//  Thirst Project
//
//  Created by Christopher Miller on 11/3/13.
//  Edited by Kevin Kinnebrew 2/12/14
//  Copyright (c) 2013 Thirst Project. All rights reserved.
//

#import "CountryViewController.h"
#import "InfoViewController.h"
#import "DeviceUtils.h"
#import "AppDelegate.h"
#import "ThirstProjectConfig.h"
#import "CountryBuilder.h"
#import "Reachability.h"
#import "Country.h"

@interface CountryViewController ()

@property (nonatomic, strong, readwrite) NSArray *countries;

@end

@implementation CountryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self parseCountries];
    [self getCountryImages];
    
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

-(void)getCountryImages
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imageFolderUrl = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TPImagesURL"];
    
    for (Country *country in self.countries)
    {
        NSString *filePath = [cachePath stringByAppendingPathComponent:country.imageFilename];
        
        if (![fileManager fileExistsAtPath:filePath] &&
            (internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN)) {
                NSString *urlAsString = [NSString stringWithFormat:@"%@%@", imageFolderUrl, country.imageFilename];
                NSURL *url = [[NSURL alloc] initWithString:urlAsString];
                NSData *image = [NSData dataWithContentsOfURL:url];
                [image writeToFile:filePath atomically:YES];
        }
        
        if (![fileManager fileExistsAtPath:filePath]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An Internet Connection is Required"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return; //TODO disable access to the payment view controller.
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.countries count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    Country *country = [self.countries objectAtIndex:indexPath.section + indexPath.row];
    NSString *filePath = [cachePath stringByAppendingPathComponent:country.imageFilename];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        UIImageView *countryImageView = (UIImageView *)[cell viewWithTag:100];
        countryImageView.image = [NSData dataWithContentsOfFile: filePath];
    }
    
    return cell;
}

#pragma mark - InfoViewControllerDelegate

- (void)infoViewControllerDidClose:(InfoViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewInfo"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        InfoViewController *infoViewController = [navigationController viewControllers][0];
        infoViewController.delegate = self;
    }
}

@end
