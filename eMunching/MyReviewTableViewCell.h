//
//  MyReviewTableViewCell.h
//  eMunching
//
//  Created by Ranjit Kadam on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"

@interface MyReviewTableViewCell : UITableViewCell 
{
    FontLabel   *m_reviewData;
    FontLabel   *m_reviewName;
    UIImageView *m_backgroundImage;
   
    UIImageView *m_star1;
    UIImageView *m_star2;
    UIImageView *m_star3;
    UIImageView *m_star4;
    UIImageView *m_star5;

}

@property (nonatomic, retain) IBOutlet FontLabel   *reviewData;
@property (nonatomic, retain) IBOutlet FontLabel   *reviewName;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, retain) IBOutlet UIImageView *star1;
@property (nonatomic, retain) IBOutlet UIImageView *star2;
@property (nonatomic, retain) IBOutlet UIImageView *star3;
@property (nonatomic, retain) IBOutlet UIImageView *star4;
@property (nonatomic, retain) IBOutlet UIImageView *star5;



- (void) reverseLocations;

@end
