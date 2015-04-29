//
//  SettingsViewController.m
//  LookAround
//
//  Created by Scott Fitsimones on 11/7/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *logButton = [[UIBarButtonItem alloc] initWithTitle:@" Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    [logButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = logButton;
    // Do any additional setup after loading the view.
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
-(void)logout
{
    [PFUser logOut];

    self.tabBarController.selectedIndex = 0;
  [self performSegueWithIdentifier:@"goLog" sender:self];
    
}

@end
