//
//  Event.h
//  Ugo jersey
//
//  Created by Debasish Pal on 11/09/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, retain) NSString *event_id,*event_name,*event_start_date,*event_end_date,*event_start_time,*event_end_time;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
