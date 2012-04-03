//
//  EventViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 06/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Objects.h"


@interface EventViewController : UIViewController<NSXMLParserDelegate>
{
    UITableView *m_eventsTable;
    
    NSMutableArray          *m_currentEvents;
    
    NSMutableData           *m_fetchedResults;
    NSMutableArray          *m_parsedEvents;
    Event                   *m_event;
    NSMutableArray          *m_elementsToParse;
    NSMutableString         *m_workingPropertyString;
    BOOL                    m_storingCharacterData;
    
    UIActivityIndicatorView *m_activityIndicator;
    
}
@property (nonatomic, retain) IBOutlet UITableView *eventsTable;
@property (nonatomic, retain) NSMutableArray       *currentEvents;

@property (nonatomic, retain) NSMutableData        *fetchedResults;
@property (nonatomic, retain) NSMutableArray       *parsedEvents;
@property (nonatomic, retain) Event                *event;
@property (nonatomic, retain) NSMutableArray       *elementsToParse;
@property (nonatomic, retain) NSMutableString      *workingPropertyString;
@property (nonatomic, assign) BOOL                 storingCharacterData;




@end
