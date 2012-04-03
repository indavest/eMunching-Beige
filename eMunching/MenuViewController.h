//
//  SecondViewController.h
//  eMunching
//
//  Created by Andrew Green on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLSegmentView.h"
#import "Objects.h"
#import "ImageDownloader.h"

@interface MenuViewController : UIViewController<PLSegmentViewDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,ImageDownloaderDelegate,UIScrollViewDelegate>
{
    
    PLSegmentView           *m_menuTypeSelector;
    UIImageView             *m_brandingImage;
    UITableView             *m_menuGroupTable;
    
    NSMutableArray          *m_menuGroup;
    
    NSMutableData           *m_fetchedResults;
    NSMutableArray          *m_parsedMenuGroups;
    MenuItemGroup           *m_group;
    NSMutableArray          *m_elementsToParse;
    NSMutableString         *m_workingPropertyString;
    UIActivityIndicatorView *m_activityIndicator;
    BOOL                    m_storingCharacterData;
    
    UILabel                 *m_statuslabel;
    
    NSMutableDictionary     *m_groupImageDownloadsInProgress;

    int                     m_groupImageHeight;
    int                     m_groupImageWidth;

}

@property (nonatomic, retain) IBOutlet PLSegmentView *menuTypeSelector;
@property (nonatomic, retain) IBOutlet UIImageView   *brandingImage;
@property (nonatomic, retain) IBOutlet UITableView   *menuGroupTable;

@property (nonatomic, retain) NSMutableArray    *menuGroup;

@property (nonatomic, retain) NSMutableData     *fetchedResults;
@property (nonatomic, retain) NSMutableArray    *parsedMenuGroups;
@property (nonatomic, retain) MenuItemGroup     *group;
@property (nonatomic, retain) NSMutableArray           *elementsToParse;
@property (nonatomic, retain) NSMutableString   *workingPropertyString;
@property (nonatomic, assign) BOOL              storingCharacterData;

@property (nonatomic,retain) NSMutableDictionary *groupImageDownloadsInProgress;


// ImageDownloaderDelegate

- (void)appImageDidLoad:(NSIndexPath *)indexPath;


@end
