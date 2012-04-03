//
//  ApplicationManager.m
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ApplicationManager.h"

// Managers
#import "DataCacheManager.h"
#import "UIManager.h"
#import "FontManager.h"

@implementation ApplicationManager

static ApplicationManager* singletonApplicationManager;

@synthesize appDelegate = m_appDelegate;

// Managers
@synthesize dataCacheManager = m_dataCacheManager;
@synthesize uiManager = m_uiManager;

// Instantiate singleton ApplicationManager
+ (ApplicationManager*) instance
{
	if (!singletonApplicationManager)
	{
		singletonApplicationManager = [[ApplicationManager alloc] init];
	}
	
	return singletonApplicationManager;
	
}

// JIC methods if we alloc or copy the singleton
+ (id) alloc
{
	NSAssert(singletonApplicationManager == nil, @"Attempted to allocate a second instance of ApplicationManager.");
	singletonApplicationManager = [super alloc];
	return singletonApplicationManager;
}

+ (id) copy
{
	NSAssert(singletonApplicationManager == nil, @"Attempted to copy ApplicationManager.");
	return singletonApplicationManager;
}


#pragma mark -
#pragma mark Managers
- (DataCacheManager*) dataCacheManager
{
	if (m_dataCacheManager == nil)
		m_dataCacheManager = [DataCacheManager new];
	
	return m_dataCacheManager;
}

- (UIManager*) uiManager
{
    if (m_uiManager == nil)
        m_uiManager = [UIManager new];
    
    return m_uiManager;
}

- (FontManager*) fontManager
{
    return [FontManager sharedManager];
}

- (void) dealloc
{
	[super dealloc];
}

@end
