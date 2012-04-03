//
//  MyReviewTableViewCell.m
//  eMunching
//
//  Created by Ranjit Kadam on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyReviewTableViewCell.h"
#import "FontLabel.h"


@implementation MyReviewTableViewCell

@synthesize reviewData      = m_reviewData;
@synthesize reviewName      = m_reviewName;
@synthesize backgroundImage = m_backgroundImage;

@synthesize star1           = m_star1;
@synthesize star2           = m_star2;
@synthesize star3           = m_star3;
@synthesize star4           = m_star4;
@synthesize star5           = m_star5;


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


- (void) reverseLocations
{
    // Get original locations
    CGPoint backgroundOriginalOrigin = CGPointMake(m_reviewData.frame.origin.x, 
                                                   m_reviewData.frame.origin.y);
    
    // Swap origins
  
    
    [m_backgroundImage setFrame:CGRectMake(m_backgroundImage.frame.origin.x + 85,
                                      m_backgroundImage.frame.origin.y, 
                                      m_backgroundImage.frame.size.width,
                                      m_backgroundImage.frame.size.height)];
    
    [m_reviewName setFrame:CGRectMake(backgroundOriginalOrigin.x, 
                                        m_reviewName.frame.origin.y, 
                                        m_reviewName.frame.size.width, 
                                        m_reviewName.frame.size.height)];
    
             
    [m_reviewData setFrame:CGRectMake(m_reviewData.frame.origin.x + 95,
                                           m_reviewData.frame.origin.y, 
                                           m_reviewData.frame.size.width,
                                           m_reviewData.frame.size.height)];

    
    [m_star1     setFrame:CGRectMake(backgroundOriginalOrigin.x, 
                                      m_star1.frame.origin.y, 
                                      m_star1.frame.size.width, 
                                      m_star1.frame.size.height)];
    
    [m_star2    setFrame:CGRectMake(backgroundOriginalOrigin.x+13, 
                                     m_star2.frame.origin.y, 
                                     m_star2.frame.size.width, 
                                     m_star2.frame.size.height)];
    
    [m_star3     setFrame:CGRectMake(backgroundOriginalOrigin.x+26, 
                                     m_star3.frame.origin.y, 
                                     m_star3.frame.size.width, 
                                     m_star3.frame.size.height)];
    
    [m_star4     setFrame:CGRectMake(backgroundOriginalOrigin.x+39, 
                                     m_star4.frame.origin.y, 
                                     m_star4.frame.size.width, 
                                     m_star4.frame.size.height)];
    
    [m_star5     setFrame:CGRectMake(backgroundOriginalOrigin.x+52, 
                                     m_star5.frame.origin.y, 
                                     m_star5.frame.size.width, 
                                     m_star5.frame.size.height)];
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
