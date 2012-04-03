//
//  MyReviewViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"


@interface MyReviewViewController : UIViewController<NSXMLParserDelegate>
{
    UITableView             *m_reviewTable;
    NSMutableArray          *m_userReviews;
    FontLabel               *m_buttonLabel;
    FontLabel               *m_headerLabel;
    
    
    NSMutableData           *m_fetchedResults;
    NSMutableArray          *m_parsedReviews;
    Review                  *m_reviews;
    NSMutableArray          *m_elementsToParse;
    NSMutableString         *m_workingPropertyString;
    BOOL                    m_storingCharacterData;
    
    UIActivityIndicatorView *m_activityIndicator;

}

@property (nonatomic, retain) IBOutlet UITableView *reviewTable;
@property (nonatomic, retain) NSMutableArray       *userReviews;
@property (nonatomic, retain) IBOutlet FontLabel   *buttonLabel;
@property (nonatomic, retain) IBOutlet FontLabel   *headerLabel;



@property (nonatomic, retain) NSMutableData        *fetchedResults;
@property (nonatomic, retain) NSMutableArray       *parsedReviews;
@property (nonatomic, retain) Review               *reviews;
@property (nonatomic, retain) NSMutableArray       *elementsToParse;
@property (nonatomic, retain) NSMutableString      *workingPropertyString;
@property (nonatomic, assign) BOOL                 storingCharacterData;

@end
