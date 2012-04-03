//
//  DataCacheManager.h
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllObjects.h"
#import "FBConnect.h"


@interface DataCacheManager : NSObject 
{
    NSMutableArray *m_chefSpecails;
    NSMutableArray *m_featuredDeals;
    
    NSMutableArray *m_menuItemGroup;

    int m_chefSpecialsSynchCount;
    int m_featuredDealsSynchCount;  
    int m_menuItemGroupSynchCount;
    int m_LocationsSynchCount;
    
    NSMutableArray *m_menuItemsByGroup1;
    NSMutableArray *m_menuItemsByGroup2;
    
    NSMutableArray *m_menuItemsByGroup1SynchStatus;
    NSMutableArray *m_menuItemsByGroup2SynchStatus;
    

    NSMutableArray *m_myOrder;
    
    NSMutableArray *m_savedOrderGroup;
    NSMutableArray *m_savedOrderGroupItems;
    
    NSMutableArray *m_locations;
    
    NSMutableArray *m_reviews;
    
    NSMutableArray *m_searchResults;
    
    NSMutableArray *m_restaurantEvent;
    
    NSMutableArray *m_hotDeals;
    
    //Login Cache
    NSString *m_emailId;
    NSString *m_password;
    BOOL     m_registerStatus;
    BOOL     m_authenticationStatus;
    BOOL     m_loginStatus;
    NSString *m_phoneNumber;
    NSString *m_firstName;
    NSString *m_lastName;
    Location *m_preferredLocation;
    
    // To manage location data in saved PList
    NSString *m_prefLocationId;
    
    // Reservation cache
    NSDate *m_selectedDate;
    
    //Facebook cache
    Facebook *m_facebookInstance;
    
}

@property (nonatomic, retain) NSMutableArray *chefSpecials;
@property (nonatomic, retain) NSMutableArray *featuredDeals;

@property (nonatomic, retain ) NSMutableArray *menuItemGroup;

@property (nonatomic, retain) NSMutableArray *menuItemsByGroup1;
@property (nonatomic, retain) NSMutableArray *menuItemsByGroup2;

@property (nonatomic, retain) NSMutableArray *myOrder;

@property (nonatomic, retain) NSMutableArray *savedOrderGroup;
@property (nonatomic, retain) NSMutableArray *savedOrderGroupItems;

@property (nonatomic, retain) NSMutableArray *locations;

@property (nonatomic, retain) NSMutableArray *reviews;

@property (nonatomic, retain) NSMutableArray *searchResults;

@property (nonatomic, retain) NSMutableArray *restaurantEvent;

@property (nonatomic, retain) NSMutableArray *hotDeals;

@property (nonatomic, retain) NSString *emailId;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, assign) BOOL     registerStatus;
@property (nonatomic, assign) BOOL     authenticationStatus;
@property (nonatomic, assign) BOOL     loginStatus;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName; 
@property (nonatomic, assign) Location *preferredLocation;

@property (nonatomic, retain) NSString *prefLocationId;

@property (nonatomic ,retain) NSDate   *selectedDate;


@property (nonatomic, retain) Facebook *facebookInstance;

- (void) initMenuItemsByGroup;
- (BOOL) getDealsSynchStatus: (int) selectedDeal;
- (BOOL) getMenuItemGroupSynchStatus;
- (BOOL) getLocationsSynchStatus;
- (BOOL) getGroupsSynchStatus: (int) selectedType :(int) selectedGroup;

@end
