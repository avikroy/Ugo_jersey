//
//  Global.h
//  Ugo jersey
//
//  Created by Debasish Pal on 08/09/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject
{
      NSMutableArray *allowedTicketArr;
}
@property(nonatomic,retain) NSMutableArray *allowedTicketArr;

+ (Global *)sharedInstance;
+(void)getdata;
+(void)releasedata;

@end
