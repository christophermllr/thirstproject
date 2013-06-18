//
//  DonateViewController.h
//  Thirst Project
//
//  Created by Christopher Miller on 4/15/13.
//  Copyright (c) 2013 Thirst Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../PayPalMobile/PayPalMobile.h"

@interface DonateViewController : UIViewController<PayPalPaymentDelegate>

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) PayPalPayment *completedPayment;

@end