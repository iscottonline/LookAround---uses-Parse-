//
//  AroundViewController.m
//  LookAround
//
//  Created by Scott Fitsimones on 11/2/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "AroundViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ShoutViewController.h"

@interface AroundViewController ()

@end

@implementation AroundViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.show0 = NO;
        self.show1 = NO;
        self.show2 = NO;
        self.show3 = NO;
        self.show4 = NO;
    self.arrowsArray = [[NSMutableArray alloc] init];
    self.currentUser = [PFUser currentUser];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark2"]];
    hud.labelText = @"Welcome back!";
    [hud hide:YES afterDelay:1];
    
    // Put data in arrays
    self.nearbyUsers = [[NSMutableArray alloc] init];
    self.nearbyShouts =  [[NSMutableArray alloc] init];
    self.nearbyLocations =  [[NSMutableArray alloc] init];
    self.thingsToDo =  [[NSMutableArray alloc] init];
    self.localNews =  [[NSMutableArray alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
        [self.locationManager requestAlwaysAuthorization];

    [self updateTable];
}
-(void)updateTable
{
    self.latitude = self.locationManager.location.coordinate.latitude;
    self.longitude = self.locationManager.location.coordinate.longitude;
    PFGeoPoint *currentLocation = [PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];

    
    self.query = [PFUser query];
    [self.query whereKey:@"coordinates" nearGeoPoint:currentLocation];
    self.query.limit = 10;
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not connect to the server." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        } else {
            // Objects found successfully
            self.nearbyUsers = (NSMutableArray *)objects;
            self.arrowsArray = nil;
            self.arrowsArray = [[NSMutableArray alloc] init];
           [self.tableView reloadData];
        }
    }];
    

    PFQuery *nearbyShoutsQuery = [PFQuery queryWithClassName:@"shouts"];
    [nearbyShoutsQuery whereKey:@"coordinates" nearGeoPoint:currentLocation withinMiles:.7];
    [nearbyShoutsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.nearbyShouts = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        }}];
    
    PFQuery *nearbyLocationsQuery = [PFQuery queryWithClassName:@"locations"];
    [nearbyLocationsQuery whereKey:@"coordinates" nearGeoPoint:currentLocation withinMiles:.7];
    [nearbyLocationsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.nearbyLocations = [NSMutableArray arrayWithArray:objects];
            
            [self.tableView reloadData];
        }}];
    
    PFQuery *thingsQuery = [PFQuery queryWithClassName:@"userActivities"];
    [thingsQuery whereKey:@"coordinates" nearGeoPoint:currentLocation withinMiles:.7];
    [thingsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.thingsToDo = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        }}];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.currentUser = [PFUser currentUser];
     [self.navigationController.navigationBar setHidden:NO];
    if (self.currentUser == nil)
    {
          [self performSegueWithIdentifier:@"showLogin" sender:self];
    } else {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
        [self.locationManager requestAlwaysAuthorization];
    self.latitude = self.locationManager.location.coordinate.latitude;
    self.longitude = self.locationManager.location.coordinate.longitude;
    
//    NSNumber *lat = [NSNumber numberWithFloat:self.latitude];
//    NSNumber *lon = [NSNumber numberWithFloat:self.longitude];
    
   //  PFObject *location = [PFObject objectWithClassName:@"locations"];
        PFGeoPoint *coordinates = [PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
//    [location addObject:lat forKey:@"latitude"];
//    [location addObject:lon forKey:@"longitude"];
        
        PFUser *currentUser = [PFUser currentUser];
        [currentUser setObject:coordinates forKey:@"coordinates"];
  //  [location addObject:[[PFUser currentUser] objectId] forKey:@"userId"];
//    [location addObject:[[PFUser currentUser] username] forKey:@"username"];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                message:@"Could not communicate with the server."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            // Show close chats, users, hotspots
        }
    }];
    
    }

 [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];


