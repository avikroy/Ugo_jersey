//
//  DBManager.h
//  iCompliance
//
//  Created by Debasish Pal on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Ticket.h"
#import "Event.h"
#define DATABASE_FILE_PATH @"DataBase"
#define DATABASE_NAME @"UgoJersey.sqlite"

@interface DBManager : NSObject

+ (NSString *)getDBPath;
+ (FMDatabase *)getDatabase;
+ (void) checkAndCreateDatabaseAtPath:(NSString *)databasePath;

+ (BOOL)insertToEvent:(NSString *)eventID_str forEventNm:(NSString *)eventNm_str forStart_Dt:(NSString *)start_Dt_str forEnd_Dt:(NSString *)end_Dt_str forStart_Time:(NSString *)start_Time_str forEnd_Time:(NSString *)end_Time_str;

+ (BOOL)insertToTicket:(NSString *)ticket_ID_str forHolder_Nm:(NSString *)holder_Nm_str forHolder_Phn:(NSString *)holder_Phn_str forBuyer_Nm:(NSString *)buyer_Nm_str forBuyer_Email:(NSString *)buyer_Email_str forEventNm:(NSString *)eventNm_str forIssue_Dt:(NSString *)issue_Dt_str forAdmit_Stat:(NSString *)admit_status_str forUnique_ID:(NSString *)unique_ID_str forHolderFirstName:(NSString *)First_Nm_str forHolderSurName:(NSString *)Sur_Nm_str forHolderInitialName:(NSString *)Initial_Nm_str;

+ (NSMutableArray *)getEvent_Nm_Arr;
+ (NSMutableArray *)getEvent_Date_Arr;
+ (NSMutableArray *)getEvent_ID_Arr;
+ (Ticket *)getTicketDetails:(NSString * )ticketID;
+ (NSInteger )getRowCountForTable:(NSString *)tblName;
+(void)dropTableQuery:(NSString *)tblName;

+(void)createEventTableQuery;
+(void)createTicketTableQuery;

+ (void)createMapTableQuery;
+ (BOOL)insertMapEvent:(NSString *)eventID_str ticket:(NSString *)strTckID;
+ (NSMutableArray *)getTicketsForEvent:(NSString *)eventID_str;
+ (Event *)getEventsForTicket:(NSString *)ticketID_str;

+ (BOOL)updateTicketToAdmitted:(NSString *)unique_id;

+ (void)createAdminTicketTableQuery;
+ (BOOL)insertToAdminTicket:(NSString *)ticket_ID_str forHolder_Nm:(NSString *)holder_Nm_str forHolder_Phn:(NSString *)holder_Phn_str forBuyer_Nm:(NSString *)buyer_Nm_str forBuyer_Email:(NSString *)buyer_Email_str forEventNm:(NSString *)eventNm_str forIssue_Dt:(NSString *)issue_Dt_str forAdmit_Stat:(NSString *)admit_status_str forUnique_ID:(NSString *)unique_ID_str forHolderFirstName:(NSString *)First_Nm_str forHolderSurName:(NSString *)Sur_Nm_str forHolderInitialName:(NSString *)Initial_Nm_str startTime:(NSString *)start_time location:(NSString *)location endtime:(NSString *)endtime description_event:(NSString *)description_event date_event:(NSString *)date_event;
+(BOOL)updateToAdminTicketisSave:(NSString *)ticket_ID_str;
+ (NSMutableArray *)getAdminTickets;
+ (NSMutableArray *)ShowSavedTicketList;
+(BOOL)updateToAdminTicketSaveQRImage:(NSString *)ticket_ID_str image:(NSData *)data;
+ (NSData *)getQRCodeDateForTicket:(NSString *)str_ticket;
@end
