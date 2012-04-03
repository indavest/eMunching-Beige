//
//  SubmitReviewViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface SubmitReviewViewController : UIViewController<NSXMLParserDelegate,RateViewDelegate> 
{
        UITextView *m_reviewText;
        NSString   *m_rating;

        NSMutableData           *m_fetchedResults;
        NSMutableString         *m_workingPropertyString;
        NSString                *m_reviewStatusString;
        BOOL                    m_storingCharacterData;
    
        UIActivityIndicatorView *m_activityIndicator;
        RateView   *m_rateView;
       
}

@property (nonatomic, retain) IBOutlet UITextView *reviewText;
@property (nonatomic, retain) NSString             *rating;

@property (nonatomic, retain) NSMutableData       *fetchedResults;
@property (nonatomic, retain) NSMutableString     *workingPropertyString;
@property (nonatomic, retain) NSString            *reviewStatusString;
@property (nonatomic, assign) BOOL                storingCharacterData;
@property (nonatomic, retain) IBOutlet RateView   *rateView;

@end
