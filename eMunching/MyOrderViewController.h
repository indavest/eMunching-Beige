//
//  MyOrderViewController.h
//  eMunching
//
//  Created by Andrew Green on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Objects.h"
@class  FontLabel;


@interface MyOrderViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate>
{
    FontLabel   *m_headerSavings;
    FontLabel   *m_headerGrandTotal;
    UIImageView *m_ribbonImage;
    FontLabel   *m_savings;
    FontLabel   *m_grandTotal;
    FontLabel   *m_messageLabel;
    UITableView *m_orderTable;
    
    float        m_total;
    float        m_total1;
    
    UINavigationItem *m_navigationItem;
    UIToolbar        *m_toolBarUp;
    UIToolbar        *m_toolBarDown;
    UIBarButtonItem  *m_editButton;
    UIBarButtonItem  *m_signInButton;
    
    UITextField      *m_groupTitleField;
    
    OrderGroup       *m_orderGroup;
    NSString         *m_placeHolderDateTimeStamp;
    
    NSString         *m_myOrderString;
    
    UIAlertView      *m_saveOrderAlertView;
    UIAlertView      *m_submitOrderAlertView;
    UIAlertView      *m_signOutAlertView;
    
    NSMutableData           *m_fetchedResults;
    UIActivityIndicatorView *m_activityIndicator;
    
    NSMutableString         *m_workingPropertyString;
    BOOL                    m_storingCharacterData;  
    NSString                *m_orderStatusString;
    
    UIButton   *m_menuButton;
    UIButton   *m_savedOrderButton;
    UIButton   *m_alertMenuButton;
    UIButton   *m_alertSavedOrderButton;
    
    UIAlertView *m_alert;
}

@property (nonatomic, retain) IBOutlet FontLabel   *headerSavings;
@property (nonatomic, retain) IBOutlet FontLabel   *headerGrandTotal;
@property (nonatomic, retain) IBOutlet UIImageView *ribbonImage;
@property (nonatomic, retain) IBOutlet FontLabel   *savings;
@property (nonatomic, retain) IBOutlet FontLabel   *grandTotal;
@property (nonatomic, retain) IBOutlet FontLabel   *messageLabel;
@property (nonatomic, retain) IBOutlet UITableView *orderTable;

@property (nonatomic,retain)  IBOutlet UINavigationItem *navigationItem;
@property (nonatomic,retain)  IBOutlet UIToolbar        *toolBarUp;
@property (nonatomic,retain)  IBOutlet UIToolbar        *toolBarDown;
@property (nonatomic,retain)  IBOutlet UIBarButtonItem  *editButton;
@property (nonatomic,retain)  IBOutlet UIBarButtonItem  *signInButton;

@property (nonatomic ,retain) NSString          *myOrderString;

@property (nonatomic, retain) NSMutableData     *fetchedResults;

@property (nonatomic, retain) NSMutableString   *workingPropertyString;
@property (nonatomic, assign) BOOL              storingCharacterData;
@property (nonatomic ,retain) NSString          *orderStatusString;

@end
