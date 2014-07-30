//
//  TicketDetails+AdminViewController.h
//  Ugo jersey
//
//  Created by Avik Roy on 2/8/14.
//  Copyright (c) 2014 Debasish Pal. All rights reserved.
//

#import "BaseViewController.h"
#import "Ticket.h"
#import "CustomActivityIndicator.h"

@interface TicketDetails_AdminViewController : BaseViewController{
    CustomActivityIndicator *cIndicator;

}
@property (retain, nonatomic) IBOutlet UILabel *lblTicketID;
@property (retain, nonatomic) IBOutlet UILabel *lblIssueDate;
@property (retain, nonatomic) IBOutlet UILabel *lblName;
@property (retain, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (retain, nonatomic) IBOutlet UILabel *lblStatus;
@property (retain, nonatomic) IBOutlet UILabel *lblEventName;
@property (retain, nonatomic) IBOutlet UILabel *lblEventDate;
@property(retain,nonatomic)Ticket *ticket;

- (IBAction)downloadAction:(id)sender;
- (IBAction)showSavedTicketAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollMain;

@end
