//
//  AppDelegate.h
//  Ugo jersey
//
//  Created by Debasish Pal on 20/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MailObject.h"

@class LoginVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate,MailObjectDelegate>
{
    FBSession *_session;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginVC *loginvc;
@property(nonatomic,strong)UINavigationController *navigation;

@property (strong, nonatomic)AVAudioPlayer *audioPlayerClk;

@property (nonatomic, strong)  FBSession *_session;
@property (nonatomic, retain) MailObject *mail;

-(void)playClk;
@end
