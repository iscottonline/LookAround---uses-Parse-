//
//  LoginViewController.m
//  LookAround
//
//  Created by Scott Fitsimones on 11/3/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "LoginViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.passwordTextField.delegate = self;
    [self.activityView setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prefill:) name:@"filled" object:nil];
  
}

-(void)prefill:(NSNotification *)note
{
    NSLog(@"called");
  NSString *username =  [[note userInfo] objectForKey:@"user"];
    self.userTextField.text = username;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
   
 
 //   [NSThread sleepForTimeInterval:2];
         [self loginButton:self];
  
    return YES;
}

-(IBAction)loginButton:(id)sender
{
       [self.loginButton setTitle:@"" forState:UIControlStateNormal];
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
    NSString *username = [self.userTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (username.length == 0 || password.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Error" message:@"Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [self.activityView setHidden:YES];
        [self.activityView stopAnimating];
        [self.loginButton setTitle:@"Log in" forState:UIControlStateNormal];
    } else {

        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
         
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Error" message:@"Colud not log in. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [self.activityView setHidden:YES];
                [self.activityView stopAnimating];
                [self.loginButton setTitle:@"Log in" forState:UIControlStateNormal];
                
            } else {
            

                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
         }
        
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
