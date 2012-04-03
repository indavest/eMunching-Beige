//
//  SpecialTableViewCell.h
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FontLabel;
@class RoundCorneredUIImageView;

@interface SpecialTableViewCell : UITableViewCell
{
    FontLabel *m_specialTitle;
    FontLabel *m_specialDescription;
    RoundCorneredUIImageView *m_specialImage;
    UIImageView *m_titleBackground;
}

@property (nonatomic, retain) IBOutlet FontLabel *specialTitle;
@property (nonatomic, retain) IBOutlet FontLabel *specialDescription;
@property (nonatomic, retain) IBOutlet RoundCorneredUIImageView *specialImage;
@property (nonatomic, retain) IBOutlet UIImageView *titleBackground;

- (void) reverseLocations;

@end
