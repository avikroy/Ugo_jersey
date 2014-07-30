//
//  TicketListVC.h
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "BaseViewController.h"

@interface TicketListVC : BaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSArray *sortedArray;
    NSMutableDictionary *sectionContent;
    NSMutableArray  *secContent;
}
@property (retain, nonatomic) IBOutlet UITableView *TicketListTblVw;
@property (retain, nonatomic) IBOutlet UILabel *lblEventNm;
@property (retain, nonatomic) IBOutlet UILabel *lblDate;
@property (retain, nonatomic) NSMutableArray *arrData;
@property (retain, nonatomic)NSString *event_Nm_Str,*event_Dt_Str,*event_ID_Str;
@property (retain, nonatomic) IBOutlet UISearchBar *searchTable;

- (IBAction)validate:(id)sender;
- (IBAction)check:(id)sender;
-(void)createSearch;

@end
