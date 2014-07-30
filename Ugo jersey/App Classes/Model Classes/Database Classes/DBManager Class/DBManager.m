//
//  DBManager.m
//  iCompliance
//
//  Created by Debasish Pal on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBManager.h"
#import "TPUtlis.h"

@implementation DBManager

+ (NSString *)getDBPath
{
    NSString *dbPath=[TPUtlis applicationDocumentsDirectory];
    dbPath=[dbPath stringByAppendingPathComponent:DATABASE_FILE_PATH];
    dbPath=[TPUtlis getDirectoryAtPath:dbPath withInterMediateDirectory:NO];
    dbPath=[dbPath stringByAppendingPathComponent:DATABASE_NAME];
    
    //NSLog(@"PATH=%@",dbPath);
    return dbPath;
}

+ (FMDatabase *)getDatabase
{
    FMDatabase *database = [FMDatabase databaseWithPath:[DBManager getDBPath]];
    if([database open]) return database;
    else return nil;
}

#pragma mark - Search if database exists at that path else copy it there from application bundle

+ (void) checkAndCreateDatabaseAtPath:(NSString *)databasePath
{
	BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:databasePath];
	if(success) return;
    
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	[fileManager release];
}


////////////////////////////////////////////***************Tbl_Event Query*********************//////////////////////////////////////////////////////////////////////
+(void)createEventTableQuery
{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        [database executeUpdate:@"CREATE TABLE Event (Event_ID TEXT PRIMARY KEY  NOT NULL , Event_name TEXT, Event_StartDt TEXT, Event_EndDt TEXT, Event_Start_Tm TEXT, Event_EndTm TEXT)"];
        
        if([database lastErrorCode]==0)
        {
            NSLog(@"Create");
        }
        [database close];
    }
}

+ (BOOL)insertToEvent:(NSString *)eventID_str forEventNm:(NSString *)eventNm_str forStart_Dt:(NSString *)start_Dt_str forEnd_Dt:(NSString *)end_Dt_str forStart_Time:(NSString *)start_Time_str forEnd_Time:(NSString *)end_Time_str
{
       FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = @"insert into Event(Event_ID,Event_name,Event_StartDt,Event_EndDt,Event_Start_Tm,Event_EndTm) values(?,?,?,?,?,?)";
        
        [database executeUpdate:stmt,eventID_str,eventNm_str,start_Dt_str,end_Dt_str,start_Time_str,end_Time_str];
      
        NSLog(@"%@",[database lastErrorMessage]);
        if([database lastErrorCode]==0)
        {
            [database close];
            return YES;
        }
    }
    [database close];
    return NO;
}
+ (NSMutableArray *)getEvent_Nm_Arr
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithObjects: nil];
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = [NSString stringWithFormat:@"select Event_name from %@ ",@"Event"];
        FMResultSet *results = [database executeQuery:stmt];
        while([results next])
        {
            NSString *strResult=[results stringForColumn:@"Event_name"];
            
            NSLog(@"----%@",strResult);
            [arr addObject:strResult];
        }
    }
    [database close];
    return [arr autorelease];
}
+ (NSMutableArray *)getEvent_Date_Arr
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithObjects: nil];
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = [NSString stringWithFormat:@"select Event_StartDt from %@ ",@"Event"];
        FMResultSet *results = [database executeQuery:stmt];
        while([results next])
        {
            NSString *strResult=[results stringForColumn:@"Event_StartDt"];
            
            NSLog(@"----%@",strResult);
            [arr addObject:strResult];
        }
    }
    [database close];
    return [arr autorelease];
}
+ (NSMutableArray *)getEvent_ID_Arr
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithObjects: nil];
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = [NSString stringWithFormat:@"select Event_ID from %@ ",@"Event"];
        FMResultSet *results = [database executeQuery:stmt];
        while([results next])
        {
            NSString *strResult=[results stringForColumn:@"Event_ID"];
            
            NSLog(@"----%@",strResult);
            [arr addObject:strResult];
        }
    }
    [database close];
    return [arr autorelease];
}

