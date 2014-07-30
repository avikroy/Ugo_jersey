//
//  TicketListing+AdminViewController.h
//  Ugo jersey
//
//  Created by Avik Roy on 2/1/14.
//  Copyright (c) 2014 Debasish Pal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class Ticket;
@interface TicketListing_AdminViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray *arrTickets;
- (IBAction)showsaveticket:(id)sender;
@end
