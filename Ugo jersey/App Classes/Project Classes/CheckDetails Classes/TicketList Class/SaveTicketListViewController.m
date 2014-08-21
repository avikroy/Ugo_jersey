//
//  SaveTicketListViewController.m
//  Ugo jersey
//
//  Created by Avik Roy on 2/10/14.
//  Copyright (c) 2014 Debasish Pal. All rights reserved.
//
#import "TicketListing+AdminViewController.h"
#import "SaveTicketListViewController.h"
#import "TicketDetails+AdminViewController.h"
#import "EventListTableVwCell.h"
#import "Ticket.h"
#import "DBManager.h"
#import "ShowPDFViewController.h"
#import "AppToolBox.h"
#import "PDFCreater.h"

#define kDefaultPageHeight 792
#define kDefaultPageWidth  612
#define kMargin 50
#define kColumnMargin 10
@interface SaveTicketListViewController ()

@end

@implementation SaveTicketListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        Devicefamily family = thisDeviceFamily();
        if (family == iPhone) nibNameOrNil = @"SaveTicketListViewController";
        
        else if (family == iPhone5) nibNameOrNil = @"SaveTicketListViewController";
        else nibNameOrNil = @"SaveTicketListVC_iPad";
        
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        if (self) {
            
        }
        return self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self createHUD];
    self.arrTickets=[DBManager ShowSavedTicketList];
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