//    PFQuery *query = [PFQuery queryWithClassName:@"location"];
//    [query whereKey:@"distance" lessThanOrEqualTo:@100];
//    [query orderByAscending:@"distance"];
//    query.limit = 20;
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (error) {
//            NSLog((@"Error"));
//        } else {
//            self.closeUsers = objects;
//            [self.tableView reloadData];
//        }
//    }];
    
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 5;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.nearbyUsers count];
    }
    if (section == 1) {
        return [self.nearbyShouts count];
    }
    if (section == 2) {
        return [self.nearbyLocations count];
    }
    if (section == 3) {
        return [self.thingsToDo count];
    }
    if (section == 4) {
        return [self.localNews count];
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height2 = 0;

    switch (indexPath.section) {
        case 0:
            if (self.show0) {
            return 40;
            } else {
                return 0;
            }
            break;
        case 1:
            if (self.show1) {
                return 40;
            } else {
                return 0;
            }
            break;
        case 2:
            if (self.show2) {
                return 40;
            } else {
                return 0;
            }
            break;
        case 3:
            if (self.show3) {
                return 40;
            } else {
                return 0;
            }
            break;
        case 4:
            if (self.show4) {
                return 40;
            } else {
                return 0;
            }
            break;
            
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    if (indexPath.section == 0) {
      identifier =  @"Cell_2";
    } else
    {
    identifier =  @"Cell_2";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
   // NSLog(@"%lu", [self.nearbyUsers count]);
    
    if (indexPath.section == 0) {
    if ([self.nearbyUsers objectAtIndex:indexPath.row])
    {
        PFUser *thisOne = [self.nearbyUsers objectAtIndex:indexPath.row];
        NSString *text =  [thisOne objectForKey:@"displayName"];
        PFGeoPoint *point = [thisOne objectForKey:@"coordinates"];
           PFGeoPoint *me = [PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
        double distance = [point distanceInMilesTo:me];
        cell.textLabel.font =  [UIFont fontWithName:@"Avenir-Heavy" size:18];
        cell.textLabel.text = text;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f mi",distance];
    }
    }
    if (indexPath.section == 1)  {

        if ([self.nearbyShouts objectAtIndex:indexPath.row]) {
            PFObject *thisOne2 = [self.nearbyShouts objectAtIndex:indexPath.row];
            NSString *text2 = [thisOne2 objectForKey:@"title"];
            NSString *objId = [thisOne2 objectForKey:@"senderId"];
            NSLog(@"%@", [thisOne2 objectForKey:@"senderId"]);
            cell.textLabel.font =  [UIFont fontWithName:@"Avenir-Heavy" size:18];
            cell.textLabel.text = [NSString stringWithFormat:@"\"%@\"", text2];
            PFQuery *query = [PFUser query];
            [query whereKey:@"objectId" equalTo:objId];
       [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
           cell.detailTextLabel.text = [object objectForKey:@"displayName"];
       }];
     }}
    if (indexPath.section == 2) {
        if ([self.nearbyLocations objectAtIndex:indexPath.row]) {
            PFObject *thisOne3 = [self.nearbyLocations objectAtIndex:indexPath.row];
            NSString *text2 = [thisOne3 objectForKey:@"title"];
            NSString *objId = [thisOne3 objectForKey:@"description"];
            
            cell.textLabel.font =  [UIFont fontWithName:@"Avenir-Heavy" size:18];
            cell.textLabel.text = [NSString stringWithFormat:@"\"%@\"", text2];
            cell.detailTextLabel.text = objId;
        }
 }
    
    if (indexPath.section == 3) {
        if ([self.thingsToDo objectAtIndex:indexPath.row]) {
            PFObject *thisOne4 = [self.thingsToDo objectAtIndex:indexPath.row];
            NSString *text2 = [thisOne4 objectForKey:@"title"];
            NSString *objId = [thisOne4 objectForKey:@"message"];
            
            cell.textLabel.font =  [UIFont fontWithName:@"Avenir-Heavy" size:18];
            cell.textLabel.text = [NSString stringWithFormat:@"\"%@\"", text2];
            cell.detailTextLabel.text = objId;
        }
    }



    
    
     return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *myView = [[UIView alloc] init];
    [myView setTintColor:[UIColor whiteColor]];
    
    return myView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width ,60)];
    float number = .7 - section*.04;
    [topView setBackgroundColor:[UIColor colorWithRed:number green:number blue:number alpha:1]];

     UIButton *topViewButton = [[UIButton alloc] initWithFrame:CGRectMake(-2, 0, self.view.frame.size.width+4 ,80)];
    [[topViewButton layer] setBorderWidth:1.0];
    [[topViewButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [topView addSubview:topViewButton];
    

    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, 6, self.view.frame.size.width ,40)];
    topLabel.textAlignment =  UITextAlignmentRight;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.font =    [UIFont fontWithName:@"Avenir-Heavy" size:24];
//    self.img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow483"]];
//    [self.img setFrame:CGRectMake(12, 12, 20, 20)];
//    [self.img setAlpha:.7];
//    self.img.image = [self.img.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [self.img setTintColor:[UIColor whiteColor]];
//
//
//  //  [self.arrowsArray removeAllObjects];
//    
////    [self.arrowsArray addObject:self.img];
//
//    [self.arrowsArray insertObject:self.img atIndex:section];
//    
//    [topView addSubview:self.img];
    
    if (section == 0) {
    topLabel.text = @"Users";
        self.img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user62"]];
        [self.img setFrame:CGRectMake(10, 10, 32, 32)];
        [self.img setAlpha:.9];
        self.img.image = [self.img.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.img setTintColor:[UIColor whiteColor]];
         [self.arrowsArray insertObject:self.img atIndex:section];
        [topView addSubview:self.img];
    }
    if (section == 1) {
        topLabel.text = @"Shouts";
        self.img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"speech6"]];
        [self.img setFrame:CGRectMake(10, 10, 32, 32)];
        [self.img setAlpha:.9];
        self.img.image = [self.img.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.img setTintColor:[UIColor whiteColor]];
        [self.arrowsArray insertObject:self.img atIndex:section];
        [topView addSubview:self.img];
    }
    if (section == 2) {
        topLabel.text = @"Locations";
        self.img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location54"]];
        [self.img setFrame:CGRectMake(10, 10, 32, 32)];
        [self.img setAlpha:.9];
        self.img.image = [self.img.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.img setTintColor:[UIColor whiteColor]];
        [self.arrowsArray insertObject:self.img atIndex:section];
        [topView addSubview:self.img];
    }
    if (section == 3) {
        topLabel.text = @"Things to Do";
        self.img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"election"]];
        [self.img setFrame:CGRectMake(10, 10, 32, 32)];
        [self.img setAlpha:.9];
        self.img.image = [self.img.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.img setTintColor:[UIColor whiteColor]];
        [self.arrowsArray insertObject:self.img atIndex:section];
        [topView addSubview:self.img];
    }
    if (section == 4) {
        topLabel.text = @"News";
        self.img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newspaper9"]];
        [self.img setFrame:CGRectMake(10, 10, 32, 32)];
        [self.img setAlpha:.9];
        self.img.image = [self.img.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.img setTintColor:[UIColor whiteColor]];
        [self.arrowsArray insertObject:self.img atIndex:section];
        [topView addSubview:self.img];
    }
   // topLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [topView addSubview:topLabel];
    
    if (section == 0) {
        [topViewButton addTarget:self action:@selector(expand0) forControlEvents:UIControlEventTouchUpInside];
    }
    if (section == 1) {
        [topViewButton addTarget:self action:@selector(expand1) forControlEvents:UIControlEventTouchUpInside];
    }
    if (section == 2) {
        [topViewButton addTarget:self action:@selector(expand2) forControlEvents:UIControlEventTouchUpInside];
    }
    if (section == 3) {
        [topViewButton addTarget:self action:@selector(expand3) forControlEvents:UIControlEventTouchUpInside];
    }
    if (section == 4) {
        [topViewButton addTarget:self action:@selector(expand4) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return topView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4)
    return 50.0f;
    else {
        return 0;
    }
}



