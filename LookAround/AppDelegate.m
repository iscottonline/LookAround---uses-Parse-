//
//  AppDelegate.m
//  LookAround
//
//  Created by Scott Fitsimones on 11/2/14.
//  Copyright (c) 2014 Bolt Visual. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
        
        // Register for Push Notitications, if running iOS 8
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                            UIUserNotificationTypeBadge |
                                                            UIUserNotificationTypeSound);
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                     categories:nil];
            [application registerUserNotificationSettings:settings];
            [application registerForRemoteNotifications];
            
        } else {
            // Register for Push Notifications before iOS 8
            [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                             UIRemoteNotificationTypeAlert |
                                                             UIRemoteNotificationTypeSound)];
        }
        
    [Parse setApplicationId:@"3JcI0lRfOYPLLoIKGDL7VgqVUXaIusEZ7v5oA2xp"
                  clientKey:@"B7Ev3T5v3issLgURqnXyV4S0voOGxmOogSWB3vFu"];
 //  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //tab1
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:.28 green:.7 blue:.4 alpha:1]];
    [self customizeInterface];
    
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *install = [PFInstallation currentInstallation];
    [install setDeviceTokenFromData:deviceToken];
     install.channels = @[ @"global" ];
    [install saveInBackground];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
    tab.selectedIndex = 1;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)customizeInterface
{
    //Customize Navbar
//  [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:.28 green:.7 blue:.4 alpha:1]];
   // UIFont *moz = [UIFont fontWithName:@"Montserrat-Light.ttf" size:18];

    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],  UITextAttributeTextColor,
     [UIFont fontWithName:@"Avenir-Heavy" size:24], NSFontAttributeName, nil]];
    
}
@end
