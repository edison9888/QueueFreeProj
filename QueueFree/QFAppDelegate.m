//
//  QFAppDelegate.m
//  QueueFree
//
//  Created by BuG.BS on 12-10-24.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "QFAppDelegate.h"

@implementation QFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"QueueFree" ofType:@"plist"];
    
    self.Database = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    for (int idx = 0; idx < self.Database.count; ++idx){
        NSMutableDictionary *tempDic = [[self.Database objectAtIndex:idx] mutableCopy];
        [tempDic setObject:[NSString stringWithFormat:@"%d",arc4random()%21] forKey:@"people0"];
        [tempDic setObject:[NSString stringWithFormat:@"%d",arc4random()%21] forKey:@"people1"];
        [tempDic setObject:[NSString stringWithFormat:@"%d",arc4random()%21] forKey:@"people2"];
        [self.Database replaceObjectAtIndex:idx withObject:tempDic];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSArray *)getDataArray
{
    return self.Database;
}

@end
