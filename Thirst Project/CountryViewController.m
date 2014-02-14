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
#import "CellImageButton.h"

@interface CountryViewController ()

@property (nonatomic, strong) NSArray *countries;

@end

@implementation CountryViewController

- (void)viewDidLoad
{
    // Add a UICollectionView
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_collectionView];
    
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

#pragma mark - Collection Rendering

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.countries.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 150);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // 120 for bottom padding
    return UIEdgeInsetsMake(5, 5, 120, 5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];

    Country *country = [self.countries objectAtIndex:indexPath.row];
    NSString *filePath = [cachePath stringByAppendingPathComponent:country.imageFilename];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        
        CellImageButton *button = [[CellImageButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        [button addTarget:self action:@selector(onCellTouch:) forControlEvents:UIControlEventTouchUpInside];
        [button setCountryData:country];
        
        UIImageView *subview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        subview.image = [[UIImage alloc] initWithContentsOfFile:filePath];
        
        [button addSubview:subview];
        [cell addSubview:button];
        [cell bringSubviewToFront:button];
    }
    
    return cell;
}

-(void)onCellTouch:(CellImageButton *)sender
{
    NSString *message = [NSString stringWithFormat:@"%@ wells built\n$%@ donated\n%@ lives affected", sender.countryData.wellCount, sender.countryData.dollarsDonated, sender.countryData.peopleServed];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sender.countryData.countryName
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
