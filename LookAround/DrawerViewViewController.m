//
//  DrawerViewViewController.m
//  lookAround
//
//  Created by Scott Fitsimones on 11/15/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "DrawerViewViewController.h"
#import "MMDrawerController+Subclass.h"
#import "MapViewController.h"
@interface DrawerViewViewController ()

@end

@implementation DrawerViewViewController

- (id)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    
    UIViewController * leftDrawer = [[UIViewController alloc] init];
    UIViewController * center = [story instantiateViewControllerWithIdentifier:@"maps"];
    
    centerViewController = center;
    leftDrawerViewController = leftDrawer;
    
    return self;
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
