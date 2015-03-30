//
//  SubclassConfigViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "SubclassConfigViewController.h"


@implementation SubclassConfigViewController

@synthesize takoTableView;
@synthesize refreshControl;
@synthesize userCategories;
@synthesize userDistances;
//@synthesize searchBar;
@synthesize searchController;

#pragma mark - UIViewController

-(void)viewDidLoad{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
    
    // Set our nav bar items.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(settingsButtonSelected:)];
    
//    searchBar.delegate = self;
    
    //Get Restaurant list to array, then put in table view
    //Table view
//    takoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,
//                                                                 64+searchBar.frame.size.height,
//                                                                 375,667 - 64 - searchBar.frame.size.height) style:UITableViewStyleGrouped];
    takoTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    takoTableView.tableHeaderView = nil;
    
//    takoTableView.tableHeaderView = searchController.searchBar;
    takoTableView.dataSource = self;
    takoTableView.delegate = self;
    [self.view addSubview: takoTableView];
    
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = takoTableView;
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(arrayRefresh)
                  forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = refreshControl;
    [takoTableView addSubview:tableViewController.refreshControl];
    
    [self getDefaultSetting];
    [self startStandardUpdates];
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidAppear:animated];
    
    _userSort = [[NSUserDefaults standardUserDefaults] integerForKey:HOLAUserDefaultSortKey];
    NSLog(@"GetDefault setting sort: %ld", (long)_userSort);
    
    [self.locationManager startUpdatingLocation];
 
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - 
#pragma mark Get NSDefault Setting
- (void) getDefaultSetting {
    NSMutableArray *categoryOptions = [[NSMutableArray alloc] init];
    [categoryOptions addObject:@"All Restaurants"];
    [categoryOptions addObject:@"American"];
    [categoryOptions addObject:@"Barbeque"];
    [categoryOptions addObject:@"Beer Garden"];
    [categoryOptions addObject:@"Cafe"];
    [categoryOptions addObject:@"Chicken Wings"];
    [categoryOptions addObject:@"Chinese"];
    [categoryOptions addObject:@"Fast Food"];
    [categoryOptions addObject:@"French"];
    [categoryOptions addObject:@"Greek"];
    [categoryOptions addObject:@"Italian"];
    [categoryOptions addObject:@"Japanese"];
    [categoryOptions addObject:@"Mexican"];
    [categoryOptions addObject:@"Pizza"];
    [categoryOptions addObject:@"Pub Food"];
    [categoryOptions addObject:@"Salad"];
    [categoryOptions addObject:@"Sandwiches"];
    [categoryOptions addObject:@"Steak House"];
    [categoryOptions addObject:@"Sushi"];
    [categoryOptions addObject:@"Thai"];
    [categoryOptions addObject:@"Vegan"];
    userCategories = [categoryOptions copy];
    
    NSMutableArray *distanceOptions = [[NSMutableArray alloc] init];
    [distanceOptions addObject:@"1"];
    [distanceOptions addObject:@"5"];
    [distanceOptions addObject:@"20"];
    
    userDistances = [distanceOptions copy];
    
    
}

#pragma mark -
#pragma mark WallPostsTableViewController

