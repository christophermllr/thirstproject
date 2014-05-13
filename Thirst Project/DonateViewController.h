//
//  DonateViewController.h
//  Thirst Project
//
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "FlipsideViewController.h"
#import "InfoViewController.h"
#import "PayPalMobile.h"

@interface DonateViewController : UIViewController <PayPalPaymentDelegate, FlipsideViewControllerDelegate,InfoViewControllerDelegate, UIPopoverControllerDelegate>

@property(nonatomic, strong, readwrite) UIPopoverController *flipsidePopoverController;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) PayPalPayment *completedPayment;


@end
