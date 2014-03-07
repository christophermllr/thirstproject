//
//  WellsViewController.h
//  Thirst Project
//
//  Created by Krystin Stutesman on 3/7/14.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WellsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
@property (weak, nonatomic) IBOutlet UIImageView *countryImage;

@property (weak, nonatomic) IBOutlet UILabel *wellsBuilt;
@property (weak, nonatomic) IBOutlet UILabel *moneyDonated;
@property (weak, nonatomic) IBOutlet UILabel *peopleServed;

@property (nonatomic) NSString *country;

@end
