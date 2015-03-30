//
//  PostViewController.h
//  Hola
//
//  Created by Chang-Che Lu on 3/20/15.
//  Copyright (c) 2015 Chang-Che Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantModel.h"

@class PostViewController;

@protocol PostViewControllerDelegate <NSObject>

@end

@interface PostViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) id<PostViewControllerDelegate> delegate;
@property (nonatomic, weak) RestaurantModel *rest;

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UILabel *characterCountLabel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *postButton;

@end
