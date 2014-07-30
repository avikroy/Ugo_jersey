//
//  AppDelegate.m
//  Ugo jersey
//
//  Created by Debasish Pal on 20/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import "DBManager.h"
#import "Global.h"
@implementation AppDelegate
@synthesize audioPlayerClk;
@synthesize _session;
- (void)dealloc
{
    [_window release];
    [_loginvc release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
   
    [DBManager checkAndCreateDatabaseAtPath:[DBManager getDBPath]];
    #ifdef DEBUG
    NSLog(@"DB Path > %@",[DBManager getDBPath]);
   #endif

    self.loginvc = [[[LoginVC alloc] init] autorelease];
     self.navigation=[[UINavigationController alloc]initWithRootViewController:self.loginvc];
   // [self.navigation.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    [Global sharedInstance];
    if(![Global sharedInstance].allowedTicketArr)
    [Global getdata];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(242.0f/255.0f) green:(104.0f/255.0f) blue:(35.0f/255.0f) alpha:1.0f]];
//    self.navigation.navigationBar.tintColor = [UIColor colorWithRed:(242.0f/255.0f) green:(104.0f/255.0f) blue:(35.0f/255.0f) alpha:1.0f];
    self.window.rootViewController = self.navigation;
    [self.navigation.navigationBar setTranslucent:NO];
    [self.window makeKeyAndVisible];
    
    [self playClk];
    
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
      [[FBSession activeSession] close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)playClk
{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/camera_click_sound.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        audioPlayerClk = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (audioPlayerClk == nil)
            NSLog(@"error=%@",[error description]);
        else
        {
            audioPlayerClk.numberOfLoops =0;
            audioPlayerClk.volume = 1.0f;
            //avp.delegate = self;
            [audioPlayerClk prepareToPlay];
        }
    }


@end
