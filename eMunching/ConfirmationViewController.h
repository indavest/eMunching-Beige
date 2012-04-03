//
//  ConfirmationViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 27/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"

@interface ConfirmationViewController : UIViewController<NSXMLParserDelegate> 
{
    
    UINavigationBar *m_navBar;
    
    FontLabel    *m_confirmationPrompt;
    FontLabel    *m_confirmationCodeHeader;
    UITextField  *m_confirmationCode;
    
    NSMutableData           *m_fetchedResults;
    NSMutableString         *m_workingPropertyString;
    NSString                *m_authenticationStatusString;
    BOOL                    m_storingCharacterData;
    
    UIActivityIndicatorView *m_activityIndicator;  
}
@property (nonatomic,retain) IBOutlet UINavigationBar *navBar;

@property (nonatomic,retain) IBOutlet FontLabel   *confirmationPrompt;
@property (nonatomic,retain) IBOutlet FontLabel   *confirmationCodeHeader;
@property (nonatomic,retain) IBOutlet UITextField *confirmationCode;

@property (nonatomic, retain) NSMutableData     *fetchedResults;
@property (nonatomic, retain) NSMutableString   *workingPropertyString;
@property (nonatomic ,retain) NSString          *authenticationStatusString;
@property (nonatomic, assign) BOOL              storingCharacterData;

@end