////////////////////////////////////////////***************Tbl_Ticket Query*********************//////////////////////////////////////////////////////////////////////
+(void)createTicketTableQuery
{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        [database executeUpdate:@"CREATE TABLE Ticket(Ticket_ID TEXT PRIMARY KEY  NOT NULL , Holder_Nm TEXT, Holder_Phn TEXT, Buyer_Nm TEXT, Buyer_Email TEXT, Event_Nm TEXT, Issue_Dt TEXT, Admit_Status TEXT, Unique_ID TEXT,First_Nm TEXT,Sur_Nm TEXT,Initial_Nm TEXT)"];
        
        if([database lastErrorCode]==0)
        {
            NSLog(@"Create");
        }
        [database close];
    }
}
+ (BOOL)insertToTicket:(NSString *)ticket_ID_str forHolder_Nm:(NSString *)holder_Nm_str forHolder_Phn:(NSString *)holder_Phn_str forBuyer_Nm:(NSString *)buyer_Nm_str forBuyer_Email:(NSString *)buyer_Email_str forEventNm:(NSString *)eventNm_str forIssue_Dt:(NSString *)issue_Dt_str forAdmit_Stat:(NSString *)admit_status_str forUnique_ID:(NSString *)unique_ID_str forHolderFirstName:(NSString *)First_Nm_str forHolderSurName:(NSString *)Sur_Nm_str forHolderInitialName:(NSString *)Initial_Nm_str
{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
    NSString *stmt = @"insert into Ticket(Ticket_ID,Holder_Nm,Holder_Phn,Buyer_Nm,Buyer_Email,Event_Nm,Issue_Dt,Admit_Status,Unique_ID,First_Nm,Sur_Nm,Initial_Nm) values(?,?,?,?,?,?,?,?,?,?,?,?)";
        
        [database executeUpdate:stmt,ticket_ID_str,holder_Nm_str,holder_Phn_str,buyer_Nm_str,buyer_Email_str,eventNm_str,issue_Dt_str,admit_status_str,unique_ID_str,First_Nm_str,Sur_Nm_str,Initial_Nm_str];
        
        NSLog(@"%@",[database lastErrorMessage]);
        if([database lastErrorCode]==0)
        {
            [database close];
            return YES;
        }
    }
    [database close];
    return NO;
    
}
+ (NSInteger )getRowCountForTable:(NSString *)tblName
{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = [NSString stringWithFormat:@"select count(*) as cnt from %@",tblName];
        FMResultSet *results = [database executeQuery:stmt];
        while([results next]) 
        {
            NSInteger strResult=[results intForColumn:@"cnt"];
            [database close];
            return strResult;
        }
    }
    [database close];
    
    return 0;
}
+(void)dropTableQuery:(NSString *)tblName
{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = [NSString stringWithFormat:@"DROP TABLE %@",tblName];
        [database executeUpdate:stmt];
        NSLog(@"%@",[database lastErrorMessage]);
        if([database lastErrorCode]==0)
        {
            NSLog(@"Drop");
        }
        [database close];
    }
}


+ (Ticket *)getTicketDetails:(NSString * )ticketID
{
    Ticket *aTicket=[[Ticket alloc] init];
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = [NSString stringWithFormat:@"select * from %@ where Unique_ID='%@'",@"Ticket",ticketID];
       
#ifdef DEBUG
        NSLog(@"%@",stmt);
#endif
        FMResultSet *resultsTicket = [database executeQuery:stmt];
        while([resultsTicket next])
        {
            aTicket.ticket_id=[resultsTicket stringForColumn:@"Ticket_ID"];
            aTicket.ticket_holder_name=[resultsTicket stringForColumn:@"Holder_Nm"];
            aTicket.ticket_holder_phone=[resultsTicket stringForColumn:@"Holder_Phn"];
            aTicket.ticket_buyer_name=[resultsTicket stringForColumn:@"Buyer_Nm"];
            aTicket.ticket_buyer_email=[resultsTicket stringForColumn:@"Buyer_Email"];
            aTicket.ticket_event_name=[resultsTicket stringForColumn:@"Event_Nm"];
            aTicket.ticket_issue_date=[resultsTicket stringForColumn:@"Issue_Dt"];
            aTicket.ticket_admit_status=[resultsTicket stringForColumn:@"Admit_Status"];
            aTicket.ticket_unique_id=[resultsTicket stringForColumn:@"Unique_ID"];
            aTicket.ticket_holder_firstname=[resultsTicket stringForColumn:@"First_Nm"];
            aTicket.ticket_holder_initial=[resultsTicket stringForColumn:@"Initial_Nm"];
            aTicket.ticket_holder_surname=[resultsTicket stringForColumn:@"Sur_Nm"];
            return aTicket;
        }
    }
    [database close];
    return [aTicket autorelease];
}

