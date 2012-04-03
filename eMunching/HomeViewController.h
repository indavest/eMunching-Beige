//
//  HomeViewController.h
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLSegmentView.h"
#import "Objects.h"
#import "ImageDownloader.h"
#import "FontLabel.h"

@interface HomeViewController : UIViewController <PLSegmentViewDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,ImageDownloaderDelegate,UIScrollViewDelegate>
{    
    PLSegmentView           *m_specialSelector;
    UITableView             *m_currentSpecialsTable;

    NSMutableArray          *m_currentSpecials;
    bool                    m_selectedDealType;
    
    NSMutableData           *m_fetchedResults;
    NSMutableArray          *m_parsedCurrentSpecials;
    MenuItem                *m_menuItem;
    NSMutableArray          *m_elementsToParse;
    NSMutableString         *m_workingPropertyString;
    UIActivityIndicatorView *m_activityIndicator;
    BOOL                    m_storingCharacterData;
    
    FontLabel               *m_statuslabel;
    
    NSMutableDictionary     *m_imageDownloadsInProgress;
    
    int                     m_menuImageHeight;
    int                     m_menuImageWidth;
}

@property (nonatomic, retain) IBOutlet PLSegmentView *specialSelector;
@property (nonatomic, retain) IBOutlet UITableView   *currentSpecialsTable;

@property (nonatomic, retain) NSMutableArray    *currentSpecials;
@property (nonatomic)         bool              selectedDealType;

@property (nonatomic, retain) NSMutableData     *fetchedResults;
@property (nonatomic, retain) NSMutableArray    *parsedCurrentSpecials;
@property (nonatomic, retain) MenuItem          *menuItem;
@property (nonatomic, retain) NSMutableArray    *elementsToParse;
@property (nonatomic, retain) NSMutableString   *workingPropertyString;
@property (nonatomic, assign) BOOL              storingCharacterData;

@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

// ImageDownloaderDelegate

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
