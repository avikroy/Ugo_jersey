//
//  Event.m
//  Ugo jersey
//
//  Created by Debasish Pal on 11/09/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "Event.h"

@implementation Event

- (id)init
{
    if(self=[super init])
    {
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    if(self=[super init])
    {
        self.event_id=[dict objectForKey:@"event_id"];
        self.event_name=[dict objectForKey:@"event_name"];
        self.event_start_date=[dict objectForKey:@"event_start_date"];
        self.event_end_date=[dict objectForKey:@"event_end_date"];
        self.event_start_time=[dict objectForKey:@"event_start_time"];
        self.event_end_time=[dict objectForKey:@"event_end_time"];
    }
    return self;
}

@end