-(void)expand0
{

    if (self.show0 == NO) {
    self.show0 = YES;
        
    UIImageView *change = [self.arrowsArray objectAtIndex:0];
      [change setAlpha:.7];

   change.image = [UIImage imageNamed:@"arrowUp"] ;
    change.image = [change.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [change setTintColor:[UIColor whiteColor]];
        
     //   self.arrowsArray = nil;
  //      self.arrowsArray= [[NSMutableArray alloc] init];
        [self.tableView reloadData];

    } else {
        self.show0  = NO;
        UIImageView *change = [self.arrowsArray objectAtIndex:0];
        [change setAlpha:.7];
        change.image = [UIImage imageNamed:@"arrow483"] ;
        change.image = [change.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [change setTintColor:[UIColor whiteColor]];

               [self.tableView reloadData];
    }
   
}
-(void)expand1
{
    
    if (self.show1 == NO) {
        self.show1 = YES;
     
        UIImageView *change = [self.arrowsArray objectAtIndex:1];
        [change setAlpha:.7];
        
        change.image = [UIImage imageNamed:@"arrowUp"] ;
        change.image = [change.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [change setTintColor:[UIColor whiteColor]];
        
        //   self.arrowsArray = nil;
        //      self.arrowsArray= [[NSMutableArray alloc] init];
        [self.tableView reloadData];
        
    } else {
        self.show1 = NO;
        UIImageView *change = [self.arrowsArray objectAtIndex:1];
        [change setAlpha:.7];
        change.image = [UIImage imageNamed:@"arrow483"] ;
        change.image = [change.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [change setTintColor:[UIColor whiteColor]];
               [self.tableView reloadData];
    }

    

}
-(void)expand2
{

    if (self.show2 == NO) {
        self.show2 = YES;
        //    [[self.arrowsArray objectAtIndex:0] setImage:[UIImage imageNamed:@"arrowUp"] forState:UIControlStateNormal];

        UIImageView *change = [self.arrowsArray objectAtIndex:2];
        [change setAlpha:.7];
        change.image = [UIImage imageNamed:@"arrowUp"] ;
        change.image = [change.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [change setTintColor:[UIColor whiteColor]];
               [self.tableView reloadData];
    } else {
        self.show2 = NO;
        UIImageView *change = [self.arrowsArray objectAtIndex:2];
        [change setAlpha:.7];
        change.image = [UIImage imageNamed:@"arrow483"] ;
        change.image = [change.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [change setTintColor:[UIColor whiteColor]];
               [self.tableView reloadData];
    }
    


    
}
-(void)expand3
{
    if (self.show3 == NO) {
        self.show3 = YES;
        //    [[self.arrowsArray objectAtIndex:0] setImage:[UIImage imageNamed:@"arrowUp"] forState:UIControlStateNormal];

        UIImageView *change = [self.arrowsArray objectAtIndex:3];
        [change setAlpha:.7];
        
        change.image = [UIImage imageNamed:@"arrowUp"] ;
        change.image = [change.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [change setTintColor:[UIColor whiteColor]];
               [self.tableView reloadData];
    } else {
        self.show3 = NO;
        UIImageView *change = [self.arrowsArray objectAtIndex:3];
        [change setAlpha:.7];
        change.image = [UIImage imageNamed:@"arrow483"] ;
        change.image = [change.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [change setTintColor:[UIColor whiteColor]];
               [self.tableView reloadData];
    }

    


    
}
-(void)expand4
{
    if (self.show4 == NO) {
        self.show4 = YES;
        //    [[self.arrowsArray objectAtIndex:0] setImage:[UIImage imageNamed:@"arrowUp"] forState:UIControlStateNormal];
    
        UIImageView *change = [self.arrowsArray objectAtIndex:4];
        [change setAlpha:.7];
        
        change.image = [UIImage imageNamed:@"arrowUp"] ;
        change.image = [change.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [change setTintColor:[UIColor whiteColor]];
               [self.tableView reloadData];
    } else {
        self.show4 = NO;
        UIImageView *change = [self.arrowsArray objectAtIndex:4];
        [change setAlpha:.7];
        change.image = [UIImage imageNamed:@"arrow483"] ;
        change.image = [change.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [change setTintColor:[UIColor whiteColor]];
               [self.tableView reloadData];
    }
    
    


    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedObjectTitle = cell.textLabel.text;
    self.selectedObjectInfo = cell.detailTextLabel.text;

    [self performSegueWithIdentifier:@"shoutOut" sender:self];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Instance Methods

-(void)showAdd
{
    [self performSegueWithIdentifier:@"showAddView" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"shoutOut"]) {
        
        ShoutViewController *dest = (ShoutViewController *)[segue  destinationViewController];
            NSLog(@"%@", self.selectedObjectTitle);
        dest.objectTitle = self.selectedObjectTitle;
        dest.objectDesc = self.selectedObjectInfo;
    }
}




@end
