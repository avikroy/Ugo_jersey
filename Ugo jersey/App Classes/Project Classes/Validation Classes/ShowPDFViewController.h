//
//  ShowPDFViewController.h
//  Ugo jersey
//
//  Created by Avik Roy on 2/22/14.
//  Copyright (c) 2014 Debasish Pal. All rights reserved.
//

#import "BaseViewController.h"

@interface ShowPDFViewController : BaseViewController<UIPrintInteractionControllerDelegate>
@property (retain, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnPrint;
- (IBAction)btnActionSave:(id)sender;
- (IBAction)btnActionPrint:(id)sender;

@end
