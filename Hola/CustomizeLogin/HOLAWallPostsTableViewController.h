//
//  PAWWallPostsTableViewController.h
//  Anywall
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>
//#import <ParseUI/ParseUI.h>

//#import "HOLAWallViewController.h"

@class HOLAWallPostsTableViewController;

@protocol HOLAWallPostsTableViewControllerDataSource <NSObject>

- (CLLocation *)currentLocationForWallPostsTableViewController:(HOLAWallPostsTableViewController *)controller;

@end

//@interface HOLAWallPostsTableViewController : PFQueryTableViewController <HOLAWallViewControllerHighlight>
@interface HOLAWallPostsTableViewController : PFQueryTableViewController

//@property (nonatomic, weak) id<PAWWallPostsTableViewControllerDataSource> dataSource;

@end
