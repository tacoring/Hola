//
//  AppDelegate.m
//  Hola
//
//  Created by Chang-Che Lu on 2/19/15.
//  Copyright (c) 2015 Chang-Che Lu. All rights reserved.
//

#import "AppDelegate.h"



@interface AppDelegate ()
<
        MyLogInViewControllerDelegate,
        SubclassConfigViewControllerDelegate,
        SettingsViewControllerDelegate,
        DetailViewControllerDelegate,
        PostViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // ****************************************************************************
    // Fill in with your Parse and Twitter credentials. Don't forget to add your
    // Facebook id in Info.plist:
    // ****************************************************************************
    
    //For Push Notification
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    [Parse setApplicationId:@"cw7fvQumv0rLB2VnqJHov54iX9S1KWQlASun42Iy" clientKey:@"BkXhl9ZUWtAKR4rocQ2UdfZRBOc6WuefdpaTpXKr"];
//    [PFFacebookUtils initializeFacebook];
//    [PFTwitterUtils initializeWithConsumerKey:@"your_twitter_consumer_key" consumerSecret:@"your_twitter_consumer_secret"];
    
    // Set the global tint on the navigation bar
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:43.0f/255.0f green:181.0f/255.0f blue:46.0f/255.0f alpha:1.0f]];
    
    // Setup default NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:HOLAUserDefaultCategoryKey] == nil) {
        [userDefaults setInteger:HOLAUserDefaultcategory() forKey:HOLAUserDefaultCategoryKey];
    }
    if ([userDefaults objectForKey:HOLAUserDefaultDistanceKey] == nil) {
        [userDefaults setInteger:HOLAUserDefaultDistance() forKey:HOLAUserDefaultDistanceKey];
    }
    if ([userDefaults objectForKey:HOLAUserDefaultSortKey] == nil) {
        [userDefaults setInteger:HOLAUserDefaultSort() forKey:HOLAUserDefaultSortKey];
    }
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    

    if ([PFUser currentUser]) {
        // Present wall straight-away
        [self presentWallViewControllerAnimated:NO];
    } else {
        // Go to the welcome screen and have them log in or create an account.
        [self presentLoginViewController];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

#pragma mark -
#pragma mark LoginViewController

- (void)presentLoginViewController {
    NSLog(@"presentLoginViewController");
    // Go to the welcome screen and have them log in or create an account.
    MyLogInViewController *viewController = [[MyLogInViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    [self.navigationController setViewControllers:@[ viewController ] animated:NO];
}

#pragma mark Delegate

- (void)loginViewControllerDidLogin:(MyLogInViewController *)controller {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self presentWallViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark WallViewController

- (void)presentWallViewControllerAnimated:(BOOL)animated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    SubclassConfigViewController *wallViewController = [[SubclassConfigViewController alloc] initWithNibName:nil bundle:nil];
    wallViewController.delegate = self;
    [self.navigationController setViewControllers:@[ wallViewController ] animated:animated];
}

#pragma mark Delegate

- (void)wallViewControllerWantsToPresentSettings:(SubclassConfigViewController *)controller {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self presentSettingsViewController];
}






#pragma mark -
#pragma mark SettingsViewController

- (void)presentSettingsViewController {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    settingsViewController.delegate = self;
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentViewController:settingsViewController animated:YES completion:nil];
}

#pragma mark Delegate



- (void)settingsViewControllerDidLogout:(SettingsViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self presentLoginViewController];
}


#pragma mark -
#pragma mark DetailViewController

- (void)presentDetailViewController:(RestaurantModel*)aRest {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.delegate = self;
//    detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    detailViewController.rest = aRest;
    [self.navigationController pushViewController: detailViewController animated:YES];
}

#pragma mark Delegate
- (void)wallViewControllerWantsToPresentDetail:(DetailViewController *)controller andRest:(RestaurantModel*)aRest{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self presentDetailViewController:aRest];
}

-(void) DetailViewControlerWantsToPost: (DetailViewController*) controller andRest:(RestaurantModel*)aRest{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self presentPostViewController:aRest];
}


#pragma mark -
#pragma mark PostViewController

- (void)presentPostViewController:(RestaurantModel*)aRest {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    PostViewController *postViewController = [[PostViewController alloc] initWithNibName:nil bundle:nil];
    postViewController.delegate = self;
    //    detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    postViewController.rest = aRest;
    [self.navigationController pushViewController: postViewController animated:YES];
}









- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults] synchronize];
}

# pragma mark - Updates user's current location
//
//-(void)updateCurrentLocation {
//    [self.customLocationManager startUpdatingLocation];
//}
//
//-(void)stopUpdatingCurrentLocation {
//    [self.customLocationManager stopUpdatingHeading];
//}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    self.currentUserLocation = newLocation;
//    
//    [self.customLocationManager stopUpdatingLocation];
//    self.currentUserLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
//                                                          longitude:newLocation.coordinate.longitude];
//}

@end
