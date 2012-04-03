//
//  SignInViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 26/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "Objects.h"

@interface SignInViewController : UIViewController<NSXMLParserDelegate> 
{
    UINavigationBar *m_navBar;
    
    FontLabel *m_emailHeader;
    FontLabel *m_passwordHeader;
    FontLabel *m_forgotPasswordPrompt;
    FontLabel *m_registerUserPrompt;
    
    UITextField *m_email;
    UITextField *m_password;
    
    FontLabel *m_label1;
    FontLabel *m_label2;
    
    NSString *m_firstName;
    NSString *m_lastName;
    NSString *m_phoneNumber;
    NSString *m_preferredLocation;
    
    NSMutableData           *m_fetchedResults;
    NSMutableData           *m_forgotPasswordFetchedResults;
    NSMutableData           *m_saltStringFetchedResults;
    NSMutableString         *m_workingPropertyString;
   
    NSString                *m_loginStatusString;
    NSString                *m_forgotPasswordStatusString;
    NSString                *m_fetchedSaltString;
    
    BOOL                    m_storingCharacterData;
    BOOL                    m_storingCharacterData1;
    BOOL                    m_stroringCharacterData2;
    
    NSString                *m_serverCallMode;
    
    
    UIActivityIndicatorView *m_activityIndicator;
    
    NSString *m_encryptedPassword;

}
@property (nonatomic,retain) IBOutlet UINavigationBar *navBar;

@property (nonatomic,retain) IBOutlet FontLabel *emailHeader;
@property (nonatomic,retain) IBOutlet FontLabel *passwordHeader;
@property (nonatomic,retain) IBOutlet FontLabel *forgotPasswordPrompt;
@property (nonatomic,retain) IBOutlet FontLabel *registerUserPrompt;

@property (nonatomic,retain) IBOutlet UITextField *email;
@property (nonatomic,retain) IBOutlet UITextField *password;

@property (nonatomic,retain) IBOutlet FontLabel *label1;
@property (nonatomic,retain) IBOutlet FontLabel *label2;

@property (nonatomic,retain) NSString *firstName;
@property (nonatomic,retain) NSString *lastName;
@property (nonatomic,retain) NSString *phoneNumber;
@property (nonatomic,retain) NSString *preferredLocation;

@property (nonatomic, retain) NSMutableData     *fetchedResults;
@property (nonatomic, retain) NSMutableData     *forgotPasswordFetchedResults;
@property (nonatomic, retain) NSMutableData     *saltStringFetchedResults;

@property (nonatomic, retain) NSMutableString   *workingPropertyString;

@property (nonatomic ,retain) NSString          *loginStatusString;
@property (nonatomic ,retain) NSString          *forgotPasswordStatusString;
@property (nonatomic ,retain) NSString          *fetchedSaltString;

@property (nonatomic, assign) BOOL              storingCharacterData;
@property (nonatomic, assign) BOOL              storingCharacterData1;
@property (nonatomic, assign) BOOL              storingCharacterData2;


-(IBAction)cancelButton:(id) sender;

-(IBAction)signIn:(id) sender;

-(IBAction)registerPage:(id) sender;

@end
