//
//  DealsViewController.h
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "ModalUIPickerViewController.h"
#import "Objects.h"


@interface ReservationsViewController : UIViewController<ModalUIPickerViewControllerDelegate,NSXMLParserDelegate> 
{
    UIScrollView *m_scrollView;
    
    UIButton  *m_emailButton;
    FontLabel *m_emailIdLabel;
    
    FontLabel   *m_reserveEmailHeader;
    FontLabel   *m_reserveNameHeader;
    FontLabel   *m_reservePhoneNoHeader;
    FontLabel   *m_reserveMessageHeader;
    FontLabel   *m_reserveLocationHeader;
    FontLabel   *m_reserveNoOfGuestHeader;
    FontLabel   *m_reserveDateHeader;
    
    UITextField *m_reserveName;
    UITextField *m_reservePhoneNo;
    UITextField *m_reserveMessage;
    FontLabel   *m_reserveLocation;
    FontLabel   *m_numberOfGuest;
    FontLabel   *m_DateTimeLabel;
    
    NSMutableData           *m_fetchedResults;
    NSMutableData           *m_reserveConfigResults;
    NSMutableString         *m_workingPropertyString;
    NSString                *m_reservationStatusString;
    NSMutableArray          *m_elementsToParse;

    NSMutableArray          *m_parsedreservationConfig;
    Reservation             *m_reservationItem;
 
    NSDate                  *m_minDate;
    NSDate                  *m_maxDate;
    NSString                *m_interval;
    
    BOOL                    m_storingCharacterData;
    BOOL                    m_storingCharacterData1;                   
    
    UIActivityIndicatorView *m_activityIndicator;

    int                         m_pickerSelector;
    ModalUIPickerViewController *m_locationModalPicker;
    ModalUIPickerViewController *m_guestNoModalPicker;
    
    BOOL                     m_submitMode;
}

@property (nonatomic,retain) IBOutlet UIScrollView  *scrollView;

@property (nonatomic ,retain) IBOutlet UIButton   *emailButton;
@property (nonatomic ,retain) IBOutlet FontLabel  *emailIdLabel;

@property (nonatomic,retain) IBOutlet FontLabel *reserveEmailHeader;
@property (nonatomic,retain) IBOutlet FontLabel *reserveNameHeader;
@property (nonatomic,retain) IBOutlet FontLabel *reservePhoneNoHeader;
@property (nonatomic,retain) IBOutlet FontLabel *reserveMessageHeader;
@property (nonatomic,retain) IBOutlet FontLabel *reserveLocationHeader;
@property (nonatomic,retain) IBOutlet FontLabel *reserveNoOfGuestHeader;
@property (nonatomic,retain) IBOutlet FontLabel *reserveDateHeader;

@property (nonatomic,retain) IBOutlet UITextField *reserveName;
@property (nonatomic,retain) IBOutlet UITextField *reservePhoneNo;
@property (nonatomic,retain) IBOutlet UITextField *reserveMessage;
@property (nonatomic,retain) IBOutlet FontLabel   *reserveLocation;
@property (nonatomic,retain) IBOutlet FontLabel   *numberOfGuest;
@property (nonatomic,retain) IBOutlet FontLabel   *dateTimeLabel;

@property (nonatomic, retain) NSMutableData     *fetchedResults;
@property (nonatomic, retain) NSMutableData     *reserveConfigResults; 
@property (nonatomic, retain) NSMutableString   *workingPropertyString;
@property (nonatomic, retain) NSString          *reservationStatusString;
@property (nonatomic, retain) NSMutableArray    *elementsToParse; 

@property (nonatomic, retain) NSMutableArray    *parsedreservationConfig;
@property (nonatomic, retain) Reservation       *reservationItem;

@property (nonatomic, retain) NSDate            *minDate;
@property (nonatomic, retain) NSDate            *maxDate; 

@property (nonatomic, assign) BOOL              storingCharacterData;
@property (nonatomic, assign) BOOL              storingCharacterData1;      

@property (nonatomic, assign) int               pickerSelector;
@property (nonatomic, retain) ModalUIPickerViewController *locationModalPicker;
@property (nonatomic, retain) ModalUIPickerViewController *guestNoModalPicker;


@end
