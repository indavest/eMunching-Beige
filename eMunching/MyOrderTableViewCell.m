//
//  MyOrderTableViewCell.m
//  eMunching
//
//  Created by Andrew Green on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyOrderTableViewCell.h"
#import "RoundCorneredUIImageView.h"
#import "FontLabel.h"
#import "Objects.h"

@implementation MyOrderTableViewCell

@synthesize backgroundImage     = m_backgroundImage;

@synthesize dishThumbnail       = m_dishThumbnail;
@synthesize dishQuantity        = m_dishQuantity;
@synthesize dishTitle           = m_dishTitle;
@synthesize dishTotal           = m_dishTotal;
@synthesize strikeThrough       = m_strikeThrough;
@synthesize actualDishTotal     = m_actualDishTotal;
@synthesize menuItem            = m_menuItem;

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

- (void) setup
{
    [m_dishThumbnail roundEdgesToRadius:10];
    if ([m_menuItem dishPicture])
    {
        [m_dishThumbnail setImage:[m_menuItem dishPicture]];
    }
    else
    {
        [m_dishThumbnail setImage:[UIImage imageNamed:@"blank_loading.png"]];
    }

    [m_dishTitle setTextColor:TEXTCOLOR1];
    [m_dishTitle setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:17.0f]];
    [m_dishTitle setText:[m_menuItem dishTitle]];
    
    [m_dishQuantity setTextColor:TEXTCOLOR1];
    [m_dishQuantity setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]]; 
    [m_dishQuantity setText:[[NSString stringWithFormat:@"QUANTITY - "]stringByAppendingString:[m_menuItem dishQuantity]]];    
    
    [m_dishTotal setTextColor:TEXTCOLOR1];
    [m_dishTotal setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];
    [m_actualDishTotal setTextColor:TEXTCOLOR1];
    [m_actualDishTotal setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];

    //Resizing the cell on editmode
    m_dishTitle.autoresizingMask       = UIViewAutoresizingFlexibleWidth;
    m_dishQuantity.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
    m_dishTotal.autoresizingMask       = UIViewAutoresizingFlexibleLeftMargin;
    m_actualDishTotal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    m_strikeThrough.autoresizingMask   = UIViewAutoresizingFlexibleLeftMargin;
    m_backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    if([[m_menuItem dishDiscountPrice]isEqualToString:@"0"])
    {
        float actualTotal = [[m_menuItem dishQuantity] floatValue] * [[m_menuItem dishPrice] floatValue];
        [m_dishTotal setText:[NSString stringWithFormat:CURRENCY "%.2f",actualTotal]]; 
    }
    else
    {
        float discountTotal = [[m_menuItem dishQuantity] floatValue] * [[m_menuItem dishDiscountPrice] floatValue];
        [m_dishTotal setText:[NSString stringWithFormat:CURRENCY "%.2f",discountTotal]];
        
        float actualTotal = [[m_menuItem dishQuantity] floatValue] * [[m_menuItem dishPrice] floatValue];
        [m_actualDishTotal setText:[NSString stringWithFormat:CURRENCY "%.2f",actualTotal]];        
        
        m_strikeThrough.hidden = false;
    }
}

@end
