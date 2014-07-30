//
//  TicketDetailsVC+Validate.h
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "BaseViewController.h"
#import "Ticket.h"
#import "Event.h"
#import "ConnectionModel.h"

@interface TicketDetailsVC_Validate : BaseViewController<connectionDidReceiveResponse>

@property (retain, nonatomic) IBOutlet UIScrollView *TicketDetailsScroll;
@property (retain, nonatomic) IBOutlet UILabel *TicketIDVal_Lbl;
@property (retain, nonatomic) IBOutlet UILabel *IssueDtVal_Lbl;
@property (retain, nonatomic) IBOutlet UILabel *NameVal_Lbl;
@property (retain, nonatomic) IBOutlet UILabel *PhnNoVal_Lbl;
@property (retain, nonatomic) IBOutlet UILabel *StatVal_Lbl;
@property (retain, nonatomic) IBOutlet UILabel *EventNmVal_Lbl;
@property (retain, nonatomic) IBOutlet UILabel *EventStartDtVal_Lbl;
@property (retain, nonatomic) IBOutlet UILabel *EventEndDtVal_Lbl;
@property (retain, nonatomic) IBOutlet UILabel *EventStartTimeVal_Lbl;
@property (retain, nonatomic) IBOutlet UILabel *EventEndTimeVal_Lbl;

@property(retain,nonatomic)Ticket *ticket;
@property(retain,nonatomic)Event *event;

- (IBAction)validate:(id)sender;
- (IBAction)check:(id)sender;
- (IBAction)allowEntryAction:(id)sender;
- (IBAction)declineEntryAction:(id)sender;
-(void)createConnectionUpdateStatusofTicket;
@end
