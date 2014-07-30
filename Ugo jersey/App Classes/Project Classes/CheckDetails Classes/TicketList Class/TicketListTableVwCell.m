//
//  TicketListTableVwCell.m
//  Ugo jersey
//
//  Created by Debasish Pal on 03/08/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "TicketListTableVwCell.h"

@implementation TicketListTableVwCell

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
    [_NameLbl release];
    [_NumberLbl release];
    [super dealloc];
}
@end
