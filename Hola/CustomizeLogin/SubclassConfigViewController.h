//
//  SubclassConfigViewController.h
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "YelpAPIService.h"
#import "YelpAPISearchQueries.h"
#import "AppDelegate.h"
#import "RestaurantModel.h"
#import "TableCell.h"
#import "HOLAWallPostsTableViewController.h"
#import "MyLogInViewController.h"
#import "MySignUpViewController.h"
#import "DetailViewController.h"
#import "PostViewController.h"


@class SubclassConfigViewController;

@protocol SubclassConfigViewControllerDelegate <NSObject>

- (void)wallViewControllerWantsToPresentSettings:(SubclassConfigViewController *)controller;
- (void)wallViewControllerWantsToPresentDetail:(SubclassConfigViewController *)controller andRest:(RestaurantModel*)aRest;

@end


@interface SubclassConfigViewController : UIViewController <CLLocationManagerDelegate,YelpAPIServiceDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>
//
//@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) id<SubclassConfigViewControllerDelegate> delegate;

#pragma mark Yelp API Properties
@property (strong,nonatomic) YelpAPIService *yelpService;
@property (strong,nonatomic) NSString *searchCriteria;
//@property (strong,nonatomic) RestaurantModel *place;
@property (strong, nonatomic) NSMutableArray *placesArray;
@property(strong, nonatomic) NSMutableArray *filteredPlacesArray;
@property UITableView *takoTableView;


@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) NSString *currentAddress;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableArray *userCategories;
@property (nonatomic, strong) NSMutableArray *userDistances;

@property (nonatomic, strong) HOLAWallPostsTableViewController *wallPostsTableViewController;

@property (nonatomic, assign) NSInteger userCategory;
@property (nonatomic, assign) NSInteger userDistance;
@property (nonatomic, assign) NSInteger userSort;
//@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchController;

@end
