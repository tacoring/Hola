//
//  MyLogInViewController.h
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyLogInViewController;

@protocol MyLogInViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin:(MyLogInViewController *)controller;

@end


//@interface MyLogInViewController : PFLogInViewController
@interface MyLogInViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<MyLogInViewControllerDelegate> delegate;


@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

@end
