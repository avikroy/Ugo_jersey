//
//  TicketListing+AdminViewController.h
//  Ugo jersey
//
//  Created by Avik Roy on 2/1/14.
//  Copyright (c) 2014 Debasish Pal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomActivityIndicator.h"

@class Ticket;
@interface SaveTicketListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    CustomActivityIndicator *cIndicator;
    Ticket *selectedTicket;
}
@property (nonatomic, retain) NSMutableArray *arrTickets;
@property (retain, nonatomic) IBOutlet UITableView *tableticket;
- (IBAction)ShowTicketFromSave:(id)sender;

@end