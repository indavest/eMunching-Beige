//
//  SavedOrderTableViewCell.m
//  eMunching
//
//  Created by Ranjit Kadam on 13/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavedOrderTableViewCell.h"
#import "FontLabel.h"
#import "RoundCorneredUIImageView.h"


@implementation SavedOrderTableViewCell

@synthesize orderGroupTitle     = m_orderGroupTitle;
@synthesize orderGroupDateStamp = m_orderGroupDateStamp;

@synthesize backgroundImage     = m_backgroundImage;  

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
