//
//  MenuTypeViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 29/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Objects.h"
#import "ImageDownloader.h"
#import "FontLabel.h"

@interface MenuTypeViewController : UIViewController<NSXMLParserDelegate,ImageDownloaderDelegate,UIScrollViewDelegate>
{
    
    NSString                *m_menuGroup;
    UITableView             *m_menuTable;
    NSMutableArray          *m_menuItems;
    
    NSInteger               m_selectedType;    
    NSInteger               m_selectedGroup;
    NSString                *m_selectedGroupId;

    NSMutableData           *m_fetchedResults;
    NSMutableArray          *m_parsedMenuGroupItems;
    MenuItem                *m_menuItem;
    NSMutableArray          *m_elementsToParse;
    NSMutableString         *m_workingPropertyString;
    UIActivityIndicatorView *m_activityIndicator;
    BOOL                    m_storingCharacterData;
    
    FontLabel               *m_statuslabel;
    
    NSMutableDictionary     *m_menuImageDownloadsInProgress;
    
    int                     m_menuImageHeight;
    int                     m_menuImageWidth;

}

@property (nonatomic, retain) NSString             *menuGroup;
@property (nonatomic, retain) IBOutlet UITableView *menuTable;
@property (nonatomic, retain) NSMutableArray       *menuItems;

@property (nonatomic, assign) NSInteger           selectedType;
@property (nonatomic, assign) NSInteger           selectedGroup;
@property (nonatomic, retain) NSString            *selectedGroupId;

@property (nonatomic, retain) NSMutableData       *fetchedResults;
@property (nonatomic, retain) NSMutableArray      *parsedMenuGroupItems;
@property (nonatomic, retain) MenuItem            *menuItem;
@property (nonatomic, retain) NSMutableArray      *elementsToParse;
@property (nonatomic, retain) NSMutableString     *workingPropertyString;
@property (nonatomic, assign) BOOL                storingCharacterData;

@property (nonatomic,retain)  NSMutableDictionary  *menuImageDownloadsInProgress;


// ImageDownloaderDelegate Method

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
