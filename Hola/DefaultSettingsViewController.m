//
//  DefaultSettingsViewController.m
//  LogInAndSignUpDemo
//
//  Created by Chang-Che Lu on 2/21/15.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "DefaultSettingsViewController.h"

@implementation DefaultSettingsViewController


#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
        self.welcomeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), [[PFUser currentUser] username]];
        
        
        // Set app delegate and update users current location
        self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [self.appDelegate updateCurrentLocation];
        
        [self pickSomePlace]; //Call yelp API

        
    } else {
        self.welcomeLabel.text = NSLocalizedString(@"Not logged in", nil);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController]; 
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    NSLog(@"Sign out");
    [PFUser logOut];
//    [self.navigationController popViewControllerAnimated:YES];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}


#pragma mark - ( YELP API)

- (void)pickSomePlace {
    [self findNearByRestaurantsFromYelpbyCategory:nil andRadius:@"20"];
}

- (void) findNearByRestaurantsFromYelpbyCategory:(NSString *)categoryFilter andRadius:(NSString *)radiusFilter{
    // Category filter being null is taken care of in YelpAPIService - in that case just top results are returned
//    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied && self.appDelegate.currentUserLocation && self.appDelegate.currentUserLocation.coordinate.latitude) {
//        
//        self.yelpService = [[YelpAPIService alloc]init];
//        self.yelpService.delegate = self;
//        
//        self.searchCriteria = [YelpAPISearchQueries getQueryFromString:categoryFilter];
//        [self.yelpService searchNearByRestaurantsByFilter:[self.searchCriteria lowercaseString] andRadiusFilter:radiusFilter atLatitude:self.appDelegate.currentUserLocation.coordinate.latitude andLongitude:self.appDelegate.currentUserLocation.coordinate.longitude];
//    } else {
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Location is Disabled" message:@"Enable it in settings and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [av show];
//    }
}

#pragma mark Yelp API Delegate
-(void)loadResultWithDataArray:(NSArray *)resultArray {
    NSLog(@"ViewController loadResultWithDataArray");
    self.placesArray = [resultArray mutableCopy];
//    [self.mainButton setTitle:nil forState:UIControlStateNormal];
//    [self.fetchingActivityIndicator stopAnimating];
//    [self.fetchingActivityIndicator setHidden:YES];
//    [self.numberOfResultsLabel setText:[NSString stringWithFormat:@"%@ results",[[NSNumber numberWithLong:self.placesArray.count] stringValue]]];
    [self setPlace];
}


// Method to get random object from array
- (RestaurantModel*) getRandomFromArray:(NSArray*)array {
    NSLog(@"getRandomFromArray");
    if (!array.count == 0) {
        uint32_t rnd = arc4random_uniform([array count]);
        RestaurantModel *randomRestaurant = [array objectAtIndex:rnd];
        return randomRestaurant;
    }else {
        NSLog(@"No results");
//        [self.mainButton setTitle:@"No results :(" forState:UIControlStateNormal];
        return nil;
    }
    return nil;
}

- (void) setPlace {
    self.place = [self getRandomFromArray:self.placesArray];
    
    for(int i = 0; i < [self.placesArray count]; i++) {
        NSLog(@" ======================================= %i", i);
        RestaurantModel *aPlace = [self.placesArray objectAtIndex:i];
        NSLog(@"name: %@", aPlace.name);
        NSLog(@"address: %@", aPlace.address);
        NSLog(@"thumbURL: %@", aPlace.thumbURL);
        NSLog(@"display_address: %@", aPlace.display_address);
        NSLog(@"latitude: %@", aPlace.latitude);
        NSLog(@"longitude: %@", aPlace.longitude);
    }
    
//    [self.nameLabel setText:self.place.name];
//    [self.addressLabel setText:self.place.address];
    
    // Get the thumbnail and rating images on background queue
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSData *thumbImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.place.thumbURL]];
//        NSData *ratingImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.place.ratingURL]];
//        dispatch_async(dispatch_get_main_queue(), ^ {
////            [self.thumbImage setImage:[UIImage imageWithData:thumbImageData]];
////            [self.ratingImage setImage:[UIImage imageWithData:ratingImageData]];
//            // Resize the thumbnail, blur it, and set it to background
//            if ([UIImage imageWithData:thumbImageData]) {
//                UIImage *blurThumb = [self imageWithImage:[UIImage imageWithData:thumbImageData] scaledToSize:CGSizeMake(640, 1136)];
//                blurThumb = [blurThumb applyLightEffect];
//                [self.backgroundImage setImage:blurThumb];
//            }
//        });
//    });
    //[self.placesArray removeObject:place];   // TO- DO --> THIS IS NOT A STRING, IT'S A RESTAURANTMODEL
}

@end
