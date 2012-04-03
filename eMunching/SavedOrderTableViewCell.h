//
//  SavedOrderTableViewCell.h
//  eMunching
//
//  Created by Ranjit Kadam on 13/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FontLabel;
@class RoundCorneredUIImageView;

@interface SavedOrderTableViewCell : UITableViewCell 
{
    FontLabel    *m_orderGroupTitle;
    FontLabel    *m_orderGroupDateStamp;
    
    UIImageView  *m_backgroundImage;
    
}

@property (nonatomic ,retain) IBOutlet FontLabel   *orderGroupTitle;
@property (nonatomic ,retain) IBOutlet FontLabel   *orderGroupDateStamp;

@property (nonatomic ,retain) IBOutlet UIImageView *backgroundImage;

@end
