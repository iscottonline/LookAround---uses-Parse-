//
//  ComposeViewController.h
//  lookAround
//
//  Created by Scott Fitsimones on 11/12/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ComposeViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIImageView *myView;

@property (weak, nonatomic) IBOutlet UISwitch *imageAdd;

@property (weak, nonatomic) IBOutlet UIButton *postButton;
- (IBAction)postContent:(id)sender;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

@end
