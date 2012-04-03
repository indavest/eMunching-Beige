//
//  HotDealsViewCell.m
//  eMunching
//
//  Created by Ranjit Kadam on 03/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HotDealsViewCell.h"

@implementation HotDealsViewCell

@synthesize backgroundImage = m_backgroundImage;
@synthesize dealTitle       = m_dealsTitle;
@synthesize dealStart       = m_dealStart;
@synthesize dealExpire      = m_dealExpire;

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

@end
