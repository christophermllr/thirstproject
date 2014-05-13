//
//  AppDelegate.m
//  Thirst Project
//
//  Created by Christopher Miller on 4/15/13.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "PayPalMobile.h"

@implementation AppDelegate

@synthesize TPColor;
@synthesize schoolData;
@synthesize countryData;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    TPColor = [UIColor colorWithRed:3.0f/255.0f green:170.0f/255.0f blue:171.0f/255.0f alpha:1.0f];
    [[UITabBar appearance] setTintColor:TPColor];
    
    [PayPalMobile initializeWithClientIdsForEnvironments: @{
        PayPalEnvironmentProduction : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PayPalProductionClientId"],
        PayPalEnvironmentSandbox : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PayPalSandboxClientId"]}];
    
    [self getSchoolData];
    [self getCountryData];
    return YES;
}

- (void)getSchoolData
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"schools.json"];
    
    if (internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN) {
        
        NSString *urlAsString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TPSchoolsURL"];
        NSURL *url = [[NSURL alloc] initWithString:urlAsString];
        
        schoolData = [NSData dataWithContentsOfURL:url];
        
        [schoolData writeToFile:filePath atomically:YES];
        
    } else {
        
        if ([fileManager fileExistsAtPath:filePath]) {
            schoolData = [NSData dataWithContentsOfFile: filePath];
        } else {
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

- (void)getCountryData
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"countries.json"];
    
    if (internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN) {
        
        NSString *urlAsString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TPCountriesURL"];
        NSURL *url = [[NSURL alloc] initWithString:urlAsString];
        
        countryData = [NSData dataWithContentsOfURL:url];
        
        [countryData writeToFile:filePath atomically:YES];
        
    } else {
        
        if ([fileManager fileExistsAtPath:filePath]) {
            countryData = [NSData dataWithContentsOfFile: filePath];
        } else {
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
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