/*+ (NSString *)getAnswer_CorrectOfNumber:(NSInteger )number_
{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = [NSString stringWithFormat:@"select correct_ans from %@ where id='%@'",@"Tbl_Cat_Song",[NSString stringWithFormat:@"%d",number_]];
        FMResultSet *results = [database executeQuery:stmt];
        while([results next]) 
        {
            NSString *strResult=[results stringForColumn:@"correct_ans"];
            [database close];
            return strResult;
        }
    }
            [database close];
            return @"";
}*/

////////////////////////////////////////////***************Tbl_EventTicketMapQuery*********************////////////////////////////
+ (void)createMapTableQuery
{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        [database executeUpdate:@"CREATE TABLE EventTicketMap(Ticket_ID TEXT,Event_ID TEXT)"];
        
        if([database lastErrorCode]==0)
        {
            NSLog(@"Create");
        }
        [database close];
    }
}

+ (BOOL)insertMapEvent:(NSString *)eventID_str ticket:(NSString *)strTckID
{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
       // eventNm_str=[eventNm_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
       // eventNm_str=[eventNm_str uppercaseString];
        NSString *stmt = @"insert into EventTicketMap(Ticket_ID,Event_ID) values(?,?)";
        
        [database executeUpdate:stmt,strTckID,eventID_str];
        
        NSLog(@"%@",[database lastErrorMessage]);
        if([database lastErrorCode]==0)
        {
            [database close];
            return YES;
        }
    }
    [database close];
    return NO;
}

+ (NSMutableArray *)getTicketsForEvent:(NSString *)eventID_str
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithObjects: nil];
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
      //  eventNm_str=[eventNm_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      //  eventNm_str=[eventNm_str uppercaseString];
      NSString *stmt = [NSString stringWithFormat:@"select Ticket_ID from %@ where Event_ID='%@'",@"EventTicketMap",eventID_str];
#ifdef DEBUG
        NSLog(@"%@",stmt);
#endif
        FMResultSet *results = [database executeQuery:stmt];
        while([results next])
        {
            NSString *strResult=[results stringForColumn:@"Ticket_ID"];
            stmt = [NSString stringWithFormat:@"select * from %@ where Ticket_ID='%@'",@"Ticket",strResult];
#ifdef DEBUG
            NSLog(@"%@",stmt);
#endif
            FMResultSet *resultsTicket = [database executeQuery:stmt];
            while([resultsTicket next])
            {
                Ticket *aTicket=[[Ticket alloc] init];
                aTicket.ticket_id=[resultsTicket stringForColumn:@"Ticket_ID"];
                aTicket.ticket_holder_name=[resultsTicket stringForColumn:@"Holder_Nm"];
                aTicket.ticket_holder_phone=[resultsTicket stringForColumn:@"Holder_Phn"];
                aTicket.ticket_buyer_name=[resultsTicket stringForColumn:@"Buyer_Nm"];
                aTicket.ticket_buyer_email=[resultsTicket stringForColumn:@"Buyer_Email"];
                aTicket.ticket_event_name=[resultsTicket stringForColumn:@"Event_Nm"];
                aTicket.ticket_issue_date=[resultsTicket stringForColumn:@"Issue_Dt"];
                aTicket.ticket_admit_status=[resultsTicket stringForColumn:@"Admit_Status"];
                aTicket.ticket_unique_id=[resultsTicket stringForColumn:@"Unique_ID"];
                aTicket.ticket_holder_firstname=[resultsTicket stringForColumn:@"First_Nm"];
                aTicket.ticket_holder_initial=[resultsTicket stringForColumn:@"Initial_Nm"];
                aTicket.ticket_holder_surname=[resultsTicket stringForColumn:@"Sur_Nm"];
                [arr addObject:aTicket];
                [aTicket release];
            }
        }
    }
    [database close];
    return [arr autorelease];
}

