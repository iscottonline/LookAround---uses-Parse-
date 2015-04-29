//
//  SignupViewController.m
//  LookAround
//
//  Created by Scott Fitsimones on 11/3/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "MBProgressHUD.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [self.navigationController.navigationBar setHidden:YES];




    
    // Do any additional setup after loading the view.
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}




-(IBAction)signupButton:(id)sender
{
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
    NSString *firstName = [[self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] capitalizedString];
    NSString *lastName = [[self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] capitalizedString];
    
    
    if (email.length == 0 || password.length == 0 || firstName.length == 0 || lastName.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter a username, password, and email address!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = email;
        newUser.password = password;
        newUser.email = email;

        NSInteger len = [lastName length] - 1;
        NSRange range = {1,len};
        NSString *lastLetter = [[[lastName stringByReplacingCharactersInRange:range withString:@""] capitalizedString] stringByAppendingString:@"."];
        NSString *show = [NSString stringWithFormat:@"%@ %@", firstName, lastLetter];
        
 [newUser setObject:firstName forKey:@"firstName"];
 [newUser setObject:lastName forKey:@"lastName"];
[newUser setObject:show forKey:@"displayName"];

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:email forKey:@"user"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"filled" object:nil userInfo:dictionary];
                
                [self dismissViewControllerAnimated:YES completion:nil];

            }
        }];
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
