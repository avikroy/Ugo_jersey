//
//  PreAdmittedVC.m
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "PreAdmittedVC.h"
#import "EventListVC.h"
#import "AdmitStatusVC.h"
@interface PreAdmittedVC ()

@end

@implementation PreAdmittedVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone) nibNameOrNil = @"PreAdmittedVC_iPhone";
    
    else if (family == iPhone5) nibNameOrNil = @"PreAdmittedVC";
    else nibNameOrNil = @"PreAdmittedVC_iPad";
    
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
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES animated:NO];
   
    [self createNavigationView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIButton Selector
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)admitAgainAction:(id)sender
{
    AdmitStatusVC *adminStat = [[AdmitStatusVC alloc] init];
    adminStat.strStatus=@"allow";
    adminStat.navStatus=@"validate";
    [self.navigationController pushViewController:adminStat animated:YES];
    [adminStat release];
}

- (IBAction)declineAction:(id)sender
{
    AdmitStatusVC *adminStat = [[AdmitStatusVC alloc] init];
    adminStat.strStatus=@"decline";
    adminStat.navStatus=@"validate";
    [self.navigationController pushViewController:adminStat animated:YES];
    [adminStat release];
}

#pragma mark - UIBottom Tabbar Buttons Selector
- (IBAction)validate:(id)sender
{
}

- (IBAction)check:(id)sender
{
    EventListVC *eventlist = [[EventListVC alloc] init];
    [self.navigationController pushViewController:eventlist animated:YES];
    [eventlist release];
}
@end
