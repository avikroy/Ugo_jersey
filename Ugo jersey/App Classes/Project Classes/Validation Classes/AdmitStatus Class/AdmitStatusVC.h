//
//  AdmitStatusVC.h
//  Ugo jersey
//
//  Created by Debasish Pal on 31/07/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "BaseViewController.h"

@interface AdmitStatusVC : BaseViewController
@property(retain,nonatomic)NSString *strStatus;
@property(retain,nonatomic)NSString *navStatus;
@property (retain, nonatomic) IBOutlet UIImageView *AdmitStatusImgVw;
@property (retain, nonatomic) IBOutlet UILabel *AdmitStatusLbl;
- (IBAction)validate:(id)sender;
- (IBAction)check:(id)sender;
- (IBAction)scanOtherCustAction:(id)sender;

@end
