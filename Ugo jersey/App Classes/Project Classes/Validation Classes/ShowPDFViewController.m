//
//  ShowPDFViewController.m
//  Ugo jersey
//
//  Created by Avik Roy on 2/22/14.
//  Copyright (c) 2014 Debasish Pal. All rights reserved.
//

#import "ShowPDFViewController.h"
#import "AppToolBox.h"
#import "BlockAlertView.h"
@interface ShowPDFViewController ()

@end

@implementation ShowPDFViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Devicefamily family = thisDeviceFamily();
    if (family == iPhone) 
    {
        
    }
    else if (family == iPhone5)
    {
        
    }
    else
    {
         self.btnSave.frame=CGRectMake(self.btnSave.frame.origin.x+150, self.btnSave.frame.origin.y,234,48);
        self.btnPrint.frame=CGRectMake(self.btnPrint.frame.origin.x+225,self.btnSave.frame.origin.y,234,48);
    }
    NSString *pdfFilePath=[AppToolBox getDoccumentPath:[NSString stringWithFormat:@"%@.pdf",@"ticket"]];
    NSURL *url = [NSURL fileURLWithPath:pdfFilePath];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self createNavigationView];
}


- (void)dealloc {
    [_webview release];
    [super dealloc];
}

-(void)createNavigationView
{
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    
    /*UIImage *imgLogo = [UIImage imageNamed: @"applogo.png"];
     UIImageView *LogoImgvw = [[UIImageView alloc] initWithImage: imgLogo];
     LogoImgvw.frame=CGRectMake(0,0,150,30);
     self.navigationItem.titleView = LogoImgvw;*/
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0,0,32,17);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back_img.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btnBack] autorelease];
    
    UILabel *lblHeading=[[UILabel alloc] initWithFrame:CGRectMake(60, 6, 160,32)];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.text=@"UGOjersey";
    lblHeading.textColor=[UIColor whiteColor];
    lblHeading.font=[UIFont boldSystemFontOfSize:20];
    [lblHeading setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView=lblHeading;
    
    /* UIButton *btnLogOut=[UIButton buttonWithType:UIButtonTypeCustom];
     [btnLogOut setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
     [btnLogOut setFrame:CGRectMake(0, 3, 76, 37)];
     [btnLogOut addTarget:self action:@selector(LogOutAction) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btnLogOut] autorelease];*/
    
    UIToolbar *toolsBar = [[UIToolbar alloc]
                           initWithFrame:CGRectMake(0.0f, 0.0f, 90.0f, 44.01f)];
    toolsBar.clearsContextBeforeDrawing = NO;
    toolsBar.clipsToBounds = NO;
    toolsBar.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f];
    toolsBar.barStyle = -1; // clear background
    
    NSMutableArray *buttonsArr = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIButton *btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRefresh.frame = CGRectMake(0,0,30,30);
    [btnRefresh setBackgroundImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [btnRefresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* barBtnItemLeft=[[UIBarButtonItem alloc] initWithCustomView:btnRefresh];
    [buttonsArr addObject:barBtnItemLeft];
    [barBtnItemLeft release];
    
    // Create a spacer
    UIBarButtonItem *barBtnItemMid = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barBtnItemMid.width = 5.0f;
    [buttonsArr addObject:barBtnItemMid];
    [barBtnItemMid release];
    
    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogout.frame = CGRectMake(30,0,30,30);
    [btnLogout setBackgroundImage:[UIImage imageNamed:@"logout_img.png"] forState:UIControlStateNormal];
    [btnLogout addTarget:self action:@selector(LogOutAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* barBtnItemRight=[[UIBarButtonItem alloc] initWithCustomView:btnLogout];
    [buttonsArr addObject:barBtnItemRight];
    [barBtnItemRight release];
    
    // Add buttons to toolbar and toolbar to nav bar
    [toolsBar setItems:buttonsArr animated:NO];
    [buttonsArr release];
    UIBarButtonItem *twoRightBtns = [[UIBarButtonItem alloc] initWithCustomView:toolsBar];
    [toolsBar release];
    self.navigationItem.rightBarButtonItem = twoRightBtns;
    [twoRightBtns release];
}


#pragma mark - UIButton Selector
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnActionSave:(id)sender {
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"PDF was saved successfully"];
    [alert setCancelButtonWithTitle:@"Ok" block:nil];
    [alert show];

}

- (IBAction)btnActionPrint:(id)sender {
    
    NSString *pdfFilePath=[AppToolBox getDoccumentPath:[NSString stringWithFormat:@"%@.pdf",@"ticket"]];
    NSURL *url = [NSURL fileURLWithPath:pdfFilePath];
    NSData *myPDFData=[NSData dataWithContentsOfURL:url];

    
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    if(pic && [UIPrintInteractionController canPrintData: myPDFData] ) {
        
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [pdfFilePath lastPathComponent];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = myPDFData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            //self.content = nil;
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        
        [pic presentAnimated:YES completionHandler:completionHandler];
        
    }

            
}
@end
