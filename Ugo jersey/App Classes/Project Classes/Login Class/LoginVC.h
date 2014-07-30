//
//  LoginVC.h
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "BaseViewController.h"
#import "ConnectionModel.h"

#import <FacebookSDK/FacebookSDK.h>

@interface LoginVC : BaseViewController<UITextFieldDelegate,connectionDidReceiveResponse>

@property (retain, nonatomic) IBOutlet UITextField *UserIDTxtFd;
@property (retain, nonatomic) IBOutlet UITextField *PwdTxtFd;

- (IBAction)submitAction:(id)sender;
-(void)createConnectionLogin;
@end
