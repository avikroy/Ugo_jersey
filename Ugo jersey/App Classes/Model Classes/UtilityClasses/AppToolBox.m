//
//  AppToolBox.m
//  SigmaBioMedical
//
//  Created by Debasish Pal on 05/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppToolBox.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppToolBox

+ (NSString *)getDoccumentPath:(NSString *)docName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *pdfFilePath = [documentsDirectory stringByAppendingPathComponent:docName];
    return pdfFilePath;
}

#pragma mark -
#pragma mark <create label>

+ (void)setLabel:(UILabel *)theLabel
{
	theLabel.backgroundColor = [UIColor clearColor];
	theLabel.textColor=[UIColor blackColor];
    theLabel.autoresizingMask=UIViewAutoresizingNone;
	//theLabel.lineBreakMode = UILineBreakModeWordWrap;
	//theLabel.numberOfLines=0;
//    theLabel.backgroundColor=[UIColor yellowColor];
	theLabel.textAlignment = NSTextAlignmentLeft;
	theLabel.font=[UIFont systemFontOfSize:15];
}


#pragma mark -
#pragma mark <create text box>

+ (void)setTextField:(UITextField *)textField
{
	textField.textAlignment = NSTextAlignmentLeft;
    textField.layer.borderColor=[[UIColor  colorWithRed:204.0/255.0 green:204.0/255.0 blue:203.0/255.0 alpha:1] CGColor];
    textField.backgroundColor=[UIColor whiteColor];
    textField.layer.borderWidth=1.0;
    //textField.textAlignment=UITextAlignmentLeft;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //textField.borderStyle = UITextBorderStyleRoundedRect;
	textField.autocorrectionType=UITextAutocorrectionTypeNo;
	textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;	
}


#pragma mark -
#pragma mark <create image button>

+(UIButton *)createImgButtonWithFrame:(CGRect)frame withImages:(NSArray *)array
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
    button.frame = frame;
    button.showsTouchWhenHighlighted=YES;
	
	if([array count]!=0)
	{	
		[button setBackgroundImage:[UIImage imageNamed:[array objectAtIndex:0]] forState:UIControlStateNormal];	
	}
	
	if([array count]==2)
	{	
		[button setBackgroundImage:[UIImage imageNamed:[array objectAtIndex:1]] forState:UIControlStateSelected];
	}
	
	return button;
	
}

#pragma mark -
#pragma mark <create rounded button>

+(UIButton *)createRoundedButtonWithFrame:(CGRect)frame withText:(NSString *)text 
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    button.frame = frame;
	[button setTitle:text forState:UIControlStateNormal];
	return button;
	
}

#pragma mark -
#pragma mark <get application images from bundle>

+ (UIImage *)getImageFromAppBundle : (NSString *) imgName 
{
    UIImage *image= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:@"png"]];
    return image;
}

#pragma mark -
#pragma mark <get height for text>

+ (CGFloat) heightForText:(NSString*) theText withFont:(UIFont*) theFont LineBreakMode:(UILineBreakMode)lbm maxSize:(CGSize)size
{
	CGSize maximumLabelSize = size;
	
	CGSize expectedLabelSize = [theText sizeWithFont:theFont
                                   constrainedToSize:maximumLabelSize
                                       lineBreakMode:lbm];
	
	return expectedLabelSize.height;
}

#pragma mark -
#pragma mark - trim white space 

+ (NSString *)trimWhiteSpace:(NSString *)str
{
    NSString *trimmedString = [str stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    return trimmedString;
}

#pragma mark -
#pragma mark <create Tableview>

+ (UITableView *) createTableViewWithFrame:(CGRect)frame
{
    UITableView *tableView= [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [tableView setSeparatorColor:[UIColor grayColor]];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.scrollEnabled = NO;
    return tableView;
}

#pragma mark - print on debug mode

+ (void)printOnDebugMode:(NSString *)str
{
#ifdef DEBUG
    NSLog(@"%@",str);
#endif
}

#pragma mark - set selected cell back ground color

+ (UIView *)setSelectedBGColor
{
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor clearColor]];
    bgColorView.layer.borderWidth=1.0;
    bgColorView.layer.borderColor=[[UIColor colorWithRed:100.0/255.0 green:217.0/255.0 blue:255.0/255.0 alpha:1.0] CGColor];
    return [bgColorView autorelease];  
}


@end
