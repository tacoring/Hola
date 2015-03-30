//
//  PAWSettingsViewController.m
//  Anywall
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>

typedef NS_ENUM(uint8_t, HOLASettingsTableViewSection)
{
    HOLASettingsTableViewSectionSort = 0,
    HOLASettingsTableViewSectionDistance,
    HOLASettingsTableViewSectionCategory,
    HOLASettingsTableViewSectionLogout,
    HOLASettingsTableViewNumberOfSections
};

static uint16_t const PAWSettingsTableViewLogoutNumberOfRows = 1;

@interface SettingsViewController ()

@property (nonatomic, strong) NSArray *distanceOptions;
@property (nonatomic, strong) NSArray *categoryOptions;
@property (nonatomic, assign) NSInteger userCategory;
@property (nonatomic, assign) NSInteger userDistance;

@property (nonatomic, strong) NSArray *sortOptions;
@property (nonatomic, assign) NSInteger userSort;


@end

@implementation SettingsViewController


#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _userCategory = [[NSUserDefaults standardUserDefaults] integerForKey:HOLAUserDefaultCategoryKey];
        _userDistance = [[NSUserDefaults standardUserDefaults] integerForKey:HOLAUserDefaultDistanceKey];
        _userSort = [[NSUserDefaults standardUserDefaults] integerForKey:HOLAUserDefaultSortKey];
        [self loadAvailableDistanceOptions];
        [self loadAvailableCategoryOptions];
        [self loadAvailableSortOptions];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark UIViewController

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark -
#pragma mark Accessors

-(void)setUserSort:(NSInteger)userSort{
    NSLog(@"%s : %ld", __PRETTY_FUNCTION__,(long)userSort);
    if (self.userSort != userSort) {
        _userSort = userSort;
        [[NSUserDefaults standardUserDefaults] setInteger:userSort forKey:HOLAUserDefaultSortKey];
    }
}

-(void)setUserCategory:(NSInteger)userCategory{
    NSLog(@"%s : %ld", __PRETTY_FUNCTION__,(long)userCategory);
    if (self.userCategory != userCategory) {
        _userCategory = userCategory;
        [[NSUserDefaults standardUserDefaults] setInteger:userCategory forKey:HOLAUserDefaultCategoryKey];
    }
}

-(void)setUserDistance:(NSInteger)userDistance{
    if (self.userDistance != userDistance) {
        _userDistance = userDistance;
        [[NSUserDefaults standardUserDefaults] setInteger:userDistance forKey:HOLAUserDefaultDistanceKey];
    }
}

#pragma mark -
#pragma mark UINavigationBar-based actions

- (IBAction)done:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Data

-(void)loadAvailableSortOptions {
    NSMutableArray *sortOptions = [[NSMutableArray alloc] init];
    [sortOptions addObject:@"Best Match"];
    [sortOptions addObject:@"Distance"];
    [sortOptions addObject:@"Most Reviewed"];
    
    self.sortOptions = [sortOptions copy];
}

-(void)loadAvailableDistanceOptions {
    NSMutableArray *distanceOptions = [[NSMutableArray alloc] init];
//    [distanceOptions addObject:@"0.3"];
    [distanceOptions addObject:@"1"];
    [distanceOptions addObject:@"5"];
    [distanceOptions addObject:@"20"];
    
    self.distanceOptions = [distanceOptions copy];
    
}

