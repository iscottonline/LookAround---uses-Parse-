//
//  LoginViewController.h
//  LookAround
//
//  Created by Scott Fitsimones on 11/3/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (weak, nonatomic) IBOutlet UITextField *userTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


- (IBAction)loginButton:(id)sender;

@end
