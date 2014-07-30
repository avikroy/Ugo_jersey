//
//  TicketEntryVC.m
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "TicketEntryVC.h"
#import "EventListVC.h"
#import "PreAdmittedVC.h"
#import "TicketDetailsVC+Validate.h"
#import "Ticket.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "BlockAlertView.h"
@interface TicketEntryVC ()

@end

@implementation TicketEntryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone) nibNameOrNil = @"TicketEntryVC_iPhone";
    
    else if (family == iPhone5) nibNameOrNil = @"TicketEntryVC";
    else nibNameOrNil = @"TicketEntryVC_iPad";
    
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
    UIView *padingTicketID=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.TicketIDTxtFd.leftView=padingTicketID;
    self.TicketIDTxtFd.leftViewMode=UITextFieldViewModeAlways;
    [padingTicketID release];
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
- (IBAction)submitAction:(id)sender
{
    self.aTicket=(Ticket *)[DBManager getTicketDetails:self.TicketIDTxtFd.text];
    NSLog(@"---%@",self.aTicket);
   if(self.aTicket)
   {
        if([self.aTicket.ticket_admit_status isEqualToString:@"1"])
        {
            PreAdmittedVC *preAdmit = [[PreAdmittedVC alloc] init];
            [self.navigationController pushViewController:preAdmit animated:YES];
            [preAdmit release];
        }
        else  if([self.aTicket.ticket_admit_status isEqualToString:@"0"])
        {
            TicketDetailsVC_Validate *ticketDet = [[TicketDetailsVC_Validate alloc] initWithNibName:@"TicketDetailsVC+Validate" bundle:nil];
            ticketDet.ticket=self.aTicket;
            [self.navigationController pushViewController:ticketDet animated:YES];
            [ticketDet release];
        }
        else
        {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"Ticket ID is not correct"];
            [alert setCancelButtonWithTitle:@"Ok" block:nil];
            [alert show];
        }
   }
}

- (IBAction)scanAction:(id)sender
{
    NSLog(@"Scanning..");
    if( ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)){
        // ADD: present a barcode reader that scans from the camera feed
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        
        ZBarImageScanner *scanner = reader.scanner;
        // TODO: (optional) additional reader configuration here
        
        // EXAMPLE: disable rarely used I2/5 to improve performance
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        // present and release the controller
        [self.navigationController presentViewController:reader animated:YES completion:nil];
        [reader release];
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your system version must be grater of equal to iOS7" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
    }
    
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

#pragma mark - bar code delegate

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    NSString *value=symbol.data;
    if(value){
        self.TicketIDTxtFd.text = value;
        self.aTicket=(Ticket *)[DBManager getTicketDetails:value];
        if([self.aTicket.ticket_admit_status isEqualToString:@"1"])
        {
            PreAdmittedVC *preAdmit = [[PreAdmittedVC alloc] init];
            [self.navigationController pushViewController:preAdmit animated:YES];
            [preAdmit release];
        }
        else  if([self.aTicket.ticket_admit_status isEqualToString:@"0"])
        {
            TicketDetailsVC_Validate *ticketDet = [[TicketDetailsVC_Validate alloc] initWithNibName:@"TicketDetailsVC+Validate" bundle:nil];
            ticketDet.ticket=self.aTicket;
            [self.navigationController pushViewController:ticketDet animated:YES];
            [ticketDet release];
        }
        
    }

    [reader dismissViewControllerAnimated:YES completion:nil];
}

- (void)getBarCodeValue:(NSString *)value{
    
}


#pragma mark -UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc
{
    [_TicketIDTxtFd release];
    [super dealloc];
}
@end
