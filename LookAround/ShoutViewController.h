//
//  ShoutViewController.h
//  lookAround
//
//  Created by Scott Fitsimones on 11/16/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
@interface ShoutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;

@property (strong, nonatomic) NSString *objectTitle;
@property (strong, nonatomic) NSString *objectDesc;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) PFObject *current;

@end
