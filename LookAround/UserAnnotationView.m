//
//  UserAnnotationView.m
//  lookAround
//
//  Created by Scott Fitsimones on 11/13/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "UserAnnotationView.h"

@implementation UserAnnotationView


-(id)initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location
{
    self = [super init];
    if (self) {
        _title = newTitle;
        _coordinate = location;
    }

    return self;
}


-(MKAnnotationView *)mapView
{
    MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"pin"];
    view.enabled = YES;
    view.canShowCallout = YES;
    view.image = [UIImage imageNamed:@"profilemark2.png"];
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return view;
}


@end
