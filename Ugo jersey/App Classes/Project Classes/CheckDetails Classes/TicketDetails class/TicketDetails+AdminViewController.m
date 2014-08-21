//
//  TicketDetails+AdminViewController.m
//  Ugo jersey
//
//  Created by Avik Roy on 2/8/14.
//  Copyright (c) 2014 Debasish Pal. All rights reserved.
//

#import "TicketDetails+AdminViewController.h"
#import "PDFCreater.h"
#import "AppToolBox.h"
#import "NSString+HTML.h"
#import "DBManager.h"
#import "SaveTicketListViewController.h"
#import "ShowPDFViewController.h"

#define kDefaultPageHeight 792
#define kDefaultPageWidth  612
#define kMargin 50
#define kColumnMargin 10

@interface TicketDetails_AdminViewController ()

@end

@implementation TicketDetails_AdminViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        Devicefamily family = thisDeviceFamily();
        if (family == iPhone) nibNameOrNil = @"TicketDetails+AdminViewController";
        
        else if (family == iPhone5) nibNameOrNil = @"TicketDetails+AdminViewController";
        else nibNameOrNil = @"TicketDetailsViewController_iPad";
        
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
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone || family == iPhone5)
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"inner-bg-small.png"] ];
    }
    else if (family == iPad)
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"inner-small.png"] ];
    }
    self.lblTicketID.text=self.ticket.ticket_unique_id;
    self.lblIssueDate.text=self.ticket.ticket_issue_date;
    self.lblName.text=self.ticket.ticket_holder_name;
    self.lblPhoneNumber.text=self.ticket.ticket_holder_phone;
    self.lblStatus  .text=[self admitStatusForTicket:[self.ticket.ticket_admit_status intValue]];
    self.lblEventName.text=self.ticket.ticket_event_name;
    self.lblEventDate.text=self.ticket.ticket_issue_date;
    
    self.scrollMain.contentSize=CGSizeMake(self.scrollMain.frame.size.width, self.scrollMain.frame.size.height+2.0);
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
    [_lblTicketID release];
    [_lblIssueDate release];
    [_lblName release];
    [_lblPhoneNumber release];
    [_lblStatus release];
    [_lblEventName release];
    [_lblEventDate release];
    [_scrollMain release];
    [super dealloc];
}

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
    lblHeading.text=@"UGOjersey";
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


#pragma mark - UIButton Selector
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)downloadAction:(id)sender {
//    cIndicator=[[CustomActivityIndicator alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
//    [self.view addSubview:cIndicator];
     
    NSDateFormatter *dateFormatter = nil;
    dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy"];
    // [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    //NSString *strEvntDate=[[self.ticket.date_event componentsSeparatedByString:@" "]objectAtIndex:0];
    NSString *strEvntDate=[[self.ticket.date_event componentsSeparatedByString:@" "]lastObject];
    NSLog(@"---%@",strEvntDate);
    NSDate *today = [NSDate date]; // it will give you current date
    NSDate *newDate = [dateFormatter dateFromString:strEvntDate]; // your date
    
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    
    result = [today compare:newDate]; // comparing two dates

    [self showHUD];
        [self performSelector:@selector(completed) withObject:nil afterDelay:2.0];
                  
        if(result==NSOrderedAscending)
        {
            NSLog(@"today is less");
            [DBManager updateToAdminTicketisSave: self.ticket.ticket_unique_id];
        }
        else if(result==NSOrderedDescending)
        {
            NSLog(@"newDate is less");
        }
        else
        {
            NSLog(@"Both dates are same");
        }
}

