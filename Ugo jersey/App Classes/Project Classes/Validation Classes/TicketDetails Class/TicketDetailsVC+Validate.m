//
//  TicketDetailsVC+Validate.m
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "TicketDetailsVC+Validate.h"
#import "EventListVC.h"
#import "AdmitStatusVC.h"
#import "BlockAlertView.h"
#import "JSON.h"
#import "SBJSON.h"
#import "Global.h"
#import "DBManager.h"

@interface TicketDetailsVC_Validate ()
{
    ConnectionModel *conModel;
}
@end

@implementation TicketDetailsVC_Validate

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone) nibNameOrNil = @"TicketDetailsVC_iPhone+Validate";
    
    else if (family == iPhone5) nibNameOrNil = @"TicketDetailsVC+Validate";
    else nibNameOrNil = @"TicketDetailsVC_iPad+Validate";
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createHUD];
    
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone || family == iPhone5)
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"inner-bg-small.png"] ];
        self.TicketDetailsScroll.contentSize=CGSizeMake(300.0,560.0);
    }
    else if (family == iPad)
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"inner-small.png"] ];
        self.TicketDetailsScroll.contentSize=CGSizeMake(728.0,800.0);
    }

    self.TicketIDVal_Lbl.text=self.ticket.ticket_unique_id;
    self.IssueDtVal_Lbl.text=self.ticket.ticket_issue_date;
    self.NameVal_Lbl.text=self.ticket.ticket_holder_name;
    self.PhnNoVal_Lbl.text=self.ticket.ticket_holder_phone;
    self.StatVal_Lbl.text=[self admitStatusForTicket:[self.ticket.ticket_admit_status intValue]];
    self.EventNmVal_Lbl.text=self.ticket.ticket_event_name;
    self.EventStartDtVal_Lbl.text=self.ticket.ticket_issue_date;
    
    self.event=(Event *)[DBManager getEventsForTicket:self.ticket.ticket_id];
    
    self.EventStartDtVal_Lbl.text=self.event.event_start_date;
    self.EventEndDtVal_Lbl.text=self.event.event_end_date;
    self.EventStartTimeVal_Lbl.text=self.event.event_start_time;
    self.EventEndTimeVal_Lbl.text=self.event.event_end_time;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self createNavigationView];
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
- (IBAction)allowEntryAction:(id)sender
{
    if (isNetworkAvailable())
    {
        [self createConnectionUpdateStatusofTicket];
    }
    else
    {
        [[Global sharedInstance].allowedTicketArr addObject:self.ticket.ticket_id];
      
        /* BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:ConnectionUnavailable];
        [alert setCancelButtonWithTitle:@"Ok" block:nil];
        [alert show];*/
        
        self.ticket.ticket_admit_status=@"1";
        [DBManager updateTicketToAdmitted:self.ticket.ticket_unique_id];
        
        self.StatVal_Lbl.text=[self admitStatusForTicket:[self.ticket.ticket_admit_status intValue]];
        
        AdmitStatusVC *adminStat = [[AdmitStatusVC alloc] init];
        adminStat.strStatus=@"allow";
        adminStat.navStatus=@"validate";
        [self.navigationController pushViewController:adminStat animated:YES];
        [adminStat release];
    }
}
- (IBAction)declineEntryAction:(id)sender
{
    AdmitStatusVC *adminStat = [[AdmitStatusVC alloc] init];
    adminStat.strStatus=@"decline";
    adminStat.navStatus=@"validate";
    [self.navigationController pushViewController:adminStat animated:YES];
    [adminStat release];
}

#pragma mark - UIBottom Tabbar Buttons Selector
- (IBAction)validate:(id)sender
{
}
- (IBAction)check:(id)sender
{
    EventListVC *eventlist = [[EventListVC alloc] init];
    [self.navigationController pushViewController:eventlist animated:YES];
    [eventlist release];
}

-(void)createConnectionUpdateStatusofTicket
{
    conModel=[[ConnectionModel alloc] init];
    conModel.delegate=self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"update_status" forKey:@"action"];
    [dict setObject:self.ticket.ticket_id forKey:@"ticket_id"];
    NSLog(@"%@",dict);
    [conModel startResquestForupdateTicketStatus:dict];
    
    [self showHUD];
}

#pragma mark -Connection Delegate
-(void)connectionDidReceiveResponse:(ASIHTTPRequest*)response
{
    [self hideHUD];
    if ([response.username isEqualToString:@"updateTicketStatus"])
    {
        NSLog(@"%@",[response responseString]);
        id finalDict = [[response responseString]  JSONValue];
        NSLog(@"Dict value:%@",finalDict);
        if ([[finalDict objectForKey:@"web_request_succsess_status"] isEqualToString:@"1"])
        {
            self.ticket.ticket_admit_status=@"1";
            [DBManager updateTicketToAdmitted:self.ticket.ticket_unique_id];
            
            self.StatVal_Lbl.text=[self admitStatusForTicket:[self.ticket.ticket_admit_status intValue]];
            
            AdmitStatusVC *adminStat = [[AdmitStatusVC alloc] init];
            adminStat.strStatus=@"allow";
            adminStat.navStatus=@"validate";
            [self.navigationController pushViewController:adminStat animated:YES];
            [adminStat release];
        }
        else
        {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:ConnectionSlow];
        [alert setCancelButtonWithTitle:@"Ok" block:nil];
        [alert show];
        }
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

- (void)dealloc
{
    [_TicketDetailsScroll release];
    [_TicketIDVal_Lbl release];
    [_IssueDtVal_Lbl release];
    [_NameVal_Lbl release];
    [_PhnNoVal_Lbl release];
    [_StatVal_Lbl release];
    [_EventNmVal_Lbl release];
  
    [super dealloc];
}
@end
