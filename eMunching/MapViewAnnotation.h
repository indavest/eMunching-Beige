//
//  MapViewAnnotation.h
//  eMunching
//
//  Created by Ranjit Kadam on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface MapViewAnnotation : NSObject<MKAnnotation> 
{
    CLLocationCoordinate2D coordinate;
    NSString * m_title;
    NSString * m_subtitle;
   
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

@end
