//
//  EventTableViewCell.m
//  eMunching
//
//  Created by Ranjit Kadam on 06/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventTableViewCell.h"


@implementation EventTableViewCell

@synthesize backgroundImage = m_backgroundImage;

@synthesize eventName = m_eventName;
@synthesize eventDesc = m_eventDesc;
@synthesize eventDate = m_eventDate;
@synthesize eventTime = m_eventTime;


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

- (void)dealloc
{
    [super dealloc];
}

@end
