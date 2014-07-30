//
//  EventListTableVwCell.m
//  Ugo jersey
//
//  Created by Debasish Pal on 03/08/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "EventListTableVwCell.h"

@implementation EventListTableVwCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
   
    [_EventDateLbl release];
    [_EventNameLbl release];
    [super dealloc];
}
@end
