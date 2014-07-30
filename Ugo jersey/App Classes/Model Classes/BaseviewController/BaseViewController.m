//
//  BaseViewController.m
//  Write Right
//
//  Created by F9 Mac 2 on 25/06/13.
//  Copyright (c) 2013 Sourish Ghosh. All rights reserved.
//

#import "BaseViewController.h"
#import "AdmitStatusVC.h"
#import "PreAdmittedVC.h"
#import "TicketDetailsVC+Validate.h"
#import "TicketEntryVC.h"
#import "EventListVC.h"
#import "TicketDetailsVC+Check.h"
#import "TicketListVC.h"
#import "LoginVC.h"
#import "BlockAlertView.h"
#import "JSON.h"
#import "SBJSON.h"
#import "AppDelegate.h"
@interface BaseViewController ()
{
    ConnectionModel *conModel;
}

@end

@implementation BaseViewController
@synthesize HUD;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void) viewWillAppear:(BOOL)animated
{
    [self.presentingViewController beginAppearanceTransition:YES animated: animated];
}
-(void) viewDidAppear:(BOOL)animated
{
    [self.presentingViewController endAppearanceTransition];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [self.presentingViewController beginAppearanceTransition: NO animated: animated];
}
-(void) viewDidDisappear:(BOOL)animated
{
    [self.presentingViewController endAppearanceTransition];
}

#pragma mark - Create HUD
-(void)createHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    //HUD.detailsLabelText = @"Please wait...";
    HUD.square = YES;
}
-(void)showHUD
{
     [self.HUD show:YES];
}
-(void)hideHUD
{
    [self.HUD hide:YES];
}

