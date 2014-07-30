//
//  CustomActivityIndicator.h
//  CardioMonitore_App
//
//  Created by Avik on 04/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActivityIndicator : UIView
{
    UILabel *lblLoadingView;
    UIActivityIndicatorView *spinner;
}

- (void) startLoading;
- (void) stopLoading;

@end
