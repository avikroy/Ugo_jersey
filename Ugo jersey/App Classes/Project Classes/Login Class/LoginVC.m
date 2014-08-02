//
//  LoginVC.m
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "LoginVC.h"
#import "EventListVC.h"
#import "BlockAlertView.h"
#import "JSON.h"
#import "SBJSON.h"
#import "DBManager.h"
#import "Ticket.h"
#import "NSNull+CheckNull.h"
#import "AppDelegate.h"
#import "TicketListing+AdminViewController.h"

static NSString* kAppId = @"653877478005665";
@interface LoginVC ()
{
    ConnectionModel *conModel;
     AppDelegate *appDelegate;
}
@end
@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone) nibNameOrNil = @"LoginVC_iPhone";
    
    else if (family == iPhone5) nibNameOrNil = @"LoginVC";
    else nibNameOrNil = @"LoginVC_iPad";
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self createHUD];
    
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone || family == iPhone5)
    {
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"inner-bg-small.png"] ];
    }
    else if (family == iPad)
    {
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"inner-small.png"] ];
    }
    UIView *padingUserID=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.UserIDTxtFd.leftView=padingUserID;
    self.UserIDTxtFd.leftViewMode=UITextFieldViewModeAlways;
    [padingUserID release];
    
    UIView *padingPwd=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.PwdTxtFd.leftView=padingPwd;
    self.PwdTxtFd.leftViewMode=UITextFieldViewModeAlways;
    [padingPwd release];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self createNavigationView];
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
    
    UILabel *lblHeading=[[UILabel alloc] initWithFrame:CGRectMake(60, 6, 160,32)];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.text=@"UGOjersey Door Entry App";
    lblHeading.textColor=[UIColor whiteColor];
    lblHeading.font=[UIFont boldSystemFontOfSize:20];
    [lblHeading setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=lblHeading;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIButton Selector
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitAction:(id)sender
{
    if (isNetworkAvailable())
    {
        if((![self.UserIDTxtFd.text isEqualToString:@""])&&(![self.PwdTxtFd.text isEqualToString:@""]))
        {
            if((![self.UserIDTxtFd.text isEqualToString:@" "])&&(![self.PwdTxtFd.text isEqualToString:@" "]))
            {
                [self createConnectionLogin];
             }
            else
            {
                BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Kindly Fill up all fields with Some Characters"];
                [alert setCancelButtonWithTitle:@"Ok" block:nil];
                [alert show];
            }
        }
        else
        {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Kindly Fill up all fields"];
            [alert setCancelButtonWithTitle:@"Ok" block:nil];
            [alert show];
        }
    }
    else
    {
        NSUserDefaults *defaults=User_Defaults;
    
        if([[defaults objectForKey:@"UserID" ] isEqualToString:self.UserIDTxtFd.text] && [[defaults objectForKey:@"Passwd" ] isEqualToString:self.PwdTxtFd.text])
        {
            EventListVC *eventlist = [[EventListVC alloc] init];
            [self.navigationController pushViewController:eventlist animated:YES];
            [eventlist release];
        }
        else
        {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Invalid Login ID or Password"];
        [alert setCancelButtonWithTitle:@"Ok" block:nil];
        [alert show];
        }
    }
}
-(void)createConnectionLogin
{
    conModel=[[ConnectionModel alloc] init];
    conModel.delegate=self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"login" forKey:@"action"];
    [dict setObject:self.UserIDTxtFd.text forKey:@"user_id"];
    [dict setObject:self.PwdTxtFd.text forKey:@"password"];
    NSLog(@"%@",dict);
[conModel startResquestForLogin:dict];

    [self showHUD];

}
#pragma mark -Connection Delegate
-(void)connectionDidReceiveResponse:(ASIHTTPRequest*)response
{
    [self hideHUD];
    if ([response.username isEqualToString:@"login"])
    {
        NSLog(@"%@",[response responseString]);
        //baitalik.sub@gmail.com&password=option123
        id finalArr = [[response responseString]  JSONValue];
        NSLog(@"Dict value:%@",finalArr);
        
        if([finalArr isKindOfClass:[NSArray class]]){
            if([[finalArr objectAtIndex:0] integerValue]==3){
            
                NSLog(@"===%@",[finalArr objectAtIndex:2]);

                NSUserDefaults *defaults=User_Defaults;
                [defaults setObject:self.UserIDTxtFd.text forKey:@"UserID"];
                [defaults setObject:self.PwdTxtFd.text forKey:@"Passwd"];
                 [defaults setBool:NO forKey:@"isFBLogin"];
                [defaults synchronize];

                NSMutableArray  *arrTicket=[[NSMutableArray alloc] init];
                
                if([[finalArr objectAtIndex:1] count]==0)
                {
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"No tickets available for this user"];
                    [alert setCancelButtonWithTitle:@"Ok" block:nil];
                    [alert show];
                }
                
                if([[User_Defaults stringForKey:@"PreviousUserID"] isEqualToString:[finalArr objectAtIndex:2]])
                {
                    
                }
                else{
                    [DBManager dropTableQuery:@"AdminTicket"];
                    [DBManager createAdminTicketTableQuery];

                for(int count=0;count<[[finalArr objectAtIndex:1] count];count++){
                    Ticket *aTicket=[[Ticket alloc] initWithDictionary:[[finalArr objectAtIndex:1] objectAtIndex:count]];
                    [arrTicket addObject:aTicket];
                    BOOL ticketSuccess=[DBManager insertToAdminTicket:aTicket.ticket_id forHolder_Nm:aTicket.ticket_holder_name  forHolder_Phn:aTicket.ticket_holder_phone  forBuyer_Nm:aTicket.ticket_buyer_name forBuyer_Email:aTicket.ticket_buyer_email forEventNm:aTicket.ticket_event_name forIssue_Dt:aTicket.ticket_issue_date forAdmit_Stat:aTicket.ticket_admit_status forUnique_ID:aTicket.ticket_unique_id forHolderFirstName:aTicket.ticket_holder_firstname forHolderSurName:aTicket.ticket_holder_surname forHolderInitialName:aTicket.ticket_holder_initial startTime:aTicket.starttime location:aTicket.location endtime:aTicket.endtime description_event:aTicket.description_event date_event:aTicket.date_event];
                    if(ticketSuccess){
                        NSLog(@"Admin ticket inserted Successfull");
                    }
                    
                }
                    [defaults setObject:[finalArr objectAtIndex:2] forKey:@"PreviousUserID"];
                    [defaults synchronize];
                }
                //     TicketListing_AdminViewController *aController=[[[TicketListing_AdminViewController alloc] initWithNibName:@"TicketListing+AdminViewController" bundle:nil] autorelease];
                //                aController.arrTickets=arrTicket;
                //   [self.navigationController pushViewController:aController animated:YES];
                TicketListing_AdminViewController *aController = [[TicketListing_AdminViewController alloc] init];
                [self.navigationController pushViewController:aController animated:YES];
                [aController release];
                
                
            }else{
                [DBManager dropTableQuery:@"Event"];
                [DBManager createEventTableQuery];
                [DBManager dropTableQuery:@"Ticket"];
                [DBManager createTicketTableQuery];
                [DBManager dropTableQuery:@"EventTicketMap"];
                [DBManager createMapTableQuery];
                
                NSString *status=[finalArr objectAtIndex:0];
                if([status intValue]==0)
                {
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Invalid Login ID or Password"];
                    [alert setCancelButtonWithTitle:@"Ok" block:nil];
                    [alert show];
                }
                else if([status intValue]==2)
                {
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"You Are Not an Authorized Partner For Ugo-jersey"];
                    [alert setCancelButtonWithTitle:@"Ok" block:nil];
                    [alert show];
                }
                else if([status intValue]==1)
                {
                    NSUserDefaults *defaults=User_Defaults;
                    [defaults setObject:self.UserIDTxtFd.text forKey:@"UserID"];
                    [defaults setObject:self.PwdTxtFd.text forKey:@"Passwd"];
                     [defaults setBool:NO forKey:@"isFBLogin"];
                    [defaults synchronize];
                    
                    NSArray *eventArr=[finalArr objectAtIndex:1];
                    if([eventArr count]==0)
                    {
                        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"No tickets available for this user"];
                        [alert setCancelButtonWithTitle:@"Ok" block:nil];
                        [alert show];
                    }
                    
                    for(int i=0;i<[eventArr count];i++)
                    {
                        NSDictionary *eventDict=[eventArr objectAtIndex:i];
                        
                        BOOL success=[DBManager insertToEvent:[eventDict objectForKey:@"event_id"] forEventNm:[eventDict objectForKey:@"name"]  forStart_Dt:[eventDict objectForKey:@"event_start_date"] forEnd_Dt:[eventDict objectForKey:@"event_end_date"] forStart_Time:[eventDict objectForKey:@"event_start_time"] forEnd_Time:[eventDict objectForKey:@"event_end_time"]];
                        if(success)
                        {
                            
                            NSArray *arrTickets=(NSArray *)[eventDict objectForKey:@"ticket_data"];
                            for(int count=0;count<[arrTickets count];count++)
                            {
                                if(![[arrTickets objectAtIndex:count] isKindOfClass:[NSNull class]])
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
                    }
                    EventListVC *eventlist = [[EventListVC alloc] init];
                    [self.navigationController pushViewController:eventlist animated:YES];
                    [eventlist release];
                }
            }
        }
        
        
    }
    
    else  if ([response.username isEqualToString:@"fblogin"])
    {
        
        NSLog(@"%@",[response responseString]);
        //baitalik.sub@gmail.com&password=option123
        //smith001985@gmail.com&password=option123
        id finalArr = [[response responseString]  JSONValue];
        NSLog(@"Dict value:%@",finalArr);
        
        if([finalArr isKindOfClass:[NSArray class]]){
            // if([[finalArr objectAtIndex:0] integerValue]==3){
            
            NSLog(@"===%@",[finalArr objectAtIndex:2]);
                      

//            [DBManager dropTableQuery:@"AdminTicket"];
//            [DBManager createAdminTicketTableQuery];
            NSMutableArray  *arrTicket=[[NSMutableArray alloc] init];
            
            
            if([[finalArr objectAtIndex:1] isKindOfClass:[NSNull class]]){
 
                TicketListing_AdminViewController *aController = [[TicketListing_AdminViewController alloc] init];
                [self.navigationController pushViewController:aController animated:YES];
                [aController release];
                
                //BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Invalid Facebook Login ID or Password"];
                BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"No tickets available for this user"];
                [alert setCancelButtonWithTitle:@"Ok" block:nil];
                [alert show];
                
            }
            else{
                if([[finalArr objectAtIndex:1] count]==0)
                {
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"No tickets available for this user"];
                    [alert setCancelButtonWithTitle:@"Ok" block:nil];
                    [alert show];
                }
                
                
                NSUserDefaults *defaults=User_Defaults;
                
                if([[User_Defaults stringForKey:@"PreviousUserID"] isEqualToString:[finalArr objectAtIndex:2]])
                {
                    
                }
                else{
                    [DBManager dropTableQuery:@"AdminTicket"];
                    [DBManager createAdminTicketTableQuery];
                    
                    for(int count=0;count<[[finalArr objectAtIndex:1] count];count++){
                        Ticket *aTicket=[[Ticket alloc] initWithDictionary:[[finalArr objectAtIndex:1] objectAtIndex:count]];
                        [arrTicket addObject:aTicket];
                        BOOL ticketSuccess=[DBManager insertToAdminTicket:aTicket.ticket_id forHolder_Nm:aTicket.ticket_holder_name  forHolder_Phn:aTicket.ticket_holder_phone  forBuyer_Nm:aTicket.ticket_buyer_name forBuyer_Email:aTicket.ticket_buyer_email forEventNm:aTicket.ticket_event_name forIssue_Dt:aTicket.ticket_issue_date forAdmit_Stat:aTicket.ticket_admit_status forUnique_ID:aTicket.ticket_unique_id forHolderFirstName:aTicket.ticket_holder_firstname forHolderSurName:aTicket.ticket_holder_surname forHolderInitialName:aTicket.ticket_holder_initial startTime:aTicket.starttime location:aTicket.location endtime:aTicket.endtime description_event:aTicket.description_event date_event:aTicket.date_event];
                        if(ticketSuccess){
                            NSLog(@"Admin ticket inserted Successfull");
                        }

                }
                [defaults setObject:[finalArr objectAtIndex:2] forKey:@"PreviousUserID"];
                [defaults synchronize];

                               
                }
                TicketListing_AdminViewController *aController = [[TicketListing_AdminViewController alloc] init];
                [self.navigationController pushViewController:aController animated:YES];
                [aController release];

            }
                     
        }
        //     TicketListing_AdminViewController *aController=[[[TicketListing_AdminViewController alloc] initWithNibName:@"TicketListing+AdminViewController" bundle:nil] autorelease];
        //                aController.arrTickets=arrTicket;
        //   [self.navigationController pushViewController:aController animated:YES];
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

