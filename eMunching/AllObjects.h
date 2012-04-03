//
//  Special.h
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MenuItem : NSObject<NSCoding> 
{
    NSString        *m_dishId;
    NSString        *m_dishTitle;
    NSString        *m_dishDescription;
    NSString        *m_dishPrice;
    NSString        *m_dishDiscountPrice;
    NSString        *m_dishQuantity;
    NSString        *m_dishPictureURLString;
    UIImage         *m_dishPicture;
    NSMutableArray  *m_dishPictureURLStrings;
    NSMutableArray  *m_dishPictures;
}

@property (nonatomic, retain) NSString       *dishId;
@property (nonatomic, retain) NSString       *dishTitle;
@property (nonatomic, retain) NSString       *dishDescription;
@property (nonatomic, retain) NSString       *dishPrice;
@property (nonatomic, retain) NSString       *dishDiscountPrice;
@property (nonatomic, retain) NSString       *dishQuantity;
@property (nonatomic, retain) NSString       *dishPictureURLString;
@property (nonatomic, retain) UIImage        *dishPicture;
@property (nonatomic, retain) NSMutableArray *dishPictureURLStrings;
@property (nonatomic, retain) NSMutableArray *dishPictures;

@end



@interface MenuItemGroup : NSObject 
{
    NSString *m_groupId;
    NSString *m_groupTitle;
    UIImage  *m_groupPicture;
    NSString *m_groupImageURLString;
}

@property (nonatomic, retain) NSString *groupId;
@property (nonatomic, retain) NSString *groupTitle;
@property (nonatomic, retain) UIImage  *groupPicture;
@property (nonatomic ,retain) NSString *groupImageURLString;


@end



@interface OrderGroup : NSObject<NSCoding>
{
    NSString *m_orderTitle;
    NSString *m_orderDateStamp;
}

@property (nonatomic , retain) NSString  *orderTitle;
@property (nonatomic , retain) NSString  *orderDateStamp;

@end



@interface Location : NSObject 
{
    NSString  *m_locationId;
    NSString  *m_locationName;
    NSString  *m_locationStreetAddress;
    NSString  *m_locationCity;
    NSString  *m_locationRegion;
    NSString  *m_locationLatitiude;
    NSString  *m_locationLongitude;
    NSString  *m_locationCountry;
    NSString  *m_locationPhoneNumber;
    NSString  *m_locationEmailAddress;
    NSString  *m_locationWebSite;
    NSString  *m_locationFacebookUrl;
    NSString  *m_locationTwitterUrl;
    NSString  *m_locationHoursOfOperation;
    NSString  *m_multipleMenuStatus;
}

@property (nonatomic ,retain) NSString *locationId;
@property (nonatomic ,retain) NSString *locationName;
@property (nonatomic ,retain) NSString *locationStreetAddress;
@property (nonatomic ,retain) NSString *locationCity;
@property (nonatomic ,retain) NSString *locationRegion;
@property (nonatomic ,retain) NSString *locationLatitiude;
@property (nonatomic ,retain) NSString *locationLongitude;
@property (nonatomic ,retain) NSString *locationCountry;
@property (nonatomic ,retain) NSString *locationPhoneNumber;
@property (nonatomic ,retain) NSString *locationEmailAddress;
@property (nonatomic ,retain) NSString *locationWebSite;
@property (nonatomic ,retain) NSString *locationFacebookUrl;
@property (nonatomic ,retain) NSString *locationTwitterUrl;
@property (nonatomic ,retain) NSString *locationHoursOfOperation;
@property (nonatomic ,retain) NSString *multipleMenuStatus;

@end
    



@interface Reservation : NSObject
{
    NSString *m_reservationEnabled;
    NSString *m_reservationWeeksInAdvance;
    NSString *m_reservationWeekDayStart;
    NSString *m_reservationWeekDayStop;
    NSString *m_reservationStartTime;
    NSString *m_reservationStopTime;
    NSString *m_reservationInterval;
    NSString *m_reservationTableThreshold;
}
@property (nonatomic ,retain) NSString *reservationEnabled;
@property (nonatomic ,retain) NSString *reservationWeeksInAdvance;
@property (nonatomic ,retain) NSString *reservationWeekDayStart;
@property (nonatomic ,retain) NSString *reservationWeekDayStop;
@property (nonatomic ,retain) NSString *reservationStartTime;
@property (nonatomic ,retain) NSString *reservationStopTime;
@property (nonatomic ,retain) NSString *reservationInterval;
@property (nonatomic ,retain) NSString *reservationTableThreshold;

@end



@interface Review : NSObject
{
    NSString *m_reviewRating;
    NSString *m_reviewText;
    NSString *m_reviewDate;
    NSString *m_reviewName;
}
@property (nonatomic ,retain) NSString *reviewRating;
@property (nonatomic ,retain) NSString *reviewText;
@property (nonatomic ,retain) NSString *reviewDate;
@property (nonatomic ,retain) NSString *reviewName;

@end



@interface Event : NSObject
{
    NSString *m_eventName;
    NSString *m_eventDesc;
    NSString *m_eventDate;
    NSString *m_eventTime;
  
}
@property (nonatomic ,retain) NSString *eventName;
@property (nonatomic ,retain) NSString *eventDesc;
@property (nonatomic ,retain) NSString *eventDate;
@property (nonatomic ,retain) NSString *eventTime;

@end



@interface HotDeal:NSObject
{
    NSString *m_dealTitle;
    NSString *m_dealDescription;
    NSString *m_dealType;
    NSString *m_dealValue;
    NSString *m_dealStart;
    NSString *m_dealStop;    
}

@property (nonatomic ,retain) NSString *dealTitle;;
@property (nonatomic ,retain) NSString *dealDescription;
@property (nonatomic ,retain) NSString *dealType;
@property (nonatomic ,retain) NSString *dealValue;
@property (nonatomic ,retain) NSString *dealStart;
@property (nonatomic ,retain) NSString *dealStop;

@end

