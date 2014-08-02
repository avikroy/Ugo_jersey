//
//  MailObject.h
//  VehicleInspection
//
//  Created by Avik on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@protocol MailObjectDelegate <NSObject>
@optional
- (void) mailSuccess;
- (void) mailCancelled;
@end

@interface MailObject : NSObject<MFMailComposeViewControllerDelegate>
{
    MFMailComposeViewController *mailController;
    UIViewController *vController;
    id<MailObjectDelegate>delegate;
}

@property (nonatomic,retain) id<MailObjectDelegate>delegate;
@property (nonatomic, retain) NSString *mailBody;

- (void)showInViewController:(UIViewController*)vc;
- (void)sendMailWithBody:(NSString *)body;
- (void)mailCancelled;
- (void)mailSuccess;
- (void)launchMailAppOnDevice;

@end