+ (Event *)getEventsForTicket:(NSString *)ticketID_str
{
    Event *anEvent=[[Event alloc] init];
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        //  eventNm_str=[eventNm_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //  eventNm_str=[eventNm_str uppercaseString];
        NSString *stmt = [NSString stringWithFormat:@"select Event_ID from %@ where Ticket_ID='%@'",@"EventTicketMap",ticketID_str];
#ifdef DEBUG
        NSLog(@"%@",stmt);
#endif
        FMResultSet *results = [database executeQuery:stmt];
        while([results next])
        {
            NSString *strResult=[results stringForColumn:@"Event_ID"];
            stmt = [NSString stringWithFormat:@"select * from %@ where Event_ID='%@'",@"Event",strResult];
#ifdef DEBUG
            NSLog(@"%@",stmt);
#endif
            FMResultSet *resultsTicket = [database executeQuery:stmt];
            while([resultsTicket next])
            {
                anEvent.event_id=[resultsTicket stringForColumn:@"Event_ID"];
                anEvent.event_name=[resultsTicket stringForColumn:@"Event_name"];
                anEvent.event_start_date=[resultsTicket stringForColumn:@"Event_StartDt"];
                anEvent.event_end_date=[resultsTicket stringForColumn:@"Event_EndDt"];
                anEvent.event_start_time=[resultsTicket stringForColumn:@"Event_Start_Tm"];
                anEvent.event_end_time=[resultsTicket stringForColumn:@"Event_EndTm"];
                return anEvent;
            }
        }
    }
    [database close];
    return [anEvent autorelease];
}

+ (BOOL)updateTicketToAdmitted:(NSString *)unique_id
{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = @"UPDATE Ticket SET Admit_Status='1' WHERE  Unique_ID=?";
        
        [database executeUpdate:stmt,unique_id];
        
        NSLog(@"%@",[database lastErrorMessage]);
        if([database lastErrorCode]==0)
        {
            [database close];
            return YES;
        }
    }
    [database close];
    return NO;
}

////////////////////////////////////////////***************Tbl_AdminTicket Query*********************//////////////////////////////////////////////////////////////////////
+(void)createAdminTicketTableQuery
{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        //        [database executeUpdate:@"CREATE TABLE AdminTicket (ticket_unique_id TEXT PRIMARY KEY  NOT NULL , ticket_id TEXT, ticket_issue_date TEXT, ticket_holder_surname TEXT, ticket_holder_phone TEXT, ticket_holder_name TEXT, ticket_holder_initial TEXT, ticket_holder_firstname TEXT, ticket_event_name TEXT, ticket_buyer_name TEXT, ticket_buyer_email TEXT, ticket_admit_status TEXT, starttime TEXT, location TEXT, endtime TEXT, description_event TEXT, date_event TEXT)"];
        
        [database executeUpdate:@"CREATE TABLE AdminTicket(Ticket_ID TEXT PRIMARY KEY  NOT NULL , Holder_Nm TEXT, Holder_Phn TEXT, Buyer_Nm TEXT, Buyer_Email TEXT, Event_Nm TEXT, Issue_Dt TEXT, Admit_Status TEXT, Unique_ID TEXT,First_Nm TEXT,Sur_Nm TEXT,Initial_Nm TEXT,starttime TEXT, location TEXT, endtime TEXT, description_event TEXT, date_event TEXT,qr_code BLOB, is_save TEXT)"];
        
        if([database lastErrorCode]==0)
        {
            NSLog(@"Create");
        }
        [database close];
    }
}

