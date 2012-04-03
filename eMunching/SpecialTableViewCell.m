//
//  SpecialTableViewCell.m
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpecialTableViewCell.h"
#import "FontLabel.h"
#import "RoundCorneredUIImageView.h"

@implementation SpecialTableViewCell

@synthesize specialTitle = m_specialTitle;
@synthesize specialDescription = m_specialDescription;
@synthesize specialImage = m_specialImage;
@synthesize titleBackground = m_titleBackground;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code.
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)dealloc 
{
    [super dealloc];
}

#pragma mark -
#pragma mark Reverse
- (void) reverseLocations
{
    // Get original locations
    CGPoint backgroundOriginalOrigin = CGPointMake(m_titleBackground.frame.origin.x, 
                                                   m_titleBackground.frame.origin.y);
    
    // Swap origins
    [m_specialImage setFrame:CGRectMake(backgroundOriginalOrigin.x, 
                                        backgroundOriginalOrigin.y, 
                                        m_specialImage.frame.size.width, 
                                        m_specialImage.frame.size.height)];
    
    [m_titleBackground setFrame:CGRectMake(m_titleBackground.frame.origin.x + 130,
                                           m_titleBackground.frame.origin.y, 
                                           m_titleBackground.frame.size.width,
                                           m_titleBackground.frame.size.height)];
    [m_specialTitle setFrame:CGRectMake(m_specialTitle.frame.origin.x + 130, 
                                        m_specialTitle.frame.origin.y, 
                                        m_specialTitle.frame.size.width, 
                                        m_specialTitle.frame.size.height)];
    [m_specialDescription setFrame:CGRectMake(m_specialDescription.frame.origin.x + 130, 
                                              m_specialDescription.frame.origin.y, 
                                              m_specialDescription.frame.size.width, 
                                              m_specialDescription.frame.size.height)];
}

@end