- (void)loadAvailableCategoryOptions {
    NSMutableArray *distanceOptions = [[NSMutableArray alloc] init];
    [distanceOptions addObject:@"All Restaurants"];
    [distanceOptions addObject:@"American"];
    [distanceOptions addObject:@"Barbeque"];
    [distanceOptions addObject:@"Beer Garden"];
    [distanceOptions addObject:@"Cafe"];
    [distanceOptions addObject:@"Chicken Wings"];
    [distanceOptions addObject:@"Chinese"];
    [distanceOptions addObject:@"Fast Food"];
    [distanceOptions addObject:@"French"];
    [distanceOptions addObject:@"Greek"];
    [distanceOptions addObject:@"Italian"];
    [distanceOptions addObject:@"Japanese"];
    [distanceOptions addObject:@"Mexican"];
    [distanceOptions addObject:@"Pizza"];
    [distanceOptions addObject:@"Pub Food"];
    [distanceOptions addObject:@"Salad"];
    [distanceOptions addObject:@"Sandwiches"];
    [distanceOptions addObject:@"Steak House"];
    [distanceOptions addObject:@"Sushi"];
    [distanceOptions addObject:@"Thai"];
    [distanceOptions addObject:@"Vegan"];
    
    self.categoryOptions = [distanceOptions copy];
    
    
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return HOLASettingsTableViewNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case HOLASettingsTableViewSectionSort:
            return [self.sortOptions count];
        case HOLASettingsTableViewSectionDistance:
            return [self.distanceOptions count];
        case HOLASettingsTableViewSectionCategory:
            return [self.categoryOptions count];
            break;
        case HOLASettingsTableViewSectionLogout:
            return PAWSettingsTableViewLogoutNumberOfRows;
            break;
        case HOLASettingsTableViewNumberOfSections:
            return 0;
            break;
    };

	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SettingsTableView";
    if (indexPath.section == HOLASettingsTableViewSectionSort) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = self.sortOptions[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        if (indexPath.row == self.userSort){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
    else if (indexPath.section == HOLASettingsTableViewSectionDistance) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ miles",self.distanceOptions[indexPath.row]];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        if (indexPath.row == self.userDistance){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
    else if (indexPath.section == HOLASettingsTableViewSectionCategory) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = self.categoryOptions[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;

//        if (self.userCategory == 0) {
//            NSLog(@"We have a zero category!");
//        }
        if (indexPath.row == self.userCategory){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    } else if (indexPath.section == HOLASettingsTableViewSectionLogout) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

        // Configure the cell.
        cell.textLabel.text = @"Log out of Chopsticks";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;

        return cell;
    }

    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case HOLASettingsTableViewSectionSort:
            return @"Sort by";
            break;
        case HOLASettingsTableViewSectionDistance:
            return @"Search Distance";
            break;
        case HOLASettingsTableViewSectionCategory:
            return @"Popular Categories";
            break;
        case HOLASettingsTableViewSectionLogout:
        case HOLASettingsTableViewNumberOfSections:
            return nil;
            break;
    }

    return nil;
}

#pragma mark -
#pragma mark UITableViewDelegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HOLASettingsTableViewSectionSort) {
        NSLog(@"didSelectRowAtIndexPath: %ld, %ld",(long)indexPath.section, (long)indexPath.row);
        [aTableView deselectRowAtIndexPath:indexPath animated:YES];
        UITableViewCell *selectedCell = [aTableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            return;
        }
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.userSort = indexPath.row;
        [self.tableView reloadData];
    }
    else if (indexPath.section == HOLASettingsTableViewSectionDistance) {
        NSLog(@"didSelectRowAtIndexPath: %ld, %ld",(long)indexPath.section, (long)indexPath.row);
        [aTableView deselectRowAtIndexPath:indexPath animated:YES];
        // if we were already selected, bail and save some work.
        UITableViewCell *selectedCell = [aTableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            return;
        }
        // uncheck all visible cells.
//        for (UITableViewCell *cell in [aTableView visibleCells]) {
//            NSLog(@"%@",cell.textLabel.text);
//            if (cell.accessoryType != UITableViewCellAccessoryNone) {
//                cell.accessoryType = UITableViewCellAccessoryNone;
//            }
//        }
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.userDistance = indexPath.row;
        [self.tableView reloadData];
    }else if (indexPath.section == HOLASettingsTableViewSectionCategory) {
        NSLog(@"didSelectRowAtIndexPath: %ld, %ld",(long)indexPath.section, (long)indexPath.row);
        [aTableView deselectRowAtIndexPath:indexPath animated:YES];

        // if we were already selected, bail and save some work.
        UITableViewCell *selectedCell = [aTableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            return;
        }

        // uncheck all visible cells.
//        for (UITableViewCell *cell in [aTableView visibleCells]) {
//            if (cell.accessoryType != UITableViewCellAccessoryNone) {
//                cell.accessoryType = UITableViewCellAccessoryNone;
//            }
//        }
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.userCategory = indexPath.row;
        [self.tableView reloadData];
    }
    else if (indexPath.section == HOLASettingsTableViewSectionLogout) {
        [aTableView deselectRowAtIndexPath:indexPath animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log out of Chopsticks?"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Log out"
                                                  otherButtonTitles:@"Cancel", nil];
        [alertView show];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == alertView.cancelButtonIndex) {
        // Log out.
        [PFUser logOut];

        [self.delegate settingsViewControllerDidLogout:self];
	}
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    return;
}

@end