- (void)dealloc {
    [_tableticket release];
    [super dealloc];
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
    selectedTicket=(Ticket *)[self.arrTickets objectAtIndex:indexPath.row];
    [self downloadAction:nil];
    
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

#pragma mark - action selector

- (IBAction)ShowTicketFromSave:(id)sender {
    
    TicketListing_AdminViewController *aController = [[TicketListing_AdminViewController alloc] init];
    [self.navigationController pushViewController:aController animated:YES];
    [aController release];
}


- (void)downloadAction:(id)sender {
//    cIndicator=[[CustomActivityIndicator alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
//    [self.view addSubview:cIndicator];  //  [self createHUD];
    [self showHUD];
    [self performSelector:@selector(completed) withObject:nil afterDelay:2.0];
    
}

- (void)showSavedTicketAction:(id)sender {
    SaveTicketListViewController *aController=[[[SaveTicketListViewController alloc] initWithNibName:@"SaveTicketListViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:aController animated:YES];
}

- (void)actionPDFCreated{
   // [cIndicator stopLoading];
    [self hideHUD];
    ShowPDFViewController *aController=[[[ShowPDFViewController alloc] initWithNibName:@"ShowPDFViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:aController animated:YES];
}

#pragma mark - custom methodes

- (void) completed
{
    NSString *pdfFilePath=[AppToolBox getDoccumentPath:[NSString stringWithFormat:@"%@.pdf",@"ticket"]];
    CGFloat currentPageY = kMargin;
    CGFloat currentX=kMargin;
    CGFloat maxWidth = kDefaultPageWidth - kMargin * 2;
    
    UIGraphicsBeginPDFContextToFile(pdfFilePath, CGRectZero, nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    currentX=kMargin;
    
    [CreatePDF drawImage:[UIImage imageNamed:@"my-ticket5a copy.jpg"] atRect:CGRectMake(2, 2, kDefaultPageWidth-4, kDefaultPageHeight-4) inContext:currentContext];
    currentPageY+=30;
    
    [CreatePDF drawImage:[UIImage imageWithData:[DBManager getQRCodeDateForTicket:selectedTicket.ticket_unique_id]] atRect:CGRectMake(450, 30,120 , 115) inContext:currentContext];
    [CreatePDF drawImage:[UIImage imageWithData:[DBManager getQRCodeDateForTicket:selectedTicket.ticket_unique_id]] atRect:CGRectMake(400, 330,180 , 180) inContext:currentContext];
    
    [CreatePDF drawString:selectedTicket.ticket_event_name atRect:CGRectMake(currentX, currentPageY, 300.0, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:25] alignment:NSTextAlignmentLeft];
    currentPageY+=40;
    
    [CreatePDF drawString:selectedTicket.ticket_holder_name atRect:CGRectMake(currentX, currentPageY, 300.0, 25.0) withColor:[UIColor colorWithRed:237/255.0 green:122/255.0 blue:53/255.0 alpha:1.0] font:[UIFont systemFontOfSize:20] alignment:NSTextAlignmentLeft];
    
    currentPageY+=70;
    currentPageY+=0;
    currentX=kMargin;
    currentX+=30;
    
    [CreatePDF drawString:selectedTicket.ticket_unique_id atRect:CGRectMake(currentX, currentPageY, 100, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15]alignment:NSTextAlignmentCenter];
    currentX+=170;
    
    [CreatePDF drawString:selectedTicket.ticket_issue_date atRect:CGRectMake(currentX, currentPageY, 110, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15]alignment:NSTextAlignmentCenter];
    currentX+=120;
    
    [CreatePDF drawString:selectedTicket.ticket_holder_phone atRect:CGRectMake(currentX, currentPageY, 220, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15]alignment:NSTextAlignmentCenter];
    currentPageY+=50;
    
    currentX=kMargin;
    
    currentPageY+=45;
    
    currentX=kMargin+10;
    
    currentX+=45;
    
    currentX+=170;
    currentPageY+=3;
    
    CGFloat temp_x=currentX;
    CGFloat temp_y=currentPageY;
   
    currentX+=55;
    
    [CreatePDF drawString:selectedTicket.starttime atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];
    
    currentPageY+=13;
    
    currentX=temp_x;
    currentX+=45;
    
    [CreatePDF drawString:selectedTicket.endtime atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];
    
    currentPageY+=13;
    
    currentX=temp_x;
    currentX+=30;
    
    [CreatePDF drawString:selectedTicket.ticket_holder_phone atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];
    
    currentPageY+=14;
   
    currentX=temp_x;
    currentX+=50;
    
    [CreatePDF drawString:selectedTicket.location atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];
    
    temp_x+=170;
    currentX=temp_x;
    currentPageY=temp_y;
    
    currentX+=25;
    
    [CreatePDF drawString:selectedTicket.ticket_holder_name atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];
    
    currentPageY+=13;
   
    currentX=temp_x;
    currentX+=45;
    
    [CreatePDF drawString:selectedTicket.ticket_unique_id atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];
    currentPageY+=14;
    
    currentX=temp_x;
    currentX+=20;
    
    [CreatePDF drawString:selectedTicket.date_event atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];
    
    currentX=kMargin;
    currentPageY+=53;
    
    NSString* stripped_description_event = [selectedTicket.description_event kv_encodeHTMLCharacterEntities];
    CGFloat height=[AppToolBox heightForText:stripped_description_event withFont:[UIFont systemFontOfSize:13] LineBreakMode:NSTextAlignmentLeft maxSize:CGSizeMake(300, 2000)];
    [CreatePDF drawString:stripped_description_event atRect:CGRectMake(currentX, currentPageY, 300, height) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] alignment:NSTextAlignmentLeft];
    
    currentX=kMargin;
    currentPageY+=335;
    
    
    NSArray *arr = [NSArray arrayWithObjects:@"2",@"1", @"2",@"1",@"2",@"1",@"2",@"1",nil];
    int lowerBound = 1;
    int upperBound = [arr count];
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    

    
    [CreatePDF drawImage:[UIImage imageNamed:[NSString stringWithFormat:@"banner_%@.png",[arr objectAtIndex:rndValue]]]  atRect:CGRectMake(currentX, currentPageY, maxWidth-4, 50) inContext:currentContext];

   // [CreatePDF drawImage:[UIImage imageNamed:@"banner.jpg"] atRect:CGRectMake(currentX, currentPageY, maxWidth-4, 50) inContext:currentContext];
    
    UIGraphicsEndPDFContext();
    
    [self performSelector:@selector(actionPDFCreated) withObject:nil];
    
}

-(NSString*)monthName:(NSString *)monthVal
{
    if([monthVal isEqualToString:@"Jan"])
        return  @"01";
    
    if([monthVal isEqualToString:@"Feb"])
        return   @"02";
    
    if([monthVal isEqualToString:@"Mar"])
        return  @"03";
    
    if([monthVal isEqualToString:@"Apr"])
        return @"04";
    
    if([monthVal isEqualToString:@"May"])
        return @"05";
    
    if([monthVal isEqualToString:@"Jun"])
        return @"06";
    
    if([monthVal isEqualToString:@"Jul"])
        return   @"07";
    
    if([monthVal isEqualToString:@"Aug"])
        return  @"08";
    
    if([monthVal isEqualToString:@"Sep"])
        return @"09";
    
    if([monthVal isEqualToString:@"Oct"])
        return @"10";
    
    if([monthVal isEqualToString:@"Nov"])
        return @"11";
    
    if([monthVal isEqualToString:@"Dec"])
        return @"12";
    
    return nil;
}

@end