- (void)loadWallPostsTableViewController {
    // Add the wall posts tableview as a subview with view containment (new in iOS 5.0):
    self.wallPostsTableViewController = [[HOLAWallPostsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.view addSubview:self.wallPostsTableViewController.view];
    [self addChildViewController:self.wallPostsTableViewController];
    [self.wallPostsTableViewController didMoveToParentViewController:self];
}

#pragma mark - ( YELP API)

- (void)pickSomePlace {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    //get NSUserDefault
    _userCategory = [[NSUserDefaults standardUserDefaults] integerForKey:HOLAUserDefaultCategoryKey];
    NSString *categoryFilter = [userCategories objectAtIndex:_userCategory];
    
    _userDistance = [[NSUserDefaults standardUserDefaults] integerForKey:HOLAUserDefaultDistanceKey];
    NSString *distanceFiler = [userDistances objectAtIndex:_userDistance];
    
    
    NSLog(@"pickSomePlace : %@", distanceFiler);

    [self findNearByRestaurantsFromYelpbyCategory:categoryFilter andRadius:distanceFiler];
}

- (void) findNearByRestaurantsFromYelpbyCategory:(NSString *)categoryFilter andRadius:(NSString *)radiusFilter{
    NSLog(@"%s:%@,%@", __PRETTY_FUNCTION__,categoryFilter,radiusFilter);
    
    self.yelpService = [[YelpAPIService alloc]init];
    self.yelpService.delegate = self;
    
    self.searchCriteria = [YelpAPISearchQueries getQueryFromString:categoryFilter];
    [self.yelpService searchNearByRestaurantsByFilter:[self.searchCriteria lowercaseString]
            andRadiusFilter:radiusFilter
            atLatitude:self.currentLocation.coordinate.latitude
            andLongitude:self.currentLocation.coordinate.longitude];
}

#pragma mark Yelp API Delegate

-(void)loadResultWithDataArray:(NSArray *)resultArray {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    //Clean arrary before copy new array
    if (self.placesArray && [self.placesArray count] > 0) {
        NSLog(@"loadResultWithDataArray remove all objects");
        [self.placesArray removeAllObjects];
    }
    
    if (!self.placesArray) {
        NSLog(@"loadResultWithDataArray alloc init");
        self.placesArray = [[NSMutableArray alloc] init];
    }
    
    if (self.userSort == 0){
        self.placesArray = [resultArray mutableCopy];
    }else if (self.userSort == 1){
        NSArray *sortedArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(RestaurantModel *p1, RestaurantModel *p2){
            return [p1.distance compare:p2.distance];
        }];
        self.placesArray = [sortedArray mutableCopy];
    }else if (self.userSort == 2){
        NSArray *sortedArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(RestaurantModel *p1, RestaurantModel *p2){
            return [p2.review_count compare:p1.review_count];
        }];
        self.placesArray = [sortedArray mutableCopy];
    }else{
        self.placesArray = [resultArray mutableCopy];
    }
    
    [takoTableView reloadData];
    [self.refreshControl endRefreshing];
}
        
// Method to get random object from array
//- (RestaurantModel*) getRandomFromArray:(NSArray*)array {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    if (!array.count == 0) {
//        uint32_t rnd = arc4random_uniform([array count]);
//        RestaurantModel *randomRestaurant = [array objectAtIndex:rnd];
//        return randomRestaurant;
//    }else {
//        NSLog(@"No results");
//        //        [self.mainButton setTitle:@"No results :(" forState:UIControlStateNormal];
//        return nil;
//    }
//    return nil;
//}

- (void) setPlace {
    
    [takoTableView reloadData];
    
}

#pragma mark -
#pragma mark UINavigationBar-based actions

- (IBAction)settingsButtonSelected:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.delegate wallViewControllerWantsToPresentSettings:self];
}

- (IBAction)postButtonSelected:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
//    [self startStandardUpdates];
    [self pickSomePlace];
}

- (void)arrayRefresh{
//    [self startStandardUpdates];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self pickSomePlace];
    
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods and helpers

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // Set a movement threshold for new events.
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}

