//
//  Special.m
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AllObjects.h"


@implementation MenuItem

@synthesize dishId                = m_dishId;
@synthesize dishTitle             = m_dishTitle;
@synthesize dishDescription       = m_dishDescription;
@synthesize dishPrice             = m_dishPrice;
@synthesize dishDiscountPrice     = m_dishDiscountPrice;
@synthesize dishQuantity          = m_dishQuantity;
@synthesize dishPictureURLString  = m_dishPictureURLString;
@synthesize dishPicture           = m_dishPicture;
@synthesize dishPictureURLStrings = m_dishPictureURLStrings;
@synthesize dishPictures          = m_dishPictures;

- (id) init
{
    if (self == [super init])
    {
        // Initialization
        m_dishPictureURLStrings = [[NSMutableArray alloc] initWithObjects:nil];
        m_dishPictures          = [[NSMutableArray alloc] initWithObjects:nil];
    }
    
    return  self;
}

- (id)initWithCoder:(NSCoder *)decoder 
{    
    if (self == [super init])
    {
        m_dishId            = [[decoder decodeObjectForKey:@"dishId"]retain];
        m_dishTitle         = [[decoder decodeObjectForKey:@"dishTitle"]retain];
        m_dishPrice         = [[decoder decodeObjectForKey:@"dishPrice"]retain];
        m_dishDiscountPrice = [[decoder decodeObjectForKey:@"dishDiscountPrice"]retain]; 
        m_dishQuantity      = [[decoder decodeObjectForKey:@"dishQuantity"]retain];   
        
        NSData *dataPicture = [decoder decodeObjectForKey:@"dishPicture"];
        m_dishPicture       = [[UIImage imageWithData:dataPicture] retain];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:m_dishId            forKey:@"dishId"];
    [encoder encodeObject:m_dishTitle         forKey:@"dishTitle"];
    [encoder encodeObject:m_dishPrice         forKey:@"dishPrice"];
    [encoder encodeObject:m_dishDiscountPrice forKey:@"dishDiscountPrice"];
    [encoder encodeObject:m_dishQuantity      forKey:@"dishQuantity"];
    
    NSData *pictureData = [NSData dataWithData:UIImagePNGRepresentation(m_dishPicture)];
    [encoder encodeObject:pictureData          forKey:@"dishPicture"];
}

- (void) dealloc
{
    [super dealloc];
    
    [m_dishPictureURLStrings release];
    [m_dishPictures release];
}

@end



@implementation MenuItemGroup

@synthesize groupId             = m_groupId;
@synthesize groupTitle          = m_groupTitle;
@synthesize groupPicture        = m_groupPicture;
@synthesize groupImageURLString = m_groupImageURLString;

- (id) init
{
    if (self == [super init])
    {
        // Initialization
    }
    
    return  self;
}

- (void) dealloc
{
    [super dealloc];
}

@end



@implementation OrderGroup

@synthesize orderTitle      = m_orderTitle;
@synthesize orderDateStamp  = m_orderDateStamp;

- (id) init
{
    if (self == [super init])
    {
        // Initialization
    }
    
    return  self;
}

- (id)initWithCoder:(NSCoder *)decoder 
{    
    if (self == [super init])
    {
        m_orderTitle      = [[decoder decodeObjectForKey:@"orderTitle"]retain];
        m_orderDateStamp  = [[decoder decodeObjectForKey:@"orderDateStamp"]retain];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:m_orderTitle     forKey:@"orderTitle"];
    [encoder encodeObject:m_orderDateStamp forKey:@"orderDateStamp"];      
}

- (void) dealloc
{
    [super dealloc];
}


@end



@implementation Location

@synthesize locationId               = m_locationId;
@synthesize locationName             = m_locationName;
@synthesize locationStreetAddress    = m_locationStreetAddress;
@synthesize locationCity             = m_locationCity;
@synthesize locationRegion           = m_locationRegion;
@synthesize locationLatitiude        = m_locationLatitiude;
@synthesize locationLongitude        = m_locationLongitude;
@synthesize locationCountry          = m_locationCountry;
@synthesize locationPhoneNumber      = m_locationPhoneNumber;
@synthesize locationEmailAddress     = m_locationEmailAddress;
@synthesize locationWebSite          = m_locationWebSite;
@synthesize locationFacebookUrl      = m_locationFacebookUrl;
@synthesize locationTwitterUrl       = m_locationTwitterUrl;
@synthesize locationHoursOfOperation = m_locationHoursOfOperation;
@synthesize multipleMenuStatus       = m_multipleMenuStatus;

- (id) init
{
    if (self == [super init])
    {
        // Initialization
    }
    
    return  self;
}

- (void) dealloc
{
    [super dealloc];
}

@end



@implementation Reservation

@synthesize reservationEnabled          = m_reservationEnabled;
@synthesize reservationWeeksInAdvance   = m_reservationWeeksInAdvance;
@synthesize reservationWeekDayStart     = m_reservationWeekDayStart;
@synthesize reservationWeekDayStop      = m_reservationWeekDayStop;
@synthesize reservationStartTime        = m_reservationStartTime;
@synthesize reservationStopTime         = m_reservationStopTime;
@synthesize reservationInterval         = m_reservationInterval;
@synthesize reservationTableThreshold   = m_reservationTableThreshold;

- (id) init
{
    if (self == [super init])
    {
        // Initialization
    }
    
    return  self;
}

- (void) dealloc
{
    [super dealloc];
}

@end



@implementation Review

@synthesize reviewRating = m_reviewRating;
@synthesize reviewText   = m_reviewText;
@synthesize reviewDate   = m_reviewDate;
@synthesize reviewName   = m_reviewName;

- (id) init
{
    if (self == [super init])
    {
        // Initialization
    }
    
    return  self;
}

- (void) dealloc
{
    [super dealloc];
}

@end



@implementation Event

@synthesize eventName = m_eventName;
@synthesize eventDesc = m_eventDesc;
@synthesize eventDate = m_eventDate;
@synthesize eventTime = m_eventTime;

- (id) init
{
    if (self == [super init])
    {
        // Initialization
    }
    
    return  self;
}

- (void) dealloc
{
    [super dealloc];
}

@end


@implementation HotDeal

@synthesize dealTitle       = m_dealTitle;
@synthesize dealDescription = m_dealDescription;
@synthesize dealType        = m_dealType;
@synthesize dealValue       = m_dealValue;
@synthesize dealStart       = m_dealStart;
@synthesize dealStop        = m_dealStop;


- (id) init
{
    if (self == [super init])
    {
        // Initialization
    }
    
    return  self;
}

- (void) dealloc
{
    [super dealloc];
}


@end