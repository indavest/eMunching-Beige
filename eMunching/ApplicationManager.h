//
//  ApplicationManager.h
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FontManager.h"

@class eMunchingAppDelegate;

// Managers
@class DataCacheManager;
@class UIManager;

@interface ApplicationManager : NSObject 
{    
    eMunchingAppDelegate *m_appDelegate;
    
    DataCacheManager *m_dataCacheManager;
    UIManager *m_uiManager;
    FontManager *m_fontManager;
}

@property (nonatomic, assign) eMunchingAppDelegate *appDelegate;

// Managers
@property (nonatomic, retain) DataCacheManager *dataCacheManager;
@property (nonatomic, retain) UIManager *uiManager;
@property (nonatomic, readonly) FontManager *fontManager;

+ (ApplicationManager*) instance;

@end