- (void)startStandardUpdates {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.locationManager startUpdatingLocation];
    
    CLLocation *currentLocation = self.locationManager.location;
    if (currentLocation) {
        self.currentLocation = currentLocation;
        
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    
    // Make sure this is a recent location event
    CLLocation *newLocation = [locations lastObject];
    NSTimeInterval eventInterval = [newLocation.timestamp timeIntervalSinceNow];
    
    if (newLocation != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentLocation = newLocation;
        });
    }
    
    if(abs(eventInterval) < 30.0)
    {
        // Make sure the event is valid
        if (newLocation.horizontalAccuracy == 0)
        {
            return;
        }
        
        
        // Instantiate _geoCoder if it has not been already
        if (self.geocoder == nil)
        {
            self.geocoder = [[CLGeocoder alloc] init];
        }
        
        
        //Only one geocoding instance per action
        //so stop any previous geocoding actions before starting this one
        if([self.geocoder isGeocoding])
        {
            [self.geocoder cancelGeocode];
        }
        
        
        [self.geocoder reverseGeocodeLocation: newLocation
                            completionHandler: ^(NSArray* placemarks, NSError* error)
         {
             if([placemarks count] > 0)
             {
                 CLPlacemark *foundPlacemark = [placemarks objectAtIndex:0];
//                 NSLog(@"%@", [[foundPlacemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "]);
//                 NSLog(@"%@",[NSString stringWithFormat:@"You are in: %@", foundPlacemark.description]);
                 self.currentAddress = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                          foundPlacemark.subThoroughfare, foundPlacemark.thoroughfare,
                                          foundPlacemark.postalCode, foundPlacemark.locality,
                                          foundPlacemark.administrativeArea,
                                          foundPlacemark.country];
                 [takoTableView reloadData];
             }
             else if (error.code == kCLErrorGeocodeCanceled)
             {
                 NSLog(@"Geocoding cancelled");
             }
             else if (error.code == kCLErrorGeocodeFoundNoResult)
             {
                 NSLog(@"No geocode result found");
             }
             else if (error.code == kCLErrorGeocodeFoundPartialResult)
             {
                 NSLog(@"Partial geocode result");
             }
             else
             {
                 NSLog(@"%@", [NSString stringWithFormat:@"Unknown error: %@", error.description]);
             }
         }
         ];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"kCLAuthorizationStatusAuthorized");
            // Re-enable the post button if it was disabled before.
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self.locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Chopsticks can’t access your current location.\n\nTo view nearby posts or create a post at your current location, turn on access for Chopsticks to your location in the Settings app under Location Services." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            // Disable the post button.
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"kCLAuthorizationStatusNotDetermined");
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"kCLAuthorizationStatusRestricted");
        }
            break;
        default:break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"Error: %@", [error description]);
    
    if (error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
    } else if (error.code == kCLErrorLocationUnknown) {
        // todo: retry?
        // set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}


#pragma mark -
#pragma mark Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return [self.placesArray count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0 ){
        NSLog(@"%s", __PRETTY_FUNCTION__);
        static NSString *cellIdentifier = @"PositionTableCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
//        cell.textLabel.text = self.currentLocation.coordinate.latitude;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%g, %g)",self.currentLocation.coordinate.longitude, self.currentLocation.coordinate.latitude];
        cell.textLabel.text = self.currentAddress;
        return cell;
    }
    else if (indexPath.section == 1 ){
        static NSString *cellIdentifier = @"RestaurantTableCell";
        TableCell *cell = (TableCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        RestaurantModel *Rest = [self.placesArray objectAtIndex: indexPath.row];

        cell.nameLabel.text = Rest.name;
        [self downloadImageWithURL:[NSURL URLWithString:Rest.thumbURL] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                cell.thumbnailImageView.image = image;
            }
        }];
        [self downloadImageWithURL:[NSURL URLWithString:Rest.ratingURL] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                cell.ratingImage.image = image;
            }
        }];
        cell.ratingCountLabel.text = [NSString stringWithFormat:@"%@ Reviews",Rest.review_count];
        cell.addressLabel.text = Rest.address;
        cell.distanceLabel.text = [NSString stringWithFormat:@"%0.2f mi", [Rest.distance doubleValue]/1000];
        return cell;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(void)cropimage{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ){
        return 70;
    }
    else if (indexPath.section == 1 ){
        
        return 90;
    }
    return 0;
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ){
        
    }
    else if (indexPath.section == 1 ){
        
        NSLog(@"%s", __PRETTY_FUNCTION__);
        RestaurantModel *Rest = [self.placesArray objectAtIndex: indexPath.row];
        [self.delegate wallViewControllerWantsToPresentDetail:self andRest:Rest];
    }
    
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.searchBar resignFirstResponder];
//}
//
//#pragma mark - Search bar delegate
//
//- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
//    NSLog(@"%s : %ld", __PRETTY_FUNCTION__,(long)selectedScope);
//    //sort by rank :0
//    //sort by distance :0
//    
//}
//
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
////    [self.searchBar resignFirstResponder];
//}
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
@end


