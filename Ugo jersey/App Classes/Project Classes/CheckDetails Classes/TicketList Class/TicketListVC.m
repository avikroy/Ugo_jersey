//
//  TicketListVC.m
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "TicketListVC.h"
#import "TicketEntryVC.h"
#import "TicketListTableVwCell.h"
#import "TicketDetailsVC+Check.h"
#import "Ticket.h"
#import "DBManager.h"

@interface TicketListVC ()

@end

@implementation TicketListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone) nibNameOrNil = @"TicketListVC_iPhone";
    
    else if (family == iPhone5) nibNameOrNil = @"TicketListVC";
    else nibNameOrNil = @"TicketListVC_iPad";
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone || family == iPhone5)
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"inner-bg-small.png"] ];
    }
    else if (family == iPad)
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"inner-small.png"] ];
    }

    self.lblEventNm.text=self.event_Nm_Str;
    self.lblDate.text=self.event_Dt_Str;
    
    self.arrData=[[NSMutableArray alloc] initWithArray:[DBManager getTicketsForEvent:self.event_ID_Str]];
    
    [self createSearch];
   
//    [[self.searchTable.subviews objectAtIndex:0] removeFromSuperview];
   // [self.searchTable setFrame:CGRectMake(self.searchTable.frame.origin.x, self.searchTable.frame.origin.y, self.searchTable.frame.size.width-100.0, self.searchTable.frame.size.height)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self createNavigationView];
}

#pragma mark - Create Search method

