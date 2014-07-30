//
//  CreatePDF.h
//  VehicleInspection
//
//  Created by Avik on 10/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CreatePDF : NSObject
{
   
}
-(NSString *) filePath;
+ (void)drawString:(NSString *)str  atRect:(CGRect)rect;
+ (void)drawBoldString:(NSString *)str  atRect:(CGRect)rect;
+ (void)drawHeading:(NSString *)str  atRect:(CGRect)rect;
+ (void)drawRect:(CGRect) rect atContext:(CGContextRef)context;
+ (void)drawLineFromPoint:(CGPoint)startPonit toPoint:(CGPoint)endPoint atContext:(CGContextRef)context;
+ (void)drawImage:(UIImage *)img  atPoint:(CGPoint)point inContext:(CGContextRef)ctx;
+ (void)drawImage:(UIImage *)img  atRect:(CGRect)rect inContext:(CGContextRef)ctx;
+ (void)drawString:(NSString *)str  atRect:(CGRect)rect withColor:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment )alignment;
@end
