//
//  AddViewController.m
//  LookAround
//
//  Created by Scott Fitsimones on 11/6/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    self.selectedUsers = [[NSMutableArray alloc] init];
    self.selectedUsersNames = [[NSMutableArray alloc] init];
    UIBarButtonItem    *item = [[UIBarButtonItem alloc] initWithTitle:@"Create " style:UIBarButtonItemStylePlain target:self action:@selector(group)];
    [item setTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.backBarButtonItem.title = @"cancel";
    self.navigationItem.title = @"new message";
  //  [self.navigationItem.rightBarButtonItem setTitle:@"Create"];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    [self.locationManager requestAlwaysAuthorization];
    self.latitude = self.locationManager.location.coordinate.latitude;
    self.longitude = self.locationManager.location.coordinate.longitude;
    
    
    PFGeoPoint *currentLocation = [PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
        NSLog(@"Made array");
    
    self.query = [PFUser query];
    [self.query whereKey:@"coordinates" nearGeoPoint:currentLocation];
    self.query.limit = 10;
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not connect to the server." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        } else {
            // Objects found successfully
            self.closeUsers = objects;
            NSLog(@"Log array %@", objects);
              [self.tableView reloadData];
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.closeUsers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFUser *add = [self.closeUsers objectAtIndex:indexPath.row];
    NSString *show = [add objectForKey:@"displayName"];
    cell.textLabel.text = show;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PFUser *canidate = [self.closeUsers objectAtIndex:indexPath.row];
    NSString *name = [canidate objectForKey:@"displayName"];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        // Remove user
        [self.selectedUsers removeObject:canidate.objectId];
        [self.selectedUsersNames removeObject:name];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        // Add use
        [self.selectedUsers addObject:canidate.objectId];
        [self.selectedUsersNames addObject:name];
          NSLog(@"Who's in it: %@",self.selectedUsers );
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
  
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)group
{
    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
    [[PFInstallation currentInstallation] saveEventually];
    // Build a query to match users with a birthday today
    PFQuery *innerQuery = [PFUser query];
    NSLog(@"%@", self.selectedUsersNames);
    [innerQuery whereKey:@"objectId" containedIn:self.selectedUsers];
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
  //  [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
    [pushQuery whereKey:@"user" matchesQuery:innerQuery];


    // Send push notification to query
    if (self.selectedUsers.count && self.selectedUsersNames) {
    [PFPush sendPushMessageToQueryInBackground:pushQuery
                                   withMessage:@"You have been invited to a converstation!"];
    PFObject *message = [PFObject objectWithClassName:@"messages"];
    [message setObject:[[PFUser currentUser] objectId] forKey:@"sender"];
        NSString *displayName = [[PFUser currentUser] objectForKey:@"displayName"];
        [message setObject:displayName forKey:@"senderName"];
       [message setObject:self.selectedUsers forKey:@"recepients"];
        [message setObject:self.selectedUsersNames forKey:@"recepientNames"];
    [message setObject:@"(conversation started)" forKey:@"text"];
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.selectedUsers = nil;
}
@end
