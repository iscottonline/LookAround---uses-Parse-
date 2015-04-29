//
//  PinAnnotation.m
//  lookAround
//
//  Created by Scott Fitsimones on 11/11/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "PinAnnotation.h"
@implementation PinAnnotation

-(id)initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location
{
    self = [super init];
    if (self) {
        _title = newTitle;
        _coordinate = location;
    }
    return self;
}

-(MKAnnotationView *)annotationView
{
    MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"pin"];
    view.enabled = YES;
    view.canShowCallout = YES;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return view;
}



@end