+ (BOOL)insertToAdminTicket:(NSString *)ticket_ID_str forHolder_Nm:(NSString *)holder_Nm_str forHolder_Phn:(NSString *)holder_Phn_str forBuyer_Nm:(NSString *)buyer_Nm_str forBuyer_Email:(NSString *)buyer_Email_str forEventNm:(NSString *)eventNm_str forIssue_Dt:(NSString *)issue_Dt_str forAdmit_Stat:(NSString *)admit_status_str forUnique_ID:(NSString *)unique_ID_str forHolderFirstName:(NSString *)First_Nm_str forHolderSurName:(NSString *)Sur_Nm_str forHolderInitialName:(NSString *)Initial_Nm_str startTime:(NSString *)start_time location:(NSString *)location endtime:(NSString *)endtime description_event:(NSString *)description_event date_event:(NSString *)date_event
{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = @"insert into AdminTicket(Ticket_ID,Holder_Nm,Holder_Phn,Buyer_Nm,Buyer_Email,Event_Nm,Issue_Dt,Admit_Status,Unique_ID,First_Nm,Sur_Nm,Initial_Nm,starttime,location,endtime,description_event,date_event,qr_code,is_save) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'0')";
        
        [database executeUpdate:stmt,ticket_ID_str,holder_Nm_str,holder_Phn_str,buyer_Nm_str,buyer_Email_str,eventNm_str,issue_Dt_str,admit_status_str,unique_ID_str,First_Nm_str,Sur_Nm_str,Initial_Nm_str,start_time,location,endtime,description_event,date_event,nil];
        
        NSLog(@"%@",[database lastErrorMessage]);
        if([database lastErrorCode]==0)
        {
            [database close];
            return YES;
        }
    }
    [database close];
    return NO;
    
}

+(BOOL)updateToAdminTicketisSave:(NSString *)ticket_ID_str{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = @"Update AdminTicket set is_save ='1' where Unique_ID = ?";
        [database executeUpdate:stmt,ticket_ID_str];
        
        NSLog(@"%@",[database lastErrorMessage]);
        if([database lastErrorCode]==0)
        {
            [database close];
            return YES;
        }
    }
    [database close];
    return NO;
}

+(BOOL)updateToAdminTicketSaveQRImage:(NSString *)ticket_ID_str image:(NSData *)data{
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = @"Update AdminTicket set qr_code =? where Unique_ID = ?";
        [database executeUpdate:stmt,data,ticket_ID_str];
        
        NSLog(@"%@",[database lastErrorMessage]);
        if([database lastErrorCode]==0)
        {
            [database close];
            return YES;
        }
    }
    [database close];
    return NO;
}



+ (NSMutableArray *)getAdminTickets
{
    NSMutableArray *arrResult=[[[NSMutableArray alloc] init] autorelease];
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = [NSString stringWithFormat:@"select * from %@",@"AdminTicket"];
        
#ifdef DEBUG
        NSLog(@"%@",stmt);
#endif
        FMResultSet *resultsTicket = [database executeQuery:stmt];
        while([resultsTicket next])
        {
            Ticket *aTicket=[[Ticket alloc] init];

            aTicket.ticket_id=[resultsTicket stringForColumn:@"Ticket_ID"];
            aTicket.ticket_holder_name=[resultsTicket stringForColumn:@"Holder_Nm"];
            aTicket.ticket_holder_phone=[resultsTicket stringForColumn:@"Holder_Phn"];
            aTicket.ticket_buyer_name=[resultsTicket stringForColumn:@"Buyer_Nm"];
            aTicket.ticket_buyer_email=[resultsTicket stringForColumn:@"Buyer_Email"];
            aTicket.ticket_event_name=[resultsTicket stringForColumn:@"Event_Nm"];
            aTicket.ticket_issue_date=[resultsTicket stringForColumn:@"Issue_Dt"];
            aTicket.ticket_admit_status=[resultsTicket stringForColumn:@"Admit_Status"];
            aTicket.ticket_unique_id=[resultsTicket stringForColumn:@"Unique_ID"];
            aTicket.ticket_holder_firstname=[resultsTicket stringForColumn:@"First_Nm"];
            aTicket.ticket_holder_initial=[resultsTicket stringForColumn:@"Initial_Nm"];
            aTicket.ticket_holder_surname=[resultsTicket stringForColumn:@"Sur_Nm"];
            aTicket.starttime=[resultsTicket stringForColumn:@"starttime"];
            aTicket.location=[resultsTicket stringForColumn:@"location"];
            aTicket.endtime=[resultsTicket stringForColumn:@"endtime"];
            aTicket.description_event=[resultsTicket stringForColumn:@"description_event"];
            aTicket.date_event=[resultsTicket stringForColumn:@"date_event"];

            [arrResult addObject:aTicket];
        }
    }
    [database close];
    return arrResult;
}

