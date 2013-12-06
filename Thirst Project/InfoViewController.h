//
//  InfoViewController.h
//  Thirst Project
//
//  Created by Christopher Miller on 12/5/13.
//  Copyright (c) 2013 Thirst Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfoViewController;

@protocol InfoViewControllerDelegate <NSObject>
- (void)infoViewControllerDidClose:(InfoViewController *)controller;
@end

@interface InfoViewController : UIViewController

@property (nonatomic, weak) id <InfoViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end