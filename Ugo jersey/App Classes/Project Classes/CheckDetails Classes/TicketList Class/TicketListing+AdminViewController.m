//
//  TicketListing+AdminViewController.m
//  Ugo jersey
//
//  Created by Avik Roy on 2/1/14.
//  Copyright (c) 2014 Debasish Pal. All rights reserved.
//

#import "TicketListing+AdminViewController.h"
#import "TicketDetails+AdminViewController.h"
#import "EventListTableVwCell.h"
#import "Ticket.h"
#import "DBManager.h"
#import "SaveTicketListViewController.h"

@interface TicketListing_AdminViewController ()

@end

@implementation TicketListing_AdminViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone) nibNameOrNil = @"TicketListing+AdminViewController";
    
    else if (family == iPhone5) nibNameOrNil = @"TicketListing+AdminViewController";
    else nibNameOrNil = @"TicketList+AdminVC_iPad";
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrTickets=[DBManager getAdminTickets];
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone || family == iPhone5)
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"inner-bg-small.png"] ];
    }
    else if (family == iPad)
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"inner-small.png"] ];
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
    // Dispose of any resources that can be recreated.
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
    return [self.arrTickets count];
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
    
    cell.EventNameLbl.text=[(Ticket *)[self.arrTickets objectAtIndex:indexPath.row] ticket_holder_name];
    cell.EventDateLbl.text=[(Ticket *)[self.arrTickets objectAtIndex:indexPath.row] ticket_issue_date];
    
	/*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];*/
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* TicketDetails_AdminViewController *aController=[[[TicketDetails_AdminViewController alloc] initWithNibName:@"TicketDetails+AdminViewController" bundle:nil] autorelease];
    aController.ticket=(Ticket *)[self.arrTickets objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:aController animated:YES];*/
   
    TicketDetails_AdminViewController *aController = [[TicketDetails_AdminViewController alloc] init];
     aController.ticket=(Ticket *)[self.arrTickets objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:aController animated:YES];
    [aController release];
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
    lblHeading.text=@"UGOjersey";
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


- (IBAction)showsaveticket:(id)sender {
       SaveTicketListViewController *aController = [[SaveTicketListViewController alloc] init];
    [self.navigationController pushViewController:aController animated:YES];
    [aController release];

}
@end