+ (NSData *)getQRCodeDateForTicket:(NSString *)str_ticket{
    NSData *aData=nil;
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = [NSString stringWithFormat:@"select qr_code from %@ where Unique_ID = ?",@"AdminTicket"];
        
#ifdef DEBUG
        NSLog(@"%@",stmt);
#endif
        FMResultSet *resultsTicket = [database executeQuery:stmt,str_ticket];
        while([resultsTicket next])
        {
            aData=[resultsTicket dataForColumn:@"qr_code"];
        }
    }
    [database close];
    return aData;
}

+ (NSMutableArray *)ShowSavedTicketList
{
    NSMutableArray *arrResult=[[[NSMutableArray alloc] init] autorelease];
    FMDatabase *database=[DBManager getDatabase];
    if(database)
    {
        NSString *stmt = [NSString stringWithFormat:@"select * from %@",@"AdminTicket Where is_save = '1'"];
        
#ifdef DEBUG
        NSLog(@"%@",stmt);
#endif
        FMResultSet *resultsTicket = [database executeQuery:stmt];
        while([resultsTicket next])
        {
            Ticket *aTicket=[[Ticket alloc] init];
            
            aTicket.ticket_id=[resultsTicket stringForColumn:@"Ticket_ID"];
            aTicket.ticket_holder_name=[resultsTicket stringForColumn:@"Holder_Nm"];
            aTicket.ticket_holder_phone=[resultsTicket stringForColumn:@"Holder_Phn"];
            aTicket.ticket_buyer_name=[resultsTicket stringForColumn:@"Buyer_Nm"];
            aTicket.ticket_buyer_email=[resultsTicket stringForColumn:@"Buyer_Email"];
            aTicket.ticket_event_name=[resultsTicket stringForColumn:@"Event_Nm"];
            aTicket.ticket_issue_date=[resultsTicket stringForColumn:@"Issue_Dt"];
            aTicket.ticket_admit_status=[resultsTicket stringForColumn:@"Admit_Status"];
            aTicket.ticket_unique_id=[resultsTicket stringForColumn:@"Unique_ID"];
            aTicket.ticket_holder_firstname=[resultsTicket stringForColumn:@"First_Nm"];
            aTicket.ticket_holder_initial=[resultsTicket stringForColumn:@"Initial_Nm"];
            aTicket.ticket_holder_surname=[resultsTicket stringForColumn:@"Sur_Nm"];
            aTicket.starttime=[resultsTicket stringForColumn:@"starttime"];
            aTicket.location=[resultsTicket stringForColumn:@"location"];
            aTicket.endtime=[resultsTicket stringForColumn:@"endtime"];
            aTicket.description_event=[resultsTicket stringForColumn:@"description_event"];
            aTicket.date_event=[resultsTicket stringForColumn:@"date_event"];
            
            [arrResult addObject:aTicket];
        }
    }
    [database close];
    return arrResult;
}

@end
