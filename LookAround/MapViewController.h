//
//  MapViewController.h
//  lookAround
//
//  Created by Scott Fitsimones on 11/10/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "PinAnnotation.h"
@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
 @property (nonatomic, strong)  CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *nearbyUsers;
@property (nonatomic, strong) NSMutableArray *allAnnotations;
@property (nonatomic, strong) NSMutableArray *allShouts;
@property (nonatomic, strong) NSMutableArray *allShoutAnnotations;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSMutableArray *locationAnnotations;

@property (nonatomic, strong) PinAnnotation *posted;
@property (nonatomic, strong) NSString *postedTitle;

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (weak, nonatomic) IBOutlet UIButton *zoomer;
@property (nonatomic)  BOOL zoomed;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UISwitch *userSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shoutSwitch;

@property (nonatomic, strong) NSString *selectedObjectTitle;
@property (nonatomic, strong) NSString *selectedObjectInfo;
@property (nonatomic, strong) NSString *selectedObjectId;
@property (nonatomic, strong) NSString *selectedObjectType;
- (IBAction)zoomOn:(id)sender;

@end
