//
//  DataCacheManager.m
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataCacheManager.h"
#import "Objects.h"

@implementation DataCacheManager

@synthesize chefSpecials         = m_chefSpecails;
@synthesize featuredDeals        = m_featuredDeals;

@synthesize menuItemGroup        = m_menuItemGroup;

@synthesize menuItemsByGroup1    = m_menuItemsByGroup1;
@synthesize menuItemsByGroup2    = m_menuItemsByGroup2;

@synthesize myOrder              = m_myOrder;

@synthesize savedOrderGroup      = m_savedOrderGroup;
@synthesize savedOrderGroupItems = m_savedOrderGroupItems;

@synthesize locations            = m_locations;

@synthesize reviews              = m_reviews;

@synthesize searchResults        = m_searchResults;

@synthesize restaurantEvent      = m_restaurantEvent;

@synthesize hotDeals             = m_hotDeals;

@synthesize emailId              = m_emailId;
@synthesize password             = m_password;
@synthesize registerStatus       = m_registerStatus;
@synthesize authenticationStatus = m_authenticationStatus;
@synthesize loginStatus          = m_loginStatus;
@synthesize phoneNumber          = m_phoneNumber;
@synthesize firstName            = m_firstName;
@synthesize lastName             = m_lastName;
@synthesize preferredLocation    = m_preferredLocation;

@synthesize prefLocationId       = m_prefLocationId;

@synthesize selectedDate         = m_selectedDate;

@synthesize facebookInstance = m_facebookInstance;

- (id) init
{
    if (self == [super init])
    {
        m_chefSpecails  = [[NSMutableArray alloc] initWithObjects:nil];
        m_featuredDeals = [[NSMutableArray alloc] initWithObjects:nil];
        
        m_menuItemGroup  = [[NSMutableArray alloc] initWithObjects:nil];
        
        m_menuItemsByGroup1  = [[NSMutableArray alloc] initWithObjects:nil];
        m_menuItemsByGroup2  = [[NSMutableArray alloc] initWithObjects:nil];
        
        m_menuItemsByGroup1SynchStatus = [[NSMutableArray alloc] initWithObjects:nil];
        m_menuItemsByGroup2SynchStatus = [[NSMutableArray alloc] initWithObjects:nil];
        
        m_chefSpecialsSynchCount  = SYNCH_INTERVAL;
        m_featuredDealsSynchCount = SYNCH_INTERVAL;
        m_menuItemGroupSynchCount = SYNCH_INTERVAL;
        m_LocationsSynchCount     = SYNCH_INTERVAL;
        
        m_myOrder                  = [[NSMutableArray alloc] initWithObjects:nil];
        
        m_savedOrderGroup          = [[NSMutableArray alloc] initWithObjects:nil];
        m_savedOrderGroupItems     = [[NSMutableArray alloc] initWithObjects:nil];
        
        m_locations                = [[NSMutableArray alloc] initWithObjects:nil];
        
        m_reviews                  = [[NSMutableArray alloc] initWithObjects:nil];
        
        m_searchResults            = [[NSMutableArray alloc] initWithObjects:nil];
        
        m_restaurantEvent          = [[NSMutableArray alloc] initWithObjects:nil];
        
        m_hotDeals                 = [[NSMutableArray alloc] initWithObjects:nil];
        
        m_preferredLocation        = nil;
    }
    
    return self;
}


- (BOOL) getDealsSynchStatus: (int) selectedDeal
{
    
    switch (selectedDeal)
    {
        case 0:
            if (m_chefSpecialsSynchCount < SYNCH_INTERVAL && [m_chefSpecails count])
            {
                m_chefSpecialsSynchCount  = m_chefSpecialsSynchCount + 1;
                return FALSE;
            }
            else
            {
                m_chefSpecialsSynchCount = 0;
                return TRUE;
            }
            break;
            
        case 1:
            if (m_featuredDealsSynchCount < SYNCH_INTERVAL && [m_featuredDeals count])
            {
                m_featuredDealsSynchCount  = m_featuredDealsSynchCount + 1;
                return FALSE;
            }
            else
            {
                m_featuredDealsSynchCount = 0;
                return TRUE;
            }            
            break;
 
        default:
            return FALSE;
    }
}

