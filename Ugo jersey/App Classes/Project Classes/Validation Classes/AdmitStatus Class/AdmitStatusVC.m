//
//  AdmitStatusVC.m
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "AdmitStatusVC.h"
#import "EventListVC.h"
#import "TicketEntryVC.h"
#import "TicketListVC.h"
@interface AdmitStatusVC ()

@end

@implementation AdmitStatusVC
@synthesize strStatus,navStatus;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone) nibNameOrNil = @"AdmitStatusVC_iPhone";
    
    else if (family == iPhone5) nibNameOrNil = @"AdmitStatusVC";
    else nibNameOrNil = @"AdmitStatusVC_iPad";
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone || family == iPhone5)
    {
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"inner-bg-small.png"] ];
    }
    else if (family == iPad)
    {
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"inner-small.png"] ];
    }

   if([self.strStatus isEqualToString:@"allow"])
    {
    self.AdmitStatusImgVw.image=[UIImage imageNamed:@"allowed.png"];
    self.AdmitStatusLbl.text=@"Allowed Entry.";
    }
    else if([self.strStatus isEqualToString:@"decline"])
    {
    self.AdmitStatusImgVw.image=[UIImage imageNamed:@"decline.png"];
   self.AdmitStatusLbl.text=@"Declined Entry.";
    }
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

- (IBAction)scanOtherCustAction:(id)sender
{
    if([self.navStatus isEqualToString:@"check"])
    {
       NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
        NSArray *arrLatestEvent=[[userdefault objectForKey:@"strLatestEvent"]componentsSeparatedByString:@"#"];
         NSLog(@"-----%@",arrLatestEvent);
        TicketListVC  *ticketList=[[TicketListVC alloc]init];
        ticketList.event_Nm_Str=[arrLatestEvent objectAtIndex:0];
        ticketList.event_Dt_Str=[arrLatestEvent objectAtIndex:1];
        ticketList.event_ID_Str=[arrLatestEvent objectAtIndex:2];
        [self.navigationController pushViewController:ticketList animated:YES];
        [ticketList release];
    }
    else if([self.navStatus isEqualToString:@"validate"])
    {
        TicketEntryVC *ticketentry = [[TicketEntryVC alloc] init];
        [self.navigationController pushViewController:ticketentry animated:YES];
        [ticketentry release];
    }
}

- (void)dealloc
{
    [_AdmitStatusImgVw release];
    [_AdmitStatusLbl release];
    [super dealloc];
}
@end
