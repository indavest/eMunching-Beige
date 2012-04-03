//
//  FbTweetViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 12/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController<UIWebViewDelegate> 
{
    UIWebView *m_webView;
    UIActivityIndicatorView *m_activityIndicator;
    NSString      *m_displayPage;
    NSString      *m_contentToDisplay;
    NSString      *m_hotDealTitle;
    NSString      *m_eventTitle;
    
    
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) NSString *displayPage;
@property (nonatomic, retain) NSString *contentToDisplay;
@property (nonatomic, retain) NSString *hotDealTitle;
@property (nonatomic, retain) NSString *eventTitle;

@end
