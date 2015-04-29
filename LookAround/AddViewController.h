//
//  AddViewController.h
//  LookAround
//
//  Created by Scott Fitsimones on 11/6/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface AddViewController : UITableViewController
 @property (nonatomic, strong)  CLLocationManager *locationManager;

@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSArray *closeUsers;
@property (nonatomic, strong) NSMutableArray *selectedUsers;
@property (nonatomic, strong) NSMutableArray *selectedUsersNames;
@property (nonatomic, strong)  PFQuery *query;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

@end
