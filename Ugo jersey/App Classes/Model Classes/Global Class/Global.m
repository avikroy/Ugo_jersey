//
//  Global.m
//  Ugo jersey
//
//  Created by Debasish Pal on 08/09/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "Global.h"

@implementation Global
@synthesize allowedTicketArr;

+ (Global *)sharedInstance
{
    static Global *myInstance = nil;
	
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        
    }
    
    return myInstance;
}
+(void)getdata
{
    [Global sharedInstance].allowedTicketArr=[[NSMutableArray alloc]initWithObjects:nil];
}

+(void)releasedata
{
    if([Global sharedInstance].allowedTicketArr)
    {
        [[Global sharedInstance].allowedTicketArr release];
        [Global sharedInstance].allowedTicketArr=nil;
    }
    if(![Global sharedInstance].allowedTicketArr)
    {
        [Global sharedInstance].allowedTicketArr=[[NSMutableArray alloc]initWithObjects:nil];
    }
}

@end
