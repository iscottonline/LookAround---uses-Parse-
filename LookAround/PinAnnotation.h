//
//  PinAnnotation.h
//  lookAround
//
//  Created by Scott Fitsimones on 11/11/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface PinAnnotation : NSObject

@property (nonatomic, readonly)  CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *leftDetailImage;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *objectId;
-(id)initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location;

-(MKAnnotationView *)annotationView;

@end
