//
//  AboutUsTableViewCell.h
//  eMunching
//
//  Created by Ranjit Kadam on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FontLabel;

@interface AboutUsTableViewCell : UITableViewCell 
{
    FontLabel *m_aboutUsTitle;
    UIImageView *m_titleBackground;
 
}

@property (nonatomic,retain) IBOutlet FontLabel *aboutUsTitle;
@property (nonatomic, retain) IBOutlet UIImageView *titleBackground;


@end
