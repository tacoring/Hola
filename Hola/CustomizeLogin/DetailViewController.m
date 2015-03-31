//
//  DetailViewController.m
//  Hola
//
//  Created by Chang-Che Lu on 3/15/15.
//  Copyright (c) 2015 Chang-Che Lu. All rights reserved.
//

#import "DetailViewController.h"
#import "TableCell.h"
#import "PostModel.h"
#import "CoolButton.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *thumbURL;
@property (strong, nonatomic) IBOutlet UILabel *RestName;
@end

@implementation DetailViewController

@synthesize rest;
@synthesize DetailTableView;
@synthesize postsArray;
@synthesize mapView;

- (void)viewDidLoad {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(done)];
    UIImage* customImg = [UIImage imageNamed:@"yelp.png"];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Yelp"
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:self
//                                                                            action:@selector(DirectToYelp)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:customImg
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(DirectToYelp)];
    
    self.RestName.text = rest.name;
    [self downloadImageWithURL:[NSURL URLWithString:rest.thumbURL] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            self.thumbURL.image = image;
        }
    }];
    
    
    [self downloadImageWithURL:[NSURL URLWithString:rest.ratingURL] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            self.ratingImage.image = image;
        }
    }];
    self.reviewCountLabel.text = [NSString stringWithFormat:@"%@ Reviews",self.rest.review_count];
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2f mi", [self.rest.distance doubleValue]/1000];
//    self.RestAddress.text = rest.address;
//    self.mapButton.titleLabel.text = rest.address;
    [self.mapButton setTitle:rest.address forState:UIControlStateNormal];
    
    [self.mapView setCenterCoordinate: rest.coord animated: YES];
    self.mapView.showsUserLocation = YES;
//    self.mapView.region = MKCoordinateRegionMake(rest.coord, MKCoordinateSpanMake(0.05, 0.05));
//    self.mapView.region = MKCoordinateRegionMakeWithDistance(rest.coord, MilesToMeters(1.0f), MilesToMeters(1.0f) );
    self.mapView.region = MKCoordinateRegionMakeWithDistance(rest.coord, 1600.0f, 1600.0f );

    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    

    
    
    [annotation setCoordinate: rest.coord];
    [annotation setTitle: rest.name];
    [self.mapView addAnnotation:annotation];
    
    //Table view
//    takoTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    DetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 350, 375, 300) style:UITableViewStylePlain];
    DetailTableView.dataSource = self;
    DetailTableView.delegate = self;
    [self.view addSubview: DetailTableView];
    
    if (self.postsArray && [self.postsArray count] > 0) {
        [self.postsArray removeAllObjects];
    }
    
    if (!self.postsArray) {
        self.postsArray = [[NSMutableArray alloc] init];
    }
    
//    [self getParseValue];
    
    [self startStandardUpdates];
}

float MilesToMeters(float miles) {
    // 1 mile is 1609.344 meters
    // source: http://www.google.com/search?q=1+mile+in+meters
    return 1609.344f * miles;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self getParseValue];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UINavigationBar-based actions

-(void) DirectToYelp {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void) done {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) post {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.delegate DetailViewControlerWantsToPost:self andRest:rest];
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

#pragma mark -
#pragma mark Load Parse data
-(void) getParseValue {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query whereKey:@"restid" equalTo:rest.restaurant_id];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            
            if (postsArray && [postsArray count] > 0) {
                [postsArray removeAllObjects];
            }
            
            if (!postsArray) {
                postsArray = [[NSMutableArray alloc] init];
            }
            
            for (PFObject *object in objects) {
                PostModel *aPost = [[PostModel alloc] init];
                aPost.name = [object objectForKey:@"username"];
                
                aPost.text = [object objectForKey:@"text"];
                [postsArray addObject:aPost];
            }
            
            [self.DetailTableView reloadData];
            NSLog(@"getParseValue : %lu", (unsigned long)[postsArray count]);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
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

- (void)mapView:(MKMapView *)theMapView didUpdateToUserLocation:(MKUserLocation *)location
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
//    [self zoomToUserLocation:location];
}

#pragma mark -
#pragma mark Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)[postsArray count]);
//    NSLog(@"Number of items in my array is: %d", [array count]);
    return [postsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    static NSString *cellIdentifier = @"PostTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    PostModel *aPost = [postsArray objectAtIndex: indexPath.row];
    NSLog(@" %@", aPost.text);
    cell.textLabel.text = aPost.text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@",aPost.name];
    return cell;
    
}

#pragma mark - 
#pragma mark Map View
- (void)zoomToLocation
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)openMap:(id)sender {
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate = rest.coord;
//        CLLocationCoordinate2DMake(16.775, -3.009);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:rest.name];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}

- (IBAction)writeComment:(id)sender {
    [self post];
}

- (IBAction)hueValueChanged:(id)sender
{
    UISlider * slider = (UISlider *) sender;
    self.coolButton.hue = slider.value;
}

- (IBAction)saturationValueChanged:(id)sender
{
    UISlider * slider = (UISlider *)sender;
    self.coolButton.saturation = slider.value;
}

- (IBAction)brightnessValueChanged:(id)sender
{
    UISlider * slider = (UISlider *)sender;
    self.coolButton.brightness = slider.value;
}

@end
