//
//  MessagesViewController.h
//  LookAround
//
//  Created by Scott Fitsimones on 11/2/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JSQMessages.h"

@interface MessagesViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friends;

@property (nonatomic, strong) NSMutableArray *messages;
@end
