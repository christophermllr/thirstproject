//
//  WellsViewController.m
//  Thirst Project
//
//  Created by Krystin Stutesman on 3/7/14.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "WellsViewController.h"
#import "CountryViewController.h"
#import "Country.h"
#import "DeviceUtils.h"
#import "ThirstProjectConfig.h"
#import "Reachability.h"

@interface WellsViewController ()

-(void)getCountryImage;

@end

@implementation WellsViewController

@synthesize country;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = country.countryName;
    self.wellsBuilt.text = [NSString stringWithFormat:@"%@ wells built",country.wellCount];
    self.moneyDonated.text = [NSString stringWithFormat:@"$%@ donated", country.dollarsDonated];
    self.peopleServed.text = [NSString stringWithFormat:@"%@ lives affected", country.peopleServed];
    
    [self getCountryImage];
    [self setImage];
    
	// Set Navbar color for iOS6/7.
    if ([DeviceUtils isiOS7OrGreater]) {
        self.navigationController.navigationBar.barTintColor = [ThirstProjectConfig defaultColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    } else {
        self.navigationController.navigationBar.tintColor = [ThirstProjectConfig defaultColor];
    }
}

-(void)getCountryImage
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imageFolderUrl = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TPImagesURL"];
    
    NSString *filePath = [cachePath stringByAppendingPathComponent:self.country.imageFilename];
        
        if (![fileManager fileExistsAtPath:filePath] &&
            (internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN)) {
            NSString *urlAsString = [NSString stringWithFormat:@"%@%@", imageFolderUrl, self.country.imageFilename];
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

-(void)setImage {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [cachePath stringByAppendingPathComponent:country.imageFilename];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        _countryImage.image = [[UIImage alloc] initWithContentsOfFile:filePath];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
