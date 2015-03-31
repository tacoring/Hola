//
//  DetailViewController.h
//  Hola
//
//  Created by Chang-Che Lu on 3/15/15.
//  Copyright (c) 2015 Chang-Che Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantModel.h"
#import <MapKit/MapKit.h>

@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>

//-(void) DetailViewControlerDidFinish:(DetailViewController *)controller;
- (void) DetailViewControlerWantsToPost:(DetailViewController *)controller andRest:(RestaurantModel*)aRest;

@end

@class CoolButton;

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImage;
@property (strong, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;


@property (nonatomic, weak) id<DetailViewControllerDelegate> delegate;
@property (nonatomic, strong) RestaurantModel *rest;

@property UITableView *DetailTableView;
@property (strong, nonatomic) NSMutableArray *postsArray;
- (IBAction)openMap:(id)sender;
- (IBAction)writeComment:(id)sender;

@property (nonatomic, strong) IBOutlet CoolButton * coolButton;
- (IBAction)hueValueChanged:(id)sender;
- (IBAction)saturationValueChanged:(id)sender;
- (IBAction)brightnessValueChanged:(id)sender;
@end

