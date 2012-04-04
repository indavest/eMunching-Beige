//
//  MyProfileViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 27/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "ModalUIPickerViewController.h"

@interface MyProfileViewController : UIViewController<ModalUIPickerViewControllerDelegate,NSXMLParserDelegate> 
{
    
    UIScrollView *m_scrollView;
    
    ModalUIPickerViewController *m_modalPicker;
    
    FontLabel   *m_emailIdHeader;
    FontLabel   *m_nameHeader;
    FontLabel   *m_phoneNoHeader;
    FontLabel   *m_locationHeader;
    FontLabel   *m_currentPwdHeader;
    FontLabel   *m_changedPwdHeader;
    FontLabel   *m_retypePwdHeader;
    
    FontLabel   *m_emailIdLabel;
    FontLabel   *m_nameLabel;
    
    UITextField *m_oldPassword;
    UITextField *m_changedPassword;
    UITextField *m_retypeChangedPassword;
    UITextField *m_changedPhoneNo;
    FontLabel   *m_changedLocation;
    
    
    NSMutableData           *m_fetchedResults;
    NSMutableData           *m_saltStringFetchedResults;
    NSMutableString         *m_workingPropertyString;
    NSString                *m_profileStatusString;
    NSString                *m_fetchedSaltString;    
    BOOL                    m_storingCharacterData;
    BOOL                    m_storingCharacterData1;
    
    UIActivityIndicatorView *m_activityIndicator;
    
    NSString *m_serverCallMode;   
}

@property (nonatomic,retain) IBOutlet UIScrollView  *scrollView;

@property (nonatomic, retain) ModalUIPickerViewController *modalPicker;

@property (nonatomic ,retain) IBOutlet FontLabel *emailIdHeader;
@property (nonatomic ,retain) IBOutlet FontLabel *nameHeader;
@property (nonatomic ,retain) IBOutlet FontLabel *phoneNoHeader;
@property (nonatomic ,retain) IBOutlet FontLabel *locationHeader;
@property (nonatomic ,retain) IBOutlet FontLabel *currentPwdHeader;
@property (nonatomic ,retain) IBOutlet FontLabel *changedPwdHeader;
@property (nonatomic ,retain) IBOutlet FontLabel *retypePwdHeader;

@property (nonatomic ,retain) IBOutlet FontLabel *emailIdLabel;
@property (nonatomic ,retain) IBOutlet FontLabel *nameLabel;

@property (nonatomic,retain) IBOutlet UITextField *oldPassword;
@property (nonatomic,retain) IBOutlet UITextField *changedPassword;
@property (nonatomic,retain) IBOutlet UITextField *retypeChangedPassword;
@property (nonatomic,retain) IBOutlet UITextField *changedPhoneNo;
@property (nonatomic,retain) IBOutlet FontLabel   *changedLocation;

@property (nonatomic, retain) NSMutableData     *fetchedResults;
@property (nonatomic, retain) NSMutableData     *saltStringFetchedResults;
@property (nonatomic, retain) NSMutableString   *workingPropertyString;
@property (nonatomic ,retain) NSString          *profileStatusString;
@property (nonatomic ,retain) NSString          *fetchedSaltString;

@property (nonatomic, assign) BOOL              storingCharacterData;
@property (nonatomic, assign) BOOL              storingCharacterData1;

@end
