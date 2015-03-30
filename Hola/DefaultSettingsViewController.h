//
//  DefaultSettingsViewController.h
//  LogInAndSignUpDemo
//
//  Created by Mattieu Chang-Che Lu on 2/21/15.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "YelpAPIService.h"
#import "YelpAPISearchQueries.h"
#import "AppDelegate.h"
#import "RestaurantModel.h"

@interface DefaultSettingsViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, YelpAPIServiceDelegate>

@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) AppDelegate *appDelegate;

#pragma mark Yelp API Properties
@property (strong,nonatomic) YelpAPIService *yelpService;
@property (strong,nonatomic) NSString *searchCriteria;
@property (strong,nonatomic) RestaurantModel *place;
@property (strong, nonatomic) NSMutableArray *placesArray;


- (IBAction)logOutButtonTapAction:(id)sender;

@end