#pragma mark -UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag==2)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationCurveEaseInOut
                         animations:^{
                              self.view.frame=CGRectMake(0,-40,self.view.frame.size.width, self.view.frame.size.height);
                         } 
                         completion:^(BOOL finished){
            }];
  
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.tag==2)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationCurveEaseInOut
                         animations:^{
                             self.view.frame=CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
     }
    return YES;
}
- (void)dealloc
{
    [_UserIDTxtFd release];
    [_PwdTxtFd release];
    [super dealloc];
}

#pragma mark - Facebook login Button pressed

-(IBAction)FacebookLoginBtnPressed
{
   // self.view.userInteractionEnabled=NO;
    
    if (isNetworkAvailable())
    {
        FBSessionLoginBehavior behavior = FBSessionLoginBehaviorForcingWebView;
        FBSessionTokenCachingStrategy *tokenCachingStrategy  = [self createCachingStrategy];
        
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"email",@"user_photos",@"publish_stream",
                                nil];
        
        appDelegate._session = [[FBSession alloc] initWithAppID:kAppId
                                                    permissions:permissions
                                                urlSchemeSuffix:nil
                                             tokenCacheStrategy:tokenCachingStrategy];
        
        appDelegate._session =  [FBSession activeSession];
        
        [FBSession setActiveSession: appDelegate._session];
        
        [appDelegate._session openWithBehavior:behavior
                             completionHandler:^(FBSession *session,
                                                 FBSessionState status,
                                                 NSError *error) {
                                 
                                 if (error) {
                                     
                                 }
                                 
                                 [self updateForSessionChange];
                             }];
        
    }
    else
    {
        NSLog(@"problem");
    }
}
- (void)updateForSessionChange {
    
    
    if (appDelegate._session.isOpen) {
        
        FBRequest *me = [[FBRequest alloc] initWithSession:appDelegate._session
                                                 graphPath:@"me"];
        [me startWithCompletionHandler:^(FBRequestConnection *connection,
                                         NSDictionary<FBGraphUser> *result,
                                         NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
            [self showHUD];

            NSString *strProfilepic_url = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[result objectForKey:@"id"]];
            NSString *strName;
            strName=[result objectForKey:@"name"];
            NSString *strEmail=[result objectForKey:@"email"];
            NSString *strGender=[result objectForKey:@"gender"];
            NSLog(@"name:%@ and emal addres:- %@ and the gender is %@ the link is %@",strName,strEmail,strGender,strProfilepic_url);
           
            NSUserDefaults *defaults=User_Defaults;
            [defaults setObject:strEmail forKey:@"UserID"];
            [defaults setObject:strName forKey:@"Passwd"];
            [defaults setBool:YES forKey:@"isFBLogin"];
            [defaults synchronize];

            conModel=[[ConnectionModel alloc] init];
            conModel.delegate=self;
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"fblogin" forKey:@"action"];
            [dict setObject:strEmail forKey:@"user_email"];
            [dict setObject:strName forKey:@"name"];
            NSLog(@"%@",dict);
            [conModel startResquestForFBLogin:dict];
         
          }];
    }
    else {
           if (appDelegate._session.state == FBSessionStateCreatedTokenLoaded) {
            
            [appDelegate._session openWithCompletionHandler:^(FBSession *session,
                                                              FBSessionState status,
                                                              NSError *error) {
                
                [self updateForSessionChange];
            }];
        }
        else if (appDelegate._session.state == FBSessionStateClosedLoginFailed ||appDelegate._session.state == FBSessionStateClosed) {
            
            [appDelegate._session closeAndClearTokenInformation];
            appDelegate._session = nil;
            
        }
        
    }
    
    appDelegate._session = [FBSession activeSession];
    
}

- (FBSessionTokenCachingStrategy*)createCachingStrategy {
    
    FBSessionTokenCachingStrategy *tokenCachingStrategy = [[FBSessionTokenCachingStrategy alloc]
                                                           initWithUserDefaultTokenInformationKeyName:[NSString stringWithFormat:@"FBAccessTokenInformationKey"]];
    return tokenCachingStrategy;
}

@end
