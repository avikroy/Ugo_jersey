//
//  MailObject.m
//  VehicleInspection
//
//  Created by Avik on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MailObject.h"

@implementation MailObject

@synthesize delegate;

- (void) showInViewController:(UIViewController*)vc
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        vController=vc;
		if (mailClass != nil)
		{
            if ([mailClass canSendMail])
			{
				[self sendMailWithBody:self.mailBody];
			}
			else
			{
				[self launchMailAppOnDevice];
			}
		}
		else
		{
			[self launchMailAppOnDevice];
		}
}

#pragma mark -
#pragma mark <Mail send>

-(void)sendMailWithBody:(NSString *)body
{
    mailController = [[MFMailComposeViewController alloc] init];
	[mailController retain];
	mailController.mailComposeDelegate = self;
	mailController.navigationBar.tintColor=[UIColor blackColor];
	[mailController setSubject:@"UGO Jersey Diagonstic Report"];
	[mailController setMessageBody:body isHTML:YES];
	[mailController setToRecipients:[NSArray arrayWithObjects:@"", nil]]; 
	[vController presentViewController:mailController animated:YES completion:nil];
	[mailController release];
}	

-(void)launchMailAppOnDevice
{
	NSString *recipients = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@",@"aasd",@"ggg"];
	NSString *body = [NSString stringWithFormat:@"&body=%@",@"Hello"];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


#pragma mark -
#pragma mark mailController

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			[vController dismissModalViewControllerAnimated:YES];
			[self mailCancelled];
			break;
			
		case MFMailComposeResultSaved:
			[vController dismissModalViewControllerAnimated:YES];
			//[self mailCancelled];
			break;
			
		case MFMailComposeResultSent:
			[vController dismissModalViewControllerAnimated:YES];
			[self mailSuccess];
			break;
			
		case MFMailComposeResultFailed:
			break;
		default:
			break;
	}
	[vController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark <mailCancelled>

- (void)mailCancelled
{
	[delegate mailCancelled];
}	

#pragma mark -
#pragma mark <mailSuccess>

- (void)mailSuccess
{
	[delegate mailSuccess];
}	

@end
