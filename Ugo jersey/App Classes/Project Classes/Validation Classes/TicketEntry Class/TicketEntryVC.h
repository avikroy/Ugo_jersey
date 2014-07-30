//
//  TicketEntryVC.h
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "BaseViewController.h"
#import "Ticket.h"
#import "ZBarSDK.h"

@interface TicketEntryVC : BaseViewController<ZBarReaderDelegate>

@property (retain, nonatomic) IBOutlet UITextField *TicketIDTxtFd;
@property(retain,nonatomic)Ticket *aTicket;
- (IBAction)validate:(id)sender;
- (IBAction)check:(id)sender;
- (IBAction)submitAction:(id)sender;
- (IBAction)scanAction:(id)sender;
@end
