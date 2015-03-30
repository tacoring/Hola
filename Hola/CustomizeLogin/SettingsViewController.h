//
//  SettingsViewController.h
//  Anywall
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidLogout:(SettingsViewController *)controller;

@end

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITableView *tableView;


@end
