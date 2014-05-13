//
//  SchoolsTableViewController.h
//  Thirst Project
//
//  Created by Christopher Miller on 5/12/14.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolsTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
@property (strong,nonatomic) NSMutableArray *filteredSchoolArray;
@property IBOutlet UISearchBar *searchBar;

@end