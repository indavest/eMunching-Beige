//
//  HotDealsViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 03/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Objects.h"

@interface HotDealsViewController : UIViewController<NSXMLParserDelegate>
{
    UITableView *m_hotDealsTable;
    
    NSMutableArray          *m_currentHotDeals;
    
    NSMutableData           *m_fetchedResults;
    NSMutableArray          *m_parsedHotDeals;
    HotDeal                 *m_hotDeal;
    NSMutableArray          *m_elementsToParse;
    NSMutableString         *m_workingPropertyString;
    BOOL                    m_storingCharacterData;
    
    UIActivityIndicatorView *m_activityIndicator;
}
@property (nonatomic, retain) IBOutlet UITableView *hotDealsTable;

@property (nonatomic, retain) NSMutableArray       *currentHotDeals;

@property (nonatomic, retain) NSMutableData        *fetchedResults;
@property (nonatomic, retain) NSMutableArray       *parsedHotDeals;
@property (nonatomic, retain) HotDeal              *hotDeal;
@property (nonatomic, retain) NSMutableArray       *elementsToParse;
@property (nonatomic, retain) NSMutableString      *workingPropertyString;
@property (nonatomic, assign) BOOL                 storingCharacterData;

@end
