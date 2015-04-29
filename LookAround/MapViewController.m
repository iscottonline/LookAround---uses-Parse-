//
//  MapViewController.m
//  lookAround
//
//  Created by Scott Fitsimones on 11/10/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "MapViewController.h"
#import "ComposeViewController.h"
#import "UserAnnotationView.h"
#import <QuartzCore/QuartzCore.h>
#import "ShoutViewController.h"
@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.shoutSwitch addTarget:self action:@selector(hideShouts) forControlEvents:UIControlEventValueChanged];
    [self.userSwitch addTarget:self action:@selector(hideUsers) forControlEvents:UIControlEventValueChanged];
    self.toolbar.center = CGPointMake(self.view.center.x, -50);
        self.toolbar.alpha = 0;
    self.zoomer.layer.borderWidth = .05;
    self.zoomed = NO;
    UIColor *color = [UIColor blueColor];
    self.zoomer.titleLabel.layer.shadowColor = [color CGColor];
       self.zoomer.layer.shadowRadius = 1.0f;
       self.zoomer.layer.shadowOpacity = .4;
       self.zoomer.layer.shadowOffset = CGSizeZero;
       self.zoomer.layer.masksToBounds = NO;
    self.zoomer.alpha = .9;
    
    self.zoomer.layer.cornerRadius = 6;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(post)];
    [item setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = item;
   
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list23"] style:UIBarButtonSystemItemAction target:self action:@selector(filters)];
    [item2 setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = item2;
    
    UITapGestureRecognizer  *tapGestureRacognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOn:)];
    tapGestureRacognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGestureRacognizer];
    
   
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.locationManager startUpdatingLocation];
    
    [self.locationManager requestAlwaysAuthorization];
    self.latitude = self.locationManager.location.coordinate.latitude;
    self.longitude = self.locationManager.location.coordinate.longitude;
    
    self.mapView.showsUserLocation = NO;
    self.mapView.mapType = MKMapTypeStandard;
    MKCoordinateRegion near = self.mapView.region;
    self.mapView.delegate = self;
    near.center.latitude = self.latitude;
    near.center.longitude = self.longitude;
    near.span.latitudeDelta = .015;
    near.span.longitudeDelta = .015;
    

    [self.mapView removeAnnotations:self.mapView.annotations];
    [self addPoints];
    [self addShouts];
    [self addPlaces];
  [self.mapView setRegion:near animated:NO];
    
    [self.view sendSubviewToBack:self.mapView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"updateMap" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Methods

-(void)hideUsers
{
    if ([self.userSwitch isOn]) {
        [self.mapView addAnnotations:self.allAnnotations];
    } else {
        [self.mapView removeAnnotations:self.allAnnotations];
        [self.locationManager startUpdatingLocation];
        
        [self.locationManager requestAlwaysAuthorization];
        self.latitude = self.locationManager.location.coordinate.latitude;
        self.longitude = self.locationManager.location.coordinate.longitude;
        MKCoordinateRegion near = self.mapView.region;
        near.center.latitude = self.latitude;
        near.center.longitude = self.longitude;
        near.span.latitudeDelta = .015;
        near.span.longitudeDelta = .015;
        [self.mapView setRegion:near];

    }
}
-(void)hideShouts
{
    if ([self.shoutSwitch isOn]) {
        [self.mapView addAnnotations:self.allShoutAnnotations];
    } else {
        [self.mapView removeAnnotations:self.allShoutAnnotations];

        [self.locationManager startUpdatingLocation];
        [self.locationManager requestAlwaysAuthorization];
        self.latitude = self.locationManager.location.coordinate.latitude;
        self.longitude = self.locationManager.location.coordinate.longitude;
        MKCoordinateRegion near = self.mapView.region;
        near.center.latitude = self.latitude;
        near.center.longitude = self.longitude;
        near.span.latitudeDelta = .015;
        near.span.longitudeDelta = .015;
        [self.mapView setRegion:near];
    
    }
}

-(void)reload:(NSNotification *)note
{
    if (note) {
    NSString *title = [[note userInfo] valueForKey:@"title"];
    NSLog(@"Received Notification - Notif called = %@", title);
    self.postedTitle = title;
    NSLog(@"called");
    }
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self addShouts];
    [self addPoints];
    [self.locationManager startUpdatingLocation];
    
    [self.locationManager requestAlwaysAuthorization];
    self.latitude = self.locationManager.location.coordinate.latitude;
    self.longitude = self.locationManager.location.coordinate.longitude;
    MKCoordinateRegion near = self.mapView.region;
    near.center.latitude = self.latitude;
    near.center.longitude = self.longitude;
    near.span.latitudeDelta = .015;
    near.span.longitudeDelta = .015;
    [self.mapView setRegion:near];
    
}


