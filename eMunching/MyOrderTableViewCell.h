//
//  MyOrderTableViewCell.h
//  eMunching
//
//  Created by Andrew Green on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoundCorneredUIImageView;
@class FontLabel;
@class MenuItem;

@interface MyOrderTableViewCell : UITableViewCell
{
    UIImageView *m_backgroundImage;
    
    RoundCorneredUIImageView *m_dishThumbnail;
    FontLabel *m_dishTitle;
    FontLabel *m_dishQuantity;
    FontLabel *m_dishTotal;
    UIImageView *m_strikeThrough;
    FontLabel *m_actualDishTotal;
    
    MenuItem  *m_menuItem;    
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, retain) IBOutlet RoundCorneredUIImageView *dishThumbnail;
@property (nonatomic, retain) IBOutlet FontLabel *dishTitle;
@property (nonatomic, retain) IBOutlet FontLabel *dishQuantity;
@property (nonatomic, retain) IBOutlet FontLabel *dishTotal;
@property (nonatomic, retain) IBOutlet UIImageView *strikeThrough;
@property (nonatomic, retain) IBOutlet FontLabel *actualDishTotal;

@property (nonatomic, retain) MenuItem *menuItem;

- (void) setup;


@end
