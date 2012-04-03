//
//  MapViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate> 
{
    MKMapView *m_mapView;
    BOOL      m_allLocations;
}

@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (nonatomic,assign) BOOL     allLocations;
@end
