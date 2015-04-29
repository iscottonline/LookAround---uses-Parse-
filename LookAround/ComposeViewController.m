//
//  ComposeViewController.m
//  lookAround
//
//  Created by Scott Fitsimones on 11/12/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.view.backgroundColor = [UIColor colorWithRed:.305 green:.327 blue:.313 alpha:.55];

    // Do any additional setup after loading the view.
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textView.layer.borderWidth = 3.0f;
    self.textView.layer.cornerRadius = 7;
    self.textView.delegate = self;
    
    self.titleField.borderStyle = UITextBorderStyleRoundedRect;
    self.titleField.layer.borderWidth = 3.0f;
    self.titleField.layer.cornerRadius = 7;
    self.titleField.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [self.imageAdd addTarget:self action:@selector(pickOut:) forControlEvents:UIControlEventValueChanged];
}
-(void)pickOut:(id)sender {
    if ([sender isOn]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else
    {
        
    }
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosen = info[UIImagePickerControllerEditedImage];
    self.myView.alpha = 1;
    self.myView.image = chosen;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.imageAdd setOn:NO animated:YES];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
       self.myView.alpha = 0;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    [self.locationManager requestAlwaysAuthorization];
    self.latitude = self.locationManager.location.coordinate.latitude;
    self.longitude = self.locationManager.location.coordinate.longitude;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - IB Action
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postContent:(id)sender {
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
    if ([self.textView.text isEqual:@"Description (optional)"]) {
        self.textView.text = @"";
    }

    PFObject *shout = [PFObject objectWithClassName:@"shouts"];
    // If an image exists, upload it to Parse.
    if (self.myView.image) {

        
        NSData *imageData = UIImageJPEGRepresentation(self.myView.image, 0.3f );
        
        
        PFFile *imageObject = [PFFile fileWithName:@"image.jpg" data:imageData];
        
        [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            //   PFObject *shout = [PFObject objectWithClassName:@"shouts"];
                   [shout setObject:imageObject forKey:@"image"];
            [shout saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"SAVED");
            }];
        }];
 
    }
    [shout setObject:self.titleField.text forKey:@"title"];
    NSNumber *likes = [NSNumber numberWithInt:1];
    [shout setObject:likes forKey:@"likes"];
    [shout setObject:self.textView.text forKey:@"message"];
    [shout setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
   // [shout setObject: forKey:@"likes"];
    [shout setObject:point forKey:@"coordinates"];
    [shout saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Success.
            NSString *title = self.titleField.text;
            NSDictionary *dictionary = [NSDictionary dictionaryWithObject:title forKey:@"title"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMap" object:nil userInfo:dictionary];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    
}
@end
