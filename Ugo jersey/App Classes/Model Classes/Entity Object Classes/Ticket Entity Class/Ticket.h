//
//  Ticket.h
//  Ugo jersey
//
//  Created by Dreamz Tech Solution on 22/08/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ticket : NSObject

@property (nonatomic, retain) NSString *ticket_id,*ticket_holder_name,*ticket_holder_phone,*ticket_buyer_name,*ticket_buyer_email,*ticket_event_name,*ticket_issue_date,*ticket_admit_status,*ticket_unique_id,*event_start_date,*event_end_date,*event_start_time,*event_end_time,*ticket_holder_firstname,*ticket_holder_initial,*ticket_holder_surname,*starttime,*location,*endtime,*description_event,*date_event;
@property (nonatomic, retain) NSData *imageData;
//starttime,location,endtime,description_event,date_event
- (id)initWithDictionary:(NSDictionary *)dict;


@end
