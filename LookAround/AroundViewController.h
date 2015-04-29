//
//  AroundViewController.h
//  LookAround
//
//  Created by Scott Fitsimones on 11/2/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
@interface AroundViewController : UITableViewController

 @property (nonatomic, strong)  CLLocationManager *locationManager;
@property (nonatomic, strong)   UIView *topView;
@property (nonatomic, strong)    UIImageView *img;

@property (nonatomic, strong) PFQuery *query;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSArray *closeUsers;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

@property (nonatomic, strong) NSMutableArray *arrowsArray;

@property (nonatomic, strong) NSMutableArray *nearbyUsers;
@property (nonatomic, strong) NSMutableArray *nearbyShouts;
@property (nonatomic, strong) NSMutableArray *nearbyLocations;
@property (nonatomic, strong) NSMutableArray *thingsToDo;
@property (nonatomic, strong) NSMutableArray *localNews;

@property BOOL show0;
@property BOOL show1;
@property BOOL show2;
@property BOOL show3;
@property BOOL show4;

@property (nonatomic, strong) NSString *selectedObjectTitle;
@property (nonatomic, strong) NSString *selectedObjectInfo;



@end
