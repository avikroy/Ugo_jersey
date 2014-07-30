//
//  EventListVC.h
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "BaseViewController.h"

@interface EventListVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic,assign)int eventCount;
@property (retain, nonatomic)NSMutableArray *event_Nm_Arr,*event_Dt_Arr,*event_ID_Arr;
@property (retain, nonatomic) IBOutlet UITableView *EventListTblVw;
- (IBAction)validate:(id)sender;
- (IBAction)check:(id)sender;
@end