- (IBAction)showSavedTicketAction:(id)sender {
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
    [self hideHUD];
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
    //490, 30,87 , 87    490, 330,87 , 87
    [CreatePDF drawImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.ugojersey.com/magento/aa.php?product=%@&format=2",self.ticket.ticket_unique_id]]]] atRect:CGRectMake(450, 30,120 , 115) inContext:currentContext];
    [CreatePDF drawImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.ugojersey.com/magento/aa.php?product=%@&format=2",self.ticket.ticket_unique_id]]]] atRect:CGRectMake(400, 330,180 , 180) inContext:currentContext];
    [DBManager updateToAdminTicketSaveQRImage:self.ticket.ticket_unique_id image:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.ugojersey.com/magento/aa.php?product=%@&format=2",self.ticket.ticket_unique_id]]]];
        
    [CreatePDF drawString:self.ticket.ticket_event_name atRect:CGRectMake(currentX, currentPageY, 300.0, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:25] alignment:NSTextAlignmentLeft];
    currentPageY+=40;

    [CreatePDF drawString:self.ticket.ticket_holder_name atRect:CGRectMake(currentX, currentPageY, 300.0, 25.0) withColor:[UIColor colorWithRed:237/255.0 green:122/255.0 blue:53/255.0 alpha:1.0] font:[UIFont systemFontOfSize:20] alignment:NSTextAlignmentLeft];

    currentPageY+=70;
    currentPageY+=0;
    currentX=kMargin;
    currentX+=30;

    [CreatePDF drawString:self.ticket.ticket_unique_id atRect:CGRectMake(currentX, currentPageY, 100, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15]alignment:NSTextAlignmentCenter];
    currentX+=170;

    [CreatePDF drawString:self.ticket.ticket_issue_date atRect:CGRectMake(currentX, currentPageY, 110, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15]alignment:NSTextAlignmentCenter];
    currentX+=120;

    [CreatePDF drawString:self.ticket.ticket_holder_phone atRect:CGRectMake(currentX, currentPageY, 220, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15]alignment:NSTextAlignmentCenter];
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
    [CreatePDF drawString:self.ticket.starttime atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];

    currentPageY+=13;

    currentX=temp_x;
    currentX+=45;

    [CreatePDF drawString:self.ticket.endtime atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];
    currentPageY+=13;

    currentX=temp_x;
    currentX+=30;
   
    [CreatePDF drawString:self.ticket.ticket_holder_phone atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];

    currentPageY+=14;

    currentX=temp_x;
    currentX+=50;
   
    [CreatePDF drawString:self.ticket.location atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];
    temp_x+=170;
    currentX=temp_x;
    currentPageY=temp_y;

    currentX+=25;

    [CreatePDF drawString:self.ticket.ticket_holder_name atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];

    currentPageY+=13;

    currentX=temp_x;
    currentX+=45;

    [CreatePDF drawString:self.ticket.ticket_unique_id atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];
    currentPageY+=14;

    currentX=temp_x;
    currentX+=20;
    
    [CreatePDF drawString:self.ticket.date_event atRect:CGRectMake(currentX, currentPageY, 120, 25.0) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:10] alignment:NSTextAlignmentLeft];

    currentX=kMargin;
    currentPageY+=53;

    NSString* stripped_description_event = [self.ticket.description_event kv_encodeHTMLCharacterEntities];
    CGFloat height=[AppToolBox heightForText:stripped_description_event withFont:[UIFont systemFontOfSize:13] LineBreakMode:NSTextAlignmentLeft maxSize:CGSizeMake(300, 2000)];
    [CreatePDF drawString:stripped_description_event atRect:CGRectMake(currentX, currentPageY, 300, height) withColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] alignment:NSTextAlignmentLeft];
    
    currentX=kMargin;
    currentPageY+=335;
       
    NSArray *arr = [NSArray arrayWithObjects:@"2",@"1", @"2",@"1",@"2",@"1",@"2",@"1",nil];
    int lowerBound = 1;
    int upperBound = [arr count];
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
       
    [CreatePDF drawImage:[UIImage imageNamed:[NSString stringWithFormat:@"banner_%@.png",[arr objectAtIndex:rndValue]]] atRect:CGRectMake(currentX, currentPageY, maxWidth-4, 50) inContext:currentContext];
    
    UIGraphicsEndPDFContext();
    
    [self performSelector:@selector(actionPDFCreated) withObject:nil];
    
}

@end
