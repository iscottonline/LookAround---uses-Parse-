//
//  ShoutViewController.m
//  lookAround
//
//  Created by Scott Fitsimones on 11/16/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "ShoutViewController.h"
@interface ShoutViewController ()

@end

@implementation ShoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 //   [self.view setBackgroundColor:[UIColor colorWithRed:.21 green:.5 blue:.2 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareIt)];
    
    
    [self loadInfo];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.mapView.showsUserLocation = NO;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    

  //  PFObject *currentPin = [[PFObject alloc] initWithClassName:@"shout"];
    PFQuery *query = [query initWithClassName:@"shout"];
    [query whereKey:@"objectId" equalTo:self.objectTitle];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.current = object;
        MKCoordinateRegion near;
        PFGeoPoint *coordinate = [object objectForKey:@"coordinates"];
        near.center.latitude = coordinate.latitude;
        near.center.longitude = coordinate.longitude;
        near.span.latitudeDelta = .015;
        near.span.longitudeDelta = .015;
        [self.mapView setRegion:near];
    }];

    


}
-(void)shareIt
{
    NSString* someText = [NSString stringWithFormat:@"%@\r%@\r%@", self.titleLabel.text, self.descriptionLabel.text, @"(via LookAround)"];

    
    NSArray* dataToShare = @[someText];
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];

    [self presentViewController:activityViewController animated:YES completion:^{}];
}
-(void)loadInfo
{
    self.titleLabel.text = self.objectTitle;
    self.descriptionLabel.text = self.objectDesc;

    self.descriptionLabel.font = [UIFont systemFontOfSize:22];
    self.descriptionLabel.textColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
