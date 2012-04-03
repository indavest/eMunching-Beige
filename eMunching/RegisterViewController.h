//
//  RegisterViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 26/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"ModalUIPickerViewController.h"
#import "Objects.h"
#import "FontLabel.h"

@interface RegisterViewController : UIViewController <ModalUIPickerViewControllerDelegate,NSXMLParserDelegate>
{
    UIScrollView *m_scrollView;
    
    UINavigationBar *m_navBar;
    
    ModalUIPickerViewController *m_modalPicker;

    FontLabel   *m_emailHeader;
    FontLabel   *m_passwordHeader;
    FontLabel   *m_retypePwdHeader;
    FontLabel   *m_firstNameHeader;
    FontLabel   *m_lastNameHeader;
    FontLabel   *m_phoneNoHeader;
    FontLabel   *m_locationHeader;
    
    UITextField *m_email;
    UITextField *m_password;
    UITextField *m_retypePassword;
    
    UITextField *m_firstName;
    UITextField *m_lastName;
    UITextField *m_phoneNo;
    FontLabel   *m_location;
    
    NSMutableData           *m_registerResults;
    NSMutableArray          *m_elementsToParse;
    NSMutableString         *m_workingPropertyString;
    BOOL                    m_storingCharacterData;

    UIActivityIndicatorView *m_activityIndicator;
    
    NSString                *m_registerStatusString;
    
}
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) ModalUIPickerViewController *modalPicker;

@property (nonatomic,retain) IBOutlet FontLabel *emailHeader;
@property (nonatomic,retain) IBOutlet FontLabel *passwordHeader;
@property (nonatomic,retain) IBOutlet FontLabel *retypePwdHeader;
@property (nonatomic,retain) IBOutlet FontLabel *firstNameHeader;
@property (nonatomic,retain) IBOutlet FontLabel *lastNameHeader;
@property (nonatomic,retain) IBOutlet FontLabel *phoneNoHeader;
@property (nonatomic,retain) IBOutlet FontLabel *locationHeader;

@property (nonatomic,retain) IBOutlet UITextField *email;
@property (nonatomic,retain) IBOutlet UITextField *password;
@property (nonatomic,retain) IBOutlet UITextField *retypePassword;


@property (nonatomic,retain) IBOutlet UITextField *firstName;
@property (nonatomic,retain) IBOutlet UITextField *lastName;
@property (nonatomic,retain) IBOutlet UITextField *phoneNo;
@property (nonatomic,retain) IBOutlet FontLabel   *location;

@property (nonatomic, retain) NSMutableData   *registerResults;
@property (nonatomic, retain) NSMutableArray  *elementsToParse;
@property (nonatomic, retain) NSMutableString *workingPropertyString;
@property (nonatomic, assign) BOOL            storingCharacterData;

@property (nonatomic ,retain) NSString        *registerStatusString;


-(IBAction)cancelButton:(id) sender;

-(IBAction)Done:(id) sender;

@end
