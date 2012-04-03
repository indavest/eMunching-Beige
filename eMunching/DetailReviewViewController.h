//
//  DetailReviewViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 30/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "Objects.h"

@interface DetailReviewViewController : UIViewController 
{
    NSString   *m_pageToDisplay;

    UITextView *m_detailReview;
    FontLabel  *m_reviewerName;
    
    UIImageView *m_star1;
    UIImageView *m_star2;
    UIImageView *m_star3;
    UIImageView *m_star4;
    UIImageView *m_star5;
    
    Review     *m_reviewDetail;
    MenuItem   *m_menuItem;
}

@property (nonatomic, assign) NSString *pageToDisplay;

@property (nonatomic, retain) IBOutlet UITextView *detailReview;
@property (nonatomic, retain) IBOutlet FontLabel  *reviewerName;

@property (nonatomic, retain) IBOutlet UIImageView *star1;
@property (nonatomic, retain) IBOutlet UIImageView *star2;
@property (nonatomic, retain) IBOutlet UIImageView *star3;
@property (nonatomic, retain) IBOutlet UIImageView *star4;
@property (nonatomic, retain) IBOutlet UIImageView *star5;

@property (nonatomic, retain) Review   *reviewDetail;
@property (nonatomic, retain) MenuItem *menuItem;

@end
