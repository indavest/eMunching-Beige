//
//  DateSelectionViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"


@interface DateSelectionViewController : UIViewController 
{
    
    UITableView  *m_pickerTable;
    UIDatePicker *m_pickerView;
	NSArray      *m_dataArray;
	
	NSDateFormatter *m_dateFormatter;
    NSDateFormatter *m_timeFormatter;
    
    UIBarButtonItem *m_doneButton;	// this button appears only when the date picker is open
    
    NSDate          *m_mindate;
    NSDate          *m_maxDate;
    NSInteger       m_interval;
   
    FontLabel       *m_messageLabel;
}

@property (nonatomic, retain) IBOutlet UITableView  *pickerTable;
@property (nonatomic, retain) IBOutlet UIDatePicker *pickerView; 
@property (nonatomic, retain) NSArray *dataArray; 

@property (nonatomic, retain) NSDateFormatter *dateFormatter; 
@property (nonatomic, retain) NSDateFormatter *timeFormatter;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, retain) NSDate   *mindate;
@property (nonatomic, retain) NSDate   *maxDate;
@property (nonatomic, assign)   NSInteger interval;

@property (nonatomic, retain) IBOutlet FontLabel *messageLabel;


- (IBAction)doneAction:(id)sender;	// when the done button is clicked
- (IBAction)dateAction:(id)sender;	// when the user has changed the date picke values (m/d/y)

@end
