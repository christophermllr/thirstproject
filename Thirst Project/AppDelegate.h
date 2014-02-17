//
//  AppDelegate.h
//  Thirst Project
//
//  Created by Christopher Miller on 4/15/13.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIColor *TPColor;
    NSData *schoolData;
    NSData *countryData;
}

@property (strong, nonatomic)    UIWindow *window;
@property (retain, nonatomic)    UIColor *TPColor;
@property (retain, nonatomic)    NSData *schoolData;
@property (retain, nonatomic)    NSData *countryData;

@end