-(void)addPlaces
{
    self.locations = [[NSMutableArray alloc] init];
        self.locationAnnotations = [[NSMutableArray alloc] init];
    PFGeoPoint *me = [PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
    PFQuery *places = [PFQuery queryWithClassName:@"locations"];
    [places whereKey:@"coordinates" nearGeoPoint:me withinMiles:1.5];
    [places findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
  
            self.locations = [NSMutableArray arrayWithArray:objects];

            for (int i =0; i <[self.locations count]; i++) {
                NSLog(@"%d", i);
                PFObject *currentObj = [self.locations objectAtIndex:i];
        PFGeoPoint *loc = [currentObj objectForKey:@"coordinates"];
                
                CLLocationCoordinate2D point = CLLocationCoordinate2DMake(loc.latitude, loc.longitude);
                NSString *name =  [[self.locations objectAtIndex:i]  objectForKey:@"title"];
                PinAnnotation *pin = [[PinAnnotation alloc] initWithTitle:name location:point];
                
           //     pin.subtitle = [[self.locations objectAtIndex:i] objectForKey:@"description"];
       //         pin.image = [UIImage imageNamed:@"bar"];
                pin.objectId = [currentObj objectId];
                NSString *type = [currentObj objectForKey:@"type"];
                if ([type isEqualToString:@"school"]) {
            pin.type = @"school";
                }
                if ([type isEqualToString:@"gas"]) {
                    pin.type = @"gas";
                }
                if ([type isEqualToString:@"fitness"]) {
                    pin.type = @"fitness";
                }
                if ([type isEqualToString:@"photoop"]) {
                    pin.type = @"photoop";
                }
                if ([type isEqualToString:@"bar"]) {
                    pin.type = @"bar";
                }
                if ([type isEqualToString:@"atm"]) {
                    pin.type = @"atm";
                }
                if ([type isEqualToString:@"shopping"]) {
                    pin.type = @"shopping";
                }
                if ([type isEqualToString:@"entertainment"]) {
                    pin.type = @"entertainment";
                }
                if ([type isEqualToString:@"church"]) {
                    pin.type = @"church";
                }
                if ([type isEqualToString:@"public"]) {
                    pin.type = @"public";
                }
                if ([type isEqualToString:@"music"]) {
                    pin.type = @"music";
                }
                if ([type isEqualToString:@"food"]) {
                    pin.type = @"food";
                }
                
                [self.locationAnnotations addObject:pin];
            
            }
            
            [self.mapView addAnnotations:self.locationAnnotations];
                   [self openAnnotation:self.posted];
            
        }
    }];
}



