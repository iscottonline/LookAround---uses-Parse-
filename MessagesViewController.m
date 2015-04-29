//
//  MessagesViewController.m
//  LookAround
//
//  Created by Scott Fitsimones on 11/2/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "MessagesViewController.h"
#import <Parse/Parse.h>
#import "AddViewController.h"

@interface MessagesViewController ()

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem    *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAdd)];
    [item setTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    PFQuery *query = [PFQuery queryWithClassName:@"messages"];
    [query whereKey:@"recepients" equalTo:[[PFUser currentUser] objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.messages = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
            NSLog(@"Retrieved %lu messages", (unsigned long)[self.messages count]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.messages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    NSString *sender = [message objectForKey:@"senderName"];
    NSMutableArray *recepients = [message objectForKey:@"recepientNames"];
        [recepients insertObject:sender atIndex:0];
    [recepients removeObject:[[PFUser currentUser] objectForKey:@"displayName"]];
    NSString *recepientNames = [recepients componentsJoinedByString:@", "];
//    NSString *final = [sender stringByAppendingString:recepientNames];
    cell.textLabel.text = recepientNames;
    cell.detailTextLabel.text = [message objectForKey:@"text"];
       return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    [self performSegueWithIdentifier:@"showConvo" sender:self];
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

-(void)showAdd
{
   [self performSegueWithIdentifier:@"showAddView" sender:self];


}

@end
