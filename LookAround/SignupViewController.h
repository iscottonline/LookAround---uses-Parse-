//
//  SignupViewController.h
//  LookAround
//
//  Created by Scott Fitsimones on 11/3/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, copy)  void (^nameTrain)(NSString *response);

@property (weak, nonatomic) IBOutlet UIImageView *backg;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)signupButton:(id)sender;
- (IBAction)back:(id)sender;

@end
