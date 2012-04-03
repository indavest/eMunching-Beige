//
//  AboutUsViewController.h
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"


@interface AboutUsViewController : UIViewController<NSXMLParserDelegate> 
{
    UITableView *m_aboutUsTable;
    
    NSMutableArray *m_aboutUs;
    
    FontLabel      *m_hoursOfOperation;
    
    NSMutableData           *m_fetchedResults;
    NSMutableString         *m_workingPropertyString;
    NSString                *m_historyHTMLContent;
    BOOL                    m_storingCharacterData;
    
    UIActivityIndicatorView *m_activityIndicator;
}   
 

@property (nonatomic,retain) IBOutlet UITableView *aboutUsTable;
@property (nonatomic,retain) NSMutableArray       *aboutUs;

@property (nonatomic,retain) IBOutlet FontLabel   *hoursOfOperation;

@property (nonatomic, retain) NSMutableData       *fetchedResults;
@property (nonatomic, retain) NSMutableString     *workingPropertyString;
@property (nonatomic,retain) NSString             *historyHTMLContent;

@property (nonatomic, assign) BOOL                storingCharacterData;


@end