-(void)addShouts
{
    self.allShoutAnnotations = [[NSMutableArray alloc] init];
    self.allShouts = [[NSMutableArray alloc] init];
    PFGeoPoint *me = [PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
    PFQuery *nearbyShoutsQuery = [PFQuery queryWithClassName:@"shouts"];
    [nearbyShoutsQuery whereKey:@"coordinates" nearGeoPoint:me withinMiles:1.5];
    [nearbyShoutsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"There's %lu", [objects count]);
            self.allShouts = [NSMutableArray arrayWithArray:objects];
             NSLog(@"There's %lu", [self.allShouts count]);


     for (int i =0; i <[self.allShouts count]; i++) {
         PFGeoPoint *location = [[self.allShouts objectAtIndex:i] objectForKey:@"coordinates"];
         CLLocationCoordinate2D point = CLLocationCoordinate2DMake(location.latitude, location.longitude);
         NSString *name =  [[self.allShouts objectAtIndex:i]  objectForKey:@"title"];
         PinAnnotation *pin = [[PinAnnotation alloc] initWithTitle:name location:point];
         pin.subtitle = [[self.allShouts objectAtIndex:i] objectForKey:@"message"];
         pin.image = [UIImage imageNamed:@"shoutmark"];
         pin.type = @"shout";
      pin.objectId = [[self.allShouts objectAtIndex:i] objectId];
         
         PFFile *imageFile = [[self.allShouts objectAtIndex:i] objectForKey:@"image"];
         if (imageFile) {
         [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
              pin.leftDetailImage = [UIImage imageWithData:data];
             NSLog(@"PIN WITH DATA");
                [self.allShoutAnnotations addObject:pin];
             [self.mapView removeAnnotations:self.allShoutAnnotations];
                         [self.mapView addAnnotations:self.allShoutAnnotations];
         }];
         } else {
                      [self.allShoutAnnotations addObject:pin];
         }
        
         if ([name isEqualToString: self.postedTitle]) {
             NSLog(@"MATCH---");
             self.posted = pin;
         }
         

        // NSLog(@"title, %@", name);


     }
 
            [self.mapView addAnnotations:self.allShoutAnnotations];
            [self openAnnotation:self.posted];
            
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"mapPin"];
        aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapPin"];
    UIButton *right = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    aView.rightCalloutAccessoryView = right;
   
    PinAnnotation *ann = (PinAnnotation *)annotation;
 
    if ([ann.type  isEqual: @"shout"])
    {
 
        if (ann.leftDetailImage) {
        NSLog(@"%@", ann.leftDetailImage);
        UIImageView    *myPic = [[UIImageView alloc] initWithImage:ann.leftDetailImage];
            myPic.frame = CGRectMake(0, 0, 40, 40);
            aView.leftCalloutAccessoryView = myPic;
        }
        aView.image = [UIImage imageNamed:@"shoutmark"];
        UIButton *right = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [right setImage:[UIImage imageNamed:@"expand42"] forState:UIControlStateNormal];
        aView.rightCalloutAccessoryView = right;
      //  aView.transform = CGAffineTransformMakeRotation(-40 *M_PI/180);
    } else if ([ann.type isEqualToString:@"school"]) {
          aView.image = [UIImage imageNamed:@"school"];
        aView.frame = CGRectMake(0, 0, 30, 30);
}   else if ([ann.type isEqualToString:@"gas"]) {
    aView.image = [UIImage imageNamed:@"gas"];
       aView.frame = CGRectMake(0, 0, 30, 30);
    }
    else if ([ann.type isEqualToString:@"fitness"]) {
           aView.image = [UIImage imageNamed:@"fitness"];
           aView.frame = CGRectMake(0, 0, 30, 30);
    }
    else if  ([ann.type isEqualToString:@"photoop"]) {
        aView.image = [UIImage imageNamed:@"gas"];
           aView.frame = CGRectMake(0, 0, 30, 30);
    }
    else if  ([ann.type isEqualToString:@"bar"]) {
 aView.image = [UIImage imageNamed:@"bar"];
           aView.frame = CGRectMake(0, 0, 30, 30);
    }
    else if  ([ann.type isEqualToString:@"atm"]) {
        aView.image = [UIImage imageNamed:@"ATM"];
           aView.frame = CGRectMake(0, 0, 30, 30);
    }
    else if  ([ann.type isEqualToString:@"shopping"]) {
      aView.image = [UIImage imageNamed:@"shopping spot"];
           aView.frame = CGRectMake(0, 0, 30, 30);
    }
    else if  ([ann.type isEqualToString:@"entertainment"]) {
      aView.image = [UIImage imageNamed:@"fun"];
           aView.frame = CGRectMake(0, 0, 30, 30);
    }
    else if  ([ann.type isEqualToString:@"church"]) {
     aView.image = [UIImage imageNamed:@"church"];
           aView.frame = CGRectMake(0, 0, 30, 30);
    }
    else if  ([ann.type isEqualToString:@"public"]) {
        aView.image = [UIImage imageNamed:@"public spot"];
           aView.frame = CGRectMake(0, 0, 30, 30);
    }
    else if  ([ann.type isEqualToString:@"music"]) {
   aView.image = [UIImage imageNamed:@"record"];
           aView.frame = CGRectMake(0, 0, 30, 30);
    }
    else if  ([ann.type isEqualToString:@"food"]) {
      aView.image = [UIImage imageNamed:@"cutlery"];
           aView.frame = CGRectMake(0, 0, 30, 30);
    }
    else {
        UIButton *right = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aView.rightCalloutAccessoryView = right;
        aView.image = [UIImage imageNamed:@"profilemark2"];
    }
    aView.canShowCallout = YES;
    return aView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    PinAnnotation *ann = (PinAnnotation *)view.annotation;
    
    self.selectedObjectTitle = view.annotation.title;
    self.selectedObjectInfo = view.annotation.subtitle;
    self.selectedObjectId = ann.objectId;
    self.selectedObjectType = ann.type;
    
    [self performSegueWithIdentifier:@"shout" sender:nil];
    
}

