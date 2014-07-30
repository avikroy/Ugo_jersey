//
//  Ticket.m
//  Ugo jersey
//
//  Created by Dreamz Tech Solution on 22/08/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

- (id)init
{
    if(self=[super init])
    {
        
    }
    return self;
}
//starttime endtime

- (id)initWithDictionary:(NSDictionary *)dict
{
    if(self=[super init])
    {
        self.ticket_id=[dict objectForKey:@"ticket_id"];
        self.ticket_holder_name=[dict objectForKey:@"ticket_holder_name"];
        self.ticket_holder_phone=[dict objectForKey:@"ticket_holder_phone"];
        self.ticket_buyer_name=[dict objectForKey:@"ticket_buyer_name"];
        self.ticket_buyer_email=[dict objectForKey:@"ticket_buyer_email"];
        self.ticket_event_name=[dict objectForKey:@"ticket_event_name"];
        self.ticket_issue_date=[dict objectForKey:@"ticket_issue_date"];
        self.ticket_admit_status=[dict objectForKey:@"ticket_admit_status"];
        self.ticket_unique_id=[dict objectForKey:@"ticket_unique_id"];
        self.ticket_holder_firstname=[dict objectForKey:@"ticket_holder_firstname"];
        self.ticket_holder_initial=[dict objectForKey:@"ticket_holder_initial"];
        self.ticket_holder_surname=[dict objectForKey:@"ticket_holder_surname"];
        self.starttime=[dict objectForKey:@"starttime"];
        self.endtime=[dict objectForKey:@"endtime"];
        self.location=[dict objectForKey:@"location"];
        self.description_event=[dict objectForKey:@"description_event"];
        self.date_event=[dict objectForKey:@"date_event"];
        self.imageData=nil;
    }
    return self;
}

@end
