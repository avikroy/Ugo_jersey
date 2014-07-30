//
//  BaseViewController.h
//  Write Right
//
//  Created by F9 Mac 2 on 25/06/13.
//  Copyright (c) 2013 Sourish Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ConnectionModel.h"
#import "Global.h"
typedef enum {
	iPhone5 = 0,
    iPhone,
    iPad
} Devicefamily;

typedef enum {
    NotAdmitted=0,
	Admitted
    }AdmitStatusList;

@interface BaseViewController : UIViewController<MBProgressHUDDelegate,connectionDidReceiveResponse>
{
    BOOL isLogout;
}
@property (retain,nonatomic) MBProgressHUD *HUD;
Devicefamily thisDeviceFamily();
-(void)createHUD;
-(void)showHUD;
-(void)hideHUD;
-(void)createNavigationView;
-(NSString*)admitStatusForTicket:(AdmitStatusList)admitstatus;
BOOL isNetworkAvailable ();
@end