-(void)openAnnotation:(id)annotation
{
    [self.mapView selectAnnotation:annotation animated:YES];
}
-(void)addPoints
{
//    NSArray *overlayArray = [[NSArray alloc] init];
//

    self.allAnnotations = [[NSMutableArray alloc] init];
    PFGeoPoint *me = [PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
    
    PFQuery  *nearbyUsersQuery = [PFUser query];
    [nearbyUsersQuery whereKey:@"coordinates" nearGeoPoint:me withinMiles:1.5];
    [nearbyUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
    self.nearbyUsers = [NSMutableArray arrayWithArray:objects];
 for (int i=0; i<[self.nearbyUsers count]; i++)
    {
        
        PFGeoPoint *location = [[self.nearbyUsers objectAtIndex:i] objectForKey:@"coordinates"];
      CLLocationCoordinate2D point = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        NSString *name =  [[self.nearbyUsers objectAtIndex:i]  objectForKey:@"displayName"];
        PinAnnotation *pin = [[PinAnnotation alloc] initWithTitle:name location:point];
           pin.type = @"user";
 //       pin.subtitle = @"'Shitty coffee'";
        [self.allAnnotations addObject:pin];
    }
    
    [self.mapView addAnnotations:self.allAnnotations];
        
        }
    }];
}




// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"shout"]) {
    
        ShoutViewController *dest = (ShoutViewController *)[segue  destinationViewController];
        NSLog(@"%@", self.selectedObjectType);
    dest.objectTitle = self.selectedObjectId;
    dest.objectDesc = self.selectedObjectType;
        
        
        }
}


#pragma mark - Delegate Methods
-(void)post
{
 [self performSegueWithIdentifier:@"post" sender:self];
}
- (IBAction)zoomOn:(id)sender {
    
    if (self.zoomed == NO) {
    //    self.zoomer.imageView.image = [UIImage imageNamed:@"minus"];
        [self.zoomer setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        self.zoomed = YES;
    MKCoordinateRegion near = self.mapView.region;
    near.center.latitude = self.latitude;
    near.center.longitude = self.longitude;
      CLLocationCoordinate2D point = CLLocationCoordinate2DMake(self.latitude, self.longitude);
  //  near.span.latitudeDelta = .00000000000001;
 //   near.span.longitudeDelta = .000000000001;
        
        near = MKCoordinateRegionMakeWithDistance(point, 2, 1);
    [self.mapView setRegion:near animated:YES];
} else {
    self.zoomed = NO;
    [self.zoomer setImage:[UIImage imageNamed:@"zoom16"] forState:UIControlStateNormal];
    MKCoordinateRegion near = self.mapView.region;
    near.center.latitude = self.latitude;
    near.center.longitude = self.longitude;

    near.span.latitudeDelta = .02;
    near.span.longitudeDelta = .02;
    [self.mapView setRegion:near animated:YES];

    
        }
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
        [self.mapView removeAnnotations:self.mapView.annotations];
    self.postedTitle = nil;
    self.allAnnotations = nil;
    self.allShoutAnnotations = nil;
    self.allShouts = nil;
    self.nearbyUsers = nil;
    self.locations = nil;
    NSLog(@"%s", self.zoomed ? "true" : "false");
    if (self.zoomed == YES) {
        [self zoomOn:self];
    }
}

-(void)filters
{
    if (self.toolbar.alpha == 0) {
               self.toolbar.center = CGPointMake(self.view.center.x, 40);
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.toolbar.center = CGPointMake(self.view.center.x, 86);
            self.toolbar.alpha = 1;
        } completion:nil];
 
    } else {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.toolbar.alpha = 0;
             self.toolbar.center = CGPointMake(self.view.center.x, 40);
        } completion:nil];
    }
}



@end
