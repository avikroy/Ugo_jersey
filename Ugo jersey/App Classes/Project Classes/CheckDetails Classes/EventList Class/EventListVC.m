//
//  EventListVC.m
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "EventListVC.h"
#import "TicketEntryVC.h"
#import "EventListTableVwCell.h"
#import "TicketListVC.h"
#import "DBManager.h"
@interface EventListVC ()

@end

@implementation EventListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone) nibNameOrNil = @"EventListVC_iPhone";
    
    else if (family == iPhone5) nibNameOrNil = @"EventListVC";
    else nibNameOrNil = @"EventListVC_iPad";
    
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
    self.eventCount=[DBManager getRowCountForTable:@"Event"];
    self.event_Nm_Arr=[DBManager getEvent_Nm_Arr];
    self.event_Dt_Arr=[DBManager getEvent_Date_Arr];
    self.event_ID_Arr=[DBManager getEvent_ID_Arr];
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
    UILabel *lblHeading=[[UILabel alloc] initWithFrame:CGRectMake(60, 6, 160,32)];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.text=@"UGOjersey Door Entry App";
    lblHeading.textColor=[UIColor whiteColor];
    lblHeading.font=[UIFont boldSystemFontOfSize:20];
    [lblHeading setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=lblHeading;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
[cell setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventListTableVwCell *cell=nil;
    NSArray *nib=nil;
    
    Devicefamily family = thisDeviceFamily();
    if (family == iPad)
        nib=[[ NSBundle  mainBundle]loadNibNamed:@"EventListTableVwCell_iPad" owner:self options:nil];
    else 
        nib=[[ NSBundle  mainBundle]loadNibNamed:@"EventListTableVwCell" owner:self options:nil];

    cell=(EventListTableVwCell*)[nib objectAtIndex:0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    cell.EventNameLbl.text=[self.event_Nm_Arr objectAtIndex:indexPath.row];
    cell.EventDateLbl.text=[self.event_Dt_Arr objectAtIndex:indexPath.row];

	/*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];*/
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    NSString *strLatestEvent=[[[[[[self.event_Nm_Arr objectAtIndex:indexPath.row] stringByAppendingString:@"#"] stringByAppendingString:[self.event_Dt_Arr objectAtIndex:indexPath.row]] stringByAppendingString:@"#"]
        stringByAppendingString:[self.event_ID_Arr objectAtIndex:indexPath.row]] stringByAppendingString:@"#"];
    [userdefault setObject:strLatestEvent forKey:@"strLatestEvent"];
    
    TicketListVC  *ticketList=[[TicketListVC alloc]init];
    ticketList.event_Nm_Str=[self.event_Nm_Arr objectAtIndex:indexPath.row];
    ticketList.event_Dt_Str=[self.event_Dt_Arr objectAtIndex:indexPath.row];
    ticketList.event_ID_Str=[self.event_ID_Arr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ticketList animated:YES];
    [ticketList release];
}

#pragma mark - UIButton Selector
-(void)back
{
   // [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIBottom Tabbar Buttons Selector
- (IBAction)validate:(id)sender
{
    TicketEntryVC *ticketentry = [[TicketEntryVC alloc] init];
    [self.navigationController pushViewController:ticketentry animated:YES];
    [ticketentry release];
}

- (IBAction)check:(id)sender
{
}

- (void)dealloc
{
    [_EventListTblVw release];
    [super dealloc];
}
@end
