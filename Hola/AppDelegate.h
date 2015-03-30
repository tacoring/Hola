//
//  AppDelegate.h
//  Hola
//
//  Created by Chang-Che Lu on 2/19/15.
//  Copyright (c) 2015 Chang-Che Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyLogInViewController.h"
#import "SubclassConfigViewController.h"
#import "SettingsViewController.h"
#import "DetailViewController.h"
#import "PostViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;
//@property (nonatomic, strong) UITabBarController *tabBarController;


@end

