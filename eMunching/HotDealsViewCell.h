//
//  HotDealsViewCell.h
//  eMunching
//
//  Created by Ranjit Kadam on 03/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FontLabel.h"

@interface HotDealsViewCell : UITableViewCell
{

    UIImageView  *m_backgroundImage;
    
    FontLabel * m_dealTitle;
    FontLabel * m_dealStart;
    FontLabel * m_dealExpire;       
}

@property (nonatomic ,retain) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, retain) IBOutlet FontLabel *dealTitle;
@property (nonatomic, retain) IBOutlet FontLabel *dealStart;
@property (nonatomic, retain) IBOutlet FontLabel *dealExpire;

@end