- (BOOL) getMenuItemGroupSynchStatus
{
    if (m_menuItemGroupSynchCount < SYNCH_INTERVAL && [m_menuItemGroup count])
    {
        m_menuItemGroupSynchCount  = m_menuItemGroupSynchCount + 1;
        return FALSE;
    }
    else
    {
        m_menuItemGroupSynchCount = 0;
        return TRUE;
    }
    
}

- (BOOL) getLocationsSynchStatus
{
    if (m_LocationsSynchCount < SYNCH_INTERVAL && [m_locations count])
    {
        m_LocationsSynchCount  = m_LocationsSynchCount + 1;
        return FALSE;
    }
    else
    {
        m_LocationsSynchCount = 0;
        return TRUE;
    }
    
}

-(void) initMenuItemsByGroup
{
    for (int i=0;i < [m_menuItemGroup count];i++)
    {
        int tempVal = SYNCH_INTERVAL;
        NSNumber* synchCount = [NSNumber numberWithInt:tempVal];
        
        [m_menuItemsByGroup1 addObject:[[[NSMutableArray alloc] initWithObjects:nil] autorelease]];
        [m_menuItemsByGroup2 addObject:[[[NSMutableArray alloc] initWithObjects:nil] autorelease]];
        
        [m_menuItemsByGroup1SynchStatus addObject:synchCount];
        [m_menuItemsByGroup2SynchStatus addObject:synchCount];
    }
    
}

- (BOOL) getGroupsSynchStatus: (int) selectedType :(int) selectedGroup
{

    switch (selectedType)
    {
        case 0:
        {
            NSNumber *synchCount = [m_menuItemsByGroup1SynchStatus objectAtIndex:selectedGroup];
            int groupLength = [[m_menuItemsByGroup1 objectAtIndex:selectedGroup] count];
            
            if ([synchCount intValue] < SYNCH_INTERVAL && groupLength)
            {
                int tempVal = [synchCount intValue];
                tempVal = tempVal + 1;
                NSNumber* newSynchCount = [NSNumber numberWithInt:tempVal];
                
                [m_menuItemsByGroup1SynchStatus replaceObjectAtIndex:selectedGroup withObject:newSynchCount];
                return FALSE;
            }
            else
            {
                NSNumber* newSynchCount = [NSNumber numberWithInt:0];
                [m_menuItemsByGroup1SynchStatus replaceObjectAtIndex:selectedGroup withObject:newSynchCount];
                return TRUE;
            }   
            break;
        }
            
        case 1:
        {
            NSNumber *synchCount = [m_menuItemsByGroup2SynchStatus objectAtIndex:selectedGroup];
            int groupLength = [[m_menuItemsByGroup2 objectAtIndex:selectedGroup] count];
            
            if ([synchCount intValue] < SYNCH_INTERVAL && groupLength)
            {
                int tempVal = [synchCount intValue];
                tempVal = tempVal + 1;
                NSNumber* newSynchCount = [NSNumber numberWithInt:tempVal];
                
                [m_menuItemsByGroup2SynchStatus replaceObjectAtIndex:selectedGroup withObject:newSynchCount];
                return FALSE;
            }
            else
            {
                NSNumber* newSynchCount = [NSNumber numberWithInt:0];
                [m_menuItemsByGroup2SynchStatus replaceObjectAtIndex:selectedGroup withObject:newSynchCount];
                return TRUE;
            }             
            break;
        }
            
        default:
            return FALSE;
    }
}


- (void) dealloc
{
    [m_chefSpecails  release];
    [m_featuredDeals release];
    
    [m_menuItemGroup release];
    
    [m_menuItemsByGroup1 release];
    [m_menuItemsByGroup2 release];
    
    [m_menuItemsByGroup1SynchStatus release];
    [m_menuItemsByGroup2SynchStatus release];
    
    [m_myOrder release];
    
    [m_savedOrderGroupItems release];
    [m_savedOrderGroup release];
    
    [m_locations release];
    
    [m_reviews release];
    
    [m_searchResults release];
    
    [m_restaurantEvent release];
    
    [m_hotDeals release];
    
    [super dealloc];
}

@end