-(void)createSearch
{
    secContent = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
	
	int count = 0;
    
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    for(int i=0;i<[self.arrData count];i++)
	{
        Ticket *obj=(Ticket *)[self.arrData objectAtIndex:i];
        [searchArray addObject:obj];
        [obj release];
        obj=nil;
	}
    NSLog(@"searchArray=%@",searchArray);
    sortedArray = [searchArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Ticket *fbf1=(Ticket *)obj1;
        Ticket *fbf2=(Ticket *)obj2;
        NSLog(@"fb1=%@",fbf1.ticket_holder_surname);
        return [fbf1.ticket_holder_surname caseInsensitiveCompare:fbf2.ticket_holder_surname];
    }];
     NSLog(@"sortedArray=%@",sortedArray);
    [searchArray release];
	searchArray = nil;
    
    sectionContent=[[NSMutableDictionary alloc]init];
	for(char c = 'A'; c <= 'Z'; c++)
    {
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (int i=0; i < [sortedArray count]; i++)
        {
            NSString *str=[((Ticket*)[sortedArray objectAtIndex:i]).ticket_holder_surname substringToIndex:1];
            NSLog(@"str=%@",str);
            if ([str caseInsensitiveCompare:[NSString stringWithFormat:@"%c",c]] == NSOrderedSame)
            {
                [tempArr addObject:[sortedArray objectAtIndex:i]];
            }
        }
         NSLog(@"tempArr=%@",tempArr);
        NSString *key = (NSString *)[secContent objectAtIndex:count++];
        [sectionContent setValue:tempArr forKey:key];
        [tempArr release];
    }
    NSLog(@"sectioncontent is %@",sectionContent);
    
    [self.TicketListTblVw reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketListTableVwCell *cell=nil;
    NSArray *nib=nil;
    Devicefamily family = thisDeviceFamily();
    if (family == iPad)
        nib=[[ NSBundle  mainBundle]loadNibNamed:@"TicketListTableVwCell_iPad" owner:self options:nil];
    else
        nib=[[ NSBundle  mainBundle]loadNibNamed:@"TicketListTableVwCell" owner:self options:nil];
    
    Ticket *aTicket=[[sectionContent objectForKey:[NSString stringWithFormat:@"%@",[secContent objectAtIndex:indexPath.section]]] objectAtIndex:indexPath.row];
    cell=(TicketListTableVwCell*)[nib objectAtIndex:0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.NameLbl.text=aTicket.ticket_holder_name;
    cell.NumberLbl.text=aTicket.ticket_unique_id;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketDetailsVC_Check *ticketDet = [[TicketDetailsVC_Check alloc] init];
    ticketDet.ticket=(Ticket *)[[sectionContent objectForKey:[NSString stringWithFormat:@"%@",[secContent objectAtIndex:indexPath.section]]] objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:ticketDet animated:YES];
    [ticketDet release];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
    
    for(char c = 'A'; c <= 'Z'; c++) [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
    
    return [toBeReturned autorelease];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [secContent count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sectionContent objectForKey:[NSString stringWithFormat:@"%@",[secContent objectAtIndex:section]]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [secContent objectAtIndex:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self tableView:tableView titleForHeaderInSection:section] != nil)
	{
        Devicefamily family = thisDeviceFamily();
        if (family == iPhone || family == iPhone5)
        {
            return SectionHeaderHeight_iPhone;
        }
        else if (family == iPad)
        {
            return SectionHeaderHeight_iPad;
        }
    }
	else
	{
		return 0;
	}
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
	if (sectionTitle == nil)
    {
		return nil;
	}
    Devicefamily family = thisDeviceFamily();
    
    UIView *vwBG = [[UIView alloc] init];
   vwBG.layer.borderWidth=2.0;
    vwBG.layer.borderColor=[UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:0.0/255.0 alpha:1.0].CGColor;
	vwBG.backgroundColor = [UIColor whiteColor];
    
    UILabel *lblSecHeading = [[[UILabel alloc] init] autorelease];
	lblSecHeading.backgroundColor = [UIColor clearColor];
	lblSecHeading.shadowColor = [UIColor grayColor];
	lblSecHeading.shadowOffset = CGSizeMake(0.0, 1.0);
	lblSecHeading.text = [secContent objectAtIndex:section];
    if (family == iPhone || family == iPhone5)
    {
      lblSecHeading.frame = CGRectMake(20, 0, 310, SectionHeaderHeight_iPhone);
      lblSecHeading.font = [UIFont boldSystemFontOfSize:12];
      vwBG.frame=CGRectMake(0, 0, 310, SectionHeaderHeight_iPhone);
      vwBG.layer.cornerRadius=5.0;
    }
    else if (family == iPad)
    {
      lblSecHeading.frame = CGRectMake(20, 0, 630, SectionHeaderHeight_iPad);
      lblSecHeading.font = [UIFont boldSystemFontOfSize:18];
      vwBG.frame=CGRectMake(0, 0, 630, SectionHeaderHeight_iPad);
       vwBG.layer.cornerRadius=8.0;
    }
    [vwBG autorelease];
    [vwBG addSubview:lblSecHeading];
    
    return vwBG;
}

#pragma mark - UIButton Selector
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIBottom Tabbar Buttons Selector
- (IBAction)validate:(id)sender
{
    TicketEntryVC *ticketentry = [[TicketEntryVC alloc] init];
    [self.navigationController pushViewController:ticketentry animated:YES];
    [ticketentry release];
}

- (IBAction)check:(id)sender
{
}

#pragma mark - UISearchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
for(id subview in [self.searchTable subviews])
{
    if ([subview isKindOfClass:[UIButton class]]) {
        [subview setEnabled:YES];
    }
}
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    for(id subview in [self.searchTable subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    for(id subview in [self.searchTable subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
    [self performSelector:@selector(cancel) withObject:nil afterDelay:0.1];
    return YES;
}
- (void)cancel
{
    for(id subview in [self.searchTable subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    for(id subview in [self.searchTable subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    for(id subview in [self.searchTable subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    for(id subview in [self.searchTable subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    int count = 0;
    [searchBar resignFirstResponder ];
    for(id subview in [self.searchTable subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    for(int i=0;i<[self.arrData count];i++)
	{
        Ticket *obj=(Ticket *)[self.arrData objectAtIndex:i];
        [searchArray addObject:obj];
        [obj release];
        obj=nil;
	}
    
    NSMutableArray * array = [NSMutableArray array];
    for (Ticket * object in searchArray) {
        if ([[[object ticket_holder_firstname] uppercaseString] rangeOfString:[searchBar.text uppercaseString]].location != NSNotFound){
            [array addObject:object];
        }
        if ([[[object ticket_holder_surname] uppercaseString] rangeOfString:[searchBar.text uppercaseString]].location != NSNotFound){
            [array addObject:object];
        }
           
 //        if ([[object ticket_holder_firstname] caseInsensitiveCompare: searchBar.text] == NSOrderedSame) {
//            [array addObject:object];
//
//        }
//        if ([[object ticket_holder_firstname] isEqualToString:searchBar.text]) {
//            [array addObject:object];
//        }
    }
    sortedArray=[[NSArray alloc] initWithArray:array];
    sectionContent=[[NSMutableDictionary alloc]init];
	for(char c = 'A'; c <= 'Z'; c++)
    {
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (int i=0; i < [sortedArray count]; i++)
        {
            NSString *str=[((Ticket*)[sortedArray objectAtIndex:i]).ticket_holder_surname substringToIndex:1];
            NSLog(@"str=%@",str);
            if ([str caseInsensitiveCompare:[NSString stringWithFormat:@"%c",c]] == NSOrderedSame)
            {
                [tempArr addObject:[sortedArray objectAtIndex:i]];
            }
        }
        NSLog(@"tempArr=%@",tempArr);
        NSString *key = (NSString *)[secContent objectAtIndex:count++];
        [sectionContent setValue:tempArr forKey:key];
        [tempArr release];
    }
    NSLog(@"sectioncontent is %@",sectionContent);
    
    [self.TicketListTblVw reloadData];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    for(id subview in [self.searchTable subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    for(id subview in [self.searchTable subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
    self.searchTable.text=@"";
   [self createSearch]; 
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar 
{
    for(id subview in [self.searchTable subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope 
{
    for(id subview in [self.searchTable subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
}

- (void)dealloc
{
    [_TicketListTblVw release];
    [_lblEventNm release];
    [_lblDate release];
    if(sectionContent)
    {
        [sectionContent release];
        sectionContent=nil;
    }
    if(secContent)
    {
        [secContent release];
        secContent=nil;
    }
    [_searchTable release];
    [super dealloc];
}
@end
