//
//  AppToolBox.h
//  SigmaBioMedical
//

//  Created by Debasish Pal on 05/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppToolBox : NSObject
{

}

+ (void)setLabel:(UILabel *)theLabel;
+ (void)setTextField:(UITextField *)textField;
+ (UIButton *)createImgButtonWithFrame:(CGRect)frame withImages:(NSArray *)array;
+ (UIButton *)createRoundedButtonWithFrame:(CGRect)frame withText:(NSString *)text;
+ (UIImage *)getImageFromAppBundle : (NSString *) imgName ;
+ (CGFloat)heightForText:(NSString*) theText withFont:(UIFont*) theFont LineBreakMode:(UILineBreakMode)lbm maxSize:(CGSize)size;
+ (NSString *)trimWhiteSpace:(NSString *)str;
+ (UITableView *) createTableViewWithFrame:(CGRect)frame;
+ (void)printOnDebugMode:(NSString *)str;
+ (UIView *)setSelectedBGColor;
+ (NSString *)getDoccumentPath:(NSString *)docName;

@end
