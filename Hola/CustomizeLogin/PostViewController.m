//
//  PostViewController.m
//  Hola
//
//  Created by Chang-Che Lu on 3/20/15.
//  Copyright (c) 2015 Chang-Che Lu. All rights reserved.
//

#import "PostViewController.h"
#import "Constants.h"

@interface PostViewController ()

@property (nonatomic, assign) NSUInteger maximumCharacterCount;

@end

@implementation PostViewController

@synthesize rest;

#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _maximumCharacterCount = 140;
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(done)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(post)];
    
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 144.0f, 26.0f)];
    self.characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 144.0f, 21.0f)];
    self.characterCountLabel.backgroundColor = [UIColor clearColor];
    self.characterCountLabel.textColor = [UIColor whiteColor];
    [accessoryView addSubview:self.characterCountLabel];
    
    self.textView.inputAccessoryView = accessoryView;
    self.textView.delegate = self;
    
    [self updateCharacterCountLabel];
    [self checkCharacterCount];
    
    NSLog(@"Post - rest: %@", self.rest.restaurant_id);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UINavigationBar-based actions
-(void) takePhoto{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void) done {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) post {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Capture current text field contents:
    [self updateCharacterCountLabel];
    BOOL isAcceptableAfterAutocorrect = [self checkCharacterCount];
    
    if (!isAcceptableAfterAutocorrect) {
        [self.textView becomeFirstResponder];
        return;
    }
    
    // Data prep:
    PFUser *user = [PFUser currentUser];
    NSNumber *rating = @4;
    NSLog(@" PFUSer : %@", user.username);
    // Stitch together a postObject and send this async to Parse
    PFObject *postObject = [PFObject objectWithClassName:HOLAParsePostsClassName];
    postObject[HOLAParsePostTextKey] = self.textView.text;
    postObject[HOLAParsePostUserKey] = user;
    postObject[HOLAParsePostUsernameKey] = user.username;
    postObject[HOLAParsePostsRestID] = rest.restaurant_id;
    postObject[HOLAParsePostRating] = rating;
    
    // Use PFACL to restrict future modifications to this object.
    PFACL *readOnlyACL = [PFACL ACL];
    [readOnlyACL setPublicReadAccess:YES];
    [readOnlyACL setPublicWriteAccess:NO];
    postObject.ACL = readOnlyACL;
    
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Couldn't save!");
            NSLog(@"%@", error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Ok", nil];
            [alertView show];
            return;
        }
        if (succeeded) {
            NSLog(@"Successfully saved!");
            NSLog(@"%@", postObject);
            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:PAWPostCreatedNotification object:nil];
            });
            [self done];
        } else {
            NSLog(@"Failed to save.");
        }
    }];
    
    
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self updateCharacterCountLabel];
    [self checkCharacterCount];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > _maximumCharacterCount) ? NO : YES;
}

#pragma mark -
#pragma mark Accessors

- (void)setMaximumCharacterCount:(NSUInteger)maximumCharacterCount {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.maximumCharacterCount != maximumCharacterCount) {
        _maximumCharacterCount = maximumCharacterCount;
        
        [self updateCharacterCountLabel];
        [self checkCharacterCount];
    }
}

#pragma mark -
#pragma mark Private

- (void)updateCharacterCountLabel {
    
    NSUInteger count = [self.textView.text length];
    self.characterCountLabel.text = [NSString stringWithFormat:@"%lu/%lu",
                                     (unsigned long)count,
                                     (unsigned long)self.maximumCharacterCount];
    if (count > self.maximumCharacterCount || count == 0) {
        self.characterCountLabel.font = [UIFont boldSystemFontOfSize:self.characterCountLabel.font.pointSize];
    } else {
        self.characterCountLabel.font = [UIFont systemFontOfSize:self.characterCountLabel.font.pointSize];
    }
}

- (BOOL)checkCharacterCount {
    BOOL enabled = NO;
    
    NSUInteger count = [self.textView.text length];
    if (count > 0 && count < self.maximumCharacterCount) {
        enabled = YES;
    }
    
    self.postButton.enabled = enabled;
    
    return enabled;
}

@end
