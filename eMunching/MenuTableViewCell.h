//
//  MenuTableViewCell.h
//  eMunching
//
//  Created by Ranjit Kadam on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FontLabel;
@class RoundCorneredUIImageView;

@interface MenuTableViewCell : UITableViewCell 
{
    
    FontLabel *m_menuTitle;
    RoundCorneredUIImageView *m_menuImage;
    UIImageView *m_titleBackground;

}

@property (nonatomic, retain) IBOutlet FontLabel *menuTitle;
@property (nonatomic, retain) IBOutlet RoundCorneredUIImageView *menuImage;
@property (nonatomic, retain) IBOutlet UIImageView *titleBackground;


@end
