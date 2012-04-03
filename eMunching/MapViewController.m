//
//  MapViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "MapViewAnnotation.h"
#import "Objects.h"


@implementation MapViewController

@synthesize mapView = m_mapView;
@synthesize allLocations = m_allLocations;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [m_mapView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(m_allLocations)
    {   
        
        self.navigationItem.title = @"Our Locations";
        
        NSError *error;
        [[GANTracker sharedTracker] trackPageview:@"Our Locations" withError:&error];
        
        NSMutableArray *restlocations =[[[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager locations]] autorelease];
        
        NSMutableArray* annotations=[[[NSMutableArray alloc] init] autorelease];
        
        for(int i=0;i<[restlocations count];i++)
        {
            Location *location = [restlocations objectAtIndex:i];
            
            float latitude = [[location locationLatitiude]floatValue];
            float longitude = [[location locationLongitude]floatValue];
            
            CLLocationCoordinate2D Coordinate;
            Coordinate.latitude  = latitude;
            Coordinate.longitude = longitude;
            
            MapViewAnnotation* annotation=[[MapViewAnnotation alloc] init];
            
            annotation.coordinate = Coordinate;
            annotation.title    = [location locationName];
            annotation.subtitle = [location locationRegion];
            
            [m_mapView addAnnotation:annotation];
            [annotations addObject:annotation];
        }
        
        
        
        NSLog(@"%d",[annotations count]);
        //[self gotoLocation];//to catch perticular area on screen
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
        // Walk the list of overlays and annotations and create a MKMapRect that
        // bounds all of them and store it into flyTo.
        MKMapRect flyTo = MKMapRectNull;
        for (id <MKAnnotation> annotation in annotations) {
            NSLog(@"fly to on");
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(flyTo)) {
                flyTo = pointRect;
            } else {
                flyTo = MKMapRectUnion(flyTo, pointRect);
                //NSLog(@"else-%@",annotationPoint.x);
            }
        }
        
        // Position the map so that all overlays and annotations are visible on screen.
        m_mapView.visibleMapRect = flyTo;
    }
    else
    {
        self.navigationItem.title =@"Find Us";
        
        NSError *error;
        [[GANTracker sharedTracker] trackPageview:@"Find Us" withError:&error];
        
        Location *prefLocation = [[ApplicationManager instance].dataCacheManager preferredLocation];
        
        float latitiude = [[prefLocation locationLatitiude]floatValue];
        float longitude = [[prefLocation locationLongitude]floatValue];
        
        MKCoordinateRegion region;
        region.center.latitude  = latitiude;
        region.center.longitude = longitude;
        
        region.span.latitudeDelta = 0.112872;
        region.span.longitudeDelta = 0.109863;
        
        [m_mapView setRegion:region animated:YES];
        
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] init];
        annotation.title    = prefLocation.locationCity;
        annotation.subtitle = prefLocation.locationRegion;
        
        annotation.coordinate = region.center;
        [m_mapView addAnnotation:annotation];
  }  
    
}

-(void)viewDidAppear:(BOOL)animated
{
   
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    
    MKPinAnnotationView *pinView = nil;
    
    if(annotation!= m_mapView.userLocation)
    {
        static NSString *defaultID =@"myLocation";
        
        pinView =(MKPinAnnotationView*)[m_mapView dequeueReusableAnnotationViewWithIdentifier:defaultID];
        if(pinView == nil)
        {
            pinView =[[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultID]autorelease];
            pinView.pinColor =MKPinAnnotationColorGreen;
            pinView.canShowCallout = YES;
            pinView.animatesDrop = YES;
        }
    }              

    return 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mapView =nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
