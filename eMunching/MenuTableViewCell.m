//
//  MenuTableViewCell.m
//  eMunching
//
//  Created by Ranjit Kadam on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "FontLabel.h"
#import "RoundCorneredUIImageView.h"


@implementation MenuTableViewCell

@synthesize menuTitle = m_menuTitle;
@synthesize menuImage = m_menuImage;
@synthesize titleBackground = m_titleBackground;

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