#pragma mark - Create NavigationView
-(void)createNavigationView
{
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    
    /*UIImage *imgLogo = [UIImage imageNamed: @"applogo.png"];
     UIImageView *LogoImgvw = [[UIImageView alloc] initWithImage: imgLogo];
     LogoImgvw.frame=CGRectMake(0,0,150,30);
     self.navigationItem.titleView = LogoImgvw;*/
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0,0,32,17);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back_img.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btnBack] autorelease];
    
    UILabel *lblHeading=[[UILabel alloc] initWithFrame:CGRectMake(60, 6, 160,32)];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.text=@"UGOjersey Door Entry App";
    lblHeading.textColor=[UIColor whiteColor];
    lblHeading.font=[UIFont boldSystemFontOfSize:20];
    [lblHeading setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=lblHeading;
    
    /* UIButton *btnLogOut=[UIButton buttonWithType:UIButtonTypeCustom];
     [btnLogOut setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
     [btnLogOut setFrame:CGRectMake(0, 3, 76, 37)];
     [btnLogOut addTarget:self action:@selector(LogOutAction) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btnLogOut] autorelease];*/
    
    UIToolbar *toolsBar = [[UIToolbar alloc]
                           initWithFrame:CGRectMake(0.0f, 0.0f, 90.0f, 44.01f)];
    toolsBar.clearsContextBeforeDrawing = NO;
    toolsBar.clipsToBounds = NO;
    toolsBar.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f];
    toolsBar.barStyle = -1; // clear background
    
    NSMutableArray *buttonsArr = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIButton *btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRefresh.frame = CGRectMake(0,0,30,30);
    [btnRefresh setBackgroundImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [btnRefresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* barBtnItemLeft=[[UIBarButtonItem alloc] initWithCustomView:btnRefresh];
    [buttonsArr addObject:barBtnItemLeft];
    [barBtnItemLeft release];
    
    // Create a spacer
    UIBarButtonItem *barBtnItemMid = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barBtnItemMid.width = 5.0f;
    [buttonsArr addObject:barBtnItemMid];
    [barBtnItemMid release];
    
    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogout.frame = CGRectMake(30,0,30,30);
    [btnLogout setBackgroundImage:[UIImage imageNamed:@"logout_img.png"] forState:UIControlStateNormal];
    [btnLogout addTarget:self action:@selector(LogOutAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* barBtnItemRight=[[UIBarButtonItem alloc] initWithCustomView:btnLogout];
    [buttonsArr addObject:barBtnItemRight];
    [barBtnItemRight release];
    
    // Add buttons to toolbar and toolbar to nav bar 
    [toolsBar setItems:buttonsArr animated:NO];
    [buttonsArr release];
    UIBarButtonItem *twoRightBtns = [[UIBarButtonItem alloc] initWithCustomView:toolsBar];
    [toolsBar release];
    self.navigationItem.rightBarButtonItem = twoRightBtns;
    [twoRightBtns release];
}
-(void)LogOutAction
{
    isLogout=YES;
   [self callSynchConnection];
}

-(void)refreshAction
{
    isLogout=NO;
  [self callSynchConnection]; 
}

-(void)callSynchConnection
{
    NSUserDefaults *defaults=User_Defaults;
    
    if (isNetworkAvailable())
    {
        conModel=[[ConnectionModel alloc] init];
        conModel.delegate=self;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"logout" forKey:@"action"];
        if([defaults objectForKey:@"UserID"] && [defaults objectForKey:@"Passwd"])
        {
        [dict setObject:[defaults objectForKey:@"UserID"] forKey:@"user_id"];
        [dict setObject:[defaults objectForKey:@"Passwd"] forKey:@"password"];
        }
        else
        {
            [dict setObject:@"1" forKey:@"user_id"];
            [dict setObject:@"option123" forKey:@"password"];
         }
        NSLog(@"%@",dict);
 
        id ticketJsonArr= [[Global sharedInstance].allowedTicketArr JSONRepresentation];
        [conModel startResquestForLogout:dict:ticketJsonArr];
        
        [self showHUD];
    }
    else
    {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:ConnectionUnavailable];
        [alert setCancelButtonWithTitle:@"Ok" block:nil];
        [alert show];
    }
}

#pragma mark -Connection Delegate
-(void)connectionDidReceiveResponse:(ASIHTTPRequest*)response
{
    [self hideHUD];
    NSUserDefaults *defaults=User_Defaults;
        if ([response.username isEqualToString:@"logout"])
        {
            if ( [defaults boolForKey:@"isFBLogin"])
            {
                if(isLogout)
                {

//                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//                [appDelegate._session closeAndClearTokenInformation];
//                appDelegate._session = nil;
                [FBSession.activeSession closeAndClearTokenInformation];
                [FBSession.activeSession close];
                [FBSession setActiveSession:nil];

                NSHTTPCookie *cookie;
                NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                NSLog(@"COOKIES: %@",storage);
                for (cookie in [storage cookies])
                {
                    NSString* domainName = [cookie domain];
                    NSRange domainRange = [domainName rangeOfString:@"facebook"];
                    if(domainRange.length > 0)
                    {
                        [storage deleteCookie:cookie];
                    }
                }

                LoginVC *login = [[LoginVC alloc] init];
                [self.navigationController pushViewController:login animated:NO];
                [login release];
                }
            }
            else
            {
        NSLog(@"%@",[response responseString]);
        id finalArr = [[response responseString]  JSONValue];
        NSLog(@"Dict value:%@",finalArr);
            
        NSString *status=[finalArr objectAtIndex:0];
        if([status intValue]==0)
        {
            if(isLogout)
            {
                BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Logout was failed."];
                [alert setCancelButtonWithTitle:@"Ok" block:nil];
                [alert show];
            }
            else
            {
                BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Synchronization failed.Please try again later."];
                [alert setCancelButtonWithTitle:@"Ok" block:nil];
                [alert show];
            }
        }
        else if([status intValue]==2)
        {
            if(isLogout)
            {
                LoginVC *login = [[LoginVC alloc] init];
                [self.navigationController pushViewController:login animated:NO];
                [login release];
            }
            else
            {
                BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"There is no data for synchronization at the moment"];
                [alert setCancelButtonWithTitle:@"Ok" block:nil];
                [alert show];
            }
        }
        else if([status intValue]==1)
        {
        NSArray *eventArr=[finalArr objectAtIndex:1];
        for(int i=0;i<[eventArr count];i++)
        {
            NSDictionary *eventDict=[eventArr objectAtIndex:i];
            
            BOOL success=[DBManager insertToEvent:[eventDict objectForKey:@"event_id"] forEventNm:[eventDict objectForKey:@"name"]  forStart_Dt:[eventDict objectForKey:@"event_start_date"] forEnd_Dt:[eventDict objectForKey:@"event_end_date"] forStart_Time:[eventDict objectForKey:@"event_start_time"] forEnd_Time:[eventDict objectForKey:@"event_end_time"]];
            if(success)
            {
                NSArray *arrTickets=(NSArray *)[eventDict objectForKey:@"ticket_data"];
                for(int count=0;count<[arrTickets count];count++)
                {
                    Ticket *aTicket=[[Ticket alloc] initWithDictionary:[arrTickets objectAtIndex:count]];
                   BOOL ticketSuccess=[DBManager insertToTicket:aTicket.ticket_id forHolder_Nm:aTicket.ticket_holder_name  forHolder_Phn:aTicket.ticket_holder_phone  forBuyer_Nm:aTicket.ticket_buyer_name forBuyer_Email:aTicket.ticket_buyer_email forEventNm:aTicket.ticket_event_name forIssue_Dt:aTicket.ticket_issue_date forAdmit_Stat:aTicket.ticket_admit_status forUnique_ID:aTicket.ticket_unique_id forHolderFirstName:aTicket.ticket_holder_firstname forHolderSurName:aTicket.ticket_holder_surname forHolderInitialName:aTicket.ticket_holder_initial];
                    if(ticketSuccess)
                    {
                        BOOL mapSuccess=[DBManager insertMapEvent:[eventDict objectForKey:@"event_id"] ticket:aTicket.ticket_id];
                        if(mapSuccess)
                        {
                        #ifdef DEBUG
                            NSLog(@"Map Successfull");
                        #endif
                        }
                    }
                }
            }
        }
        
        if(isLogout)
        {
            LoginVC *login = [[LoginVC alloc] init];
            [self.navigationController pushViewController:login animated:NO];
            [login release];
        }
        else
        {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Synchronization was successfully completed"];
            [alert setCancelButtonWithTitle:@"Ok" block:nil];
            [alert show];
        }
     }
    }
   }
    else
    {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:ConnectionSlow];
        [alert setCancelButtonWithTitle:@"Ok" block:nil];
        [alert show];
    }
}
-(void)connectionDidFailedResponse:(ASIHTTPRequest*)response
{
    [self hideHUD];
    NSError *error = [response error];
    NSLog(@"REQUEST_ERROR:%@",[error localizedDescription]);
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:ConnectionUnavailable];
    [alert setCancelButtonWithTitle:@"Ok" block:nil];
    [alert show];
}

-(NSString*)admitStatusForTicket:(AdmitStatusList)admitStatus
{
    switch (admitStatus)
    {
        case Admitted:
            return @"Admitted";
            
        case NotAdmitted:
            return  @"Not Admitted";             
        
        default:
            break;
    }
    return @"";
}

#pragma mark - Check network rechability
 BOOL isNetworkAvailable ()
{
    BOOL isInternet=NO;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
       isInternet=NO;
    else
       isInternet=YES;
    
    return isInternet;
}
#pragma mark - Check iPhone ScreenSize
BOOL iphoneTallScreen ()
{
    BOOL isChecked= NO;
    
    if ([UIScreen mainScreen].scale == 2.0f)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        if(result.height == 1136)
        {
            isChecked=YES;
        }
    }
    return isChecked;
}
#pragma mark - Check Device types
Devicefamily thisDeviceFamily()
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (iphoneTallScreen()) return iPhone5;
        else return iPhone;
    }
    else return iPad;
}

@end
