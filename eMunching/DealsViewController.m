//
//  HomePageViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DealsViewController.h"
#import "MyOrderViewController.h"
#import "HomeViewController.h"
#import "Reachability.h"
#import "SignInViewController.h"
#import "MyProfileViewController.h"
#import "HotDealsViewController.h"

@interface DealsViewController (PrivateMethods)

- (void) getRestaurantLocations;
- (void) displayMyOrder;
- (void) displayMyProfile;
- (void) displayChefSpecial;
- (void) displayFeaturedDeals;
- (void) displayHotDeals;

@end

@implementation DealsViewController

@synthesize scrollView     = m_scrollView;
@synthesize logoImage      = m_logoImage;
@synthesize specialsButton = m_specialsButton;
@synthesize dealsButton    = m_dealsButton;

@synthesize locationResults         = m_locationResults;
@synthesize parsedLocations         = m_parsedLocations;
@synthesize locationData            = m_locationData;
@synthesize workingPropertyString   = m_workingPropertyString;
@synthesize elementsToParse         = m_elementsToParse;
@synthesize storingCharacterData    = m_storingCharacterData;


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
    [super dealloc];
    
    [m_parsedLocations release];
    [m_locationData release];
    [m_elementsToParse release];
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
    
    [m_scrollView setScrollEnabled:YES];
    [m_scrollView setContentSize:CGSizeMake(320,370)];
    
    FontLabel *hiddenLabel;
    hiddenLabel = [[FontLabel alloc] initWithFrame:CGRectMake(0, -75, 320, 60)];
    hiddenLabel.backgroundColor = [UIColor clearColor];
    hiddenLabel.textColor = [UIColor darkGrayColor];
    hiddenLabel.textAlignment = UITextAlignmentCenter;
    hiddenLabel.numberOfLines = 2;
    hiddenLabel.text   = @"Powered By eMunching";
    [hiddenLabel setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:15.0f]];
    [self.scrollView addSubview:hiddenLabel];
    
    [[[self navigationItem] rightBarButtonItem] setTarget:self];
    [[[self navigationItem] rightBarButtonItem] setAction:@selector(displayMyOrder)];
    [[[self navigationItem] leftBarButtonItem] setTarget:self];
    [[[self navigationItem] leftBarButtonItem] setAction:@selector(displayMyProfile)];
    
    self.parsedLocations = [NSMutableArray array];
    self.workingPropertyString = [NSMutableString string];
    
    self.elementsToParse = [NSMutableArray array];
    [self.elementsToParse addObject:@"LocaID"];
    [self.elementsToParse addObject:@"LName"];
    [self.elementsToParse addObject:@"StreetAddress"];
    [self.elementsToParse addObject:@"City"];
    [self.elementsToParse addObject:@"Region"];
    [self.elementsToParse addObject:@"Country"];
    [self.elementsToParse addObject:@"Latitude"];
    [self.elementsToParse addObject:@"Longitude"];
    [self.elementsToParse addObject:@"PhoneNumber"];
    [self.elementsToParse addObject:@"EmailAddress"];
    [self.elementsToParse addObject:@"WebSite"];
    [self.elementsToParse addObject:@"FacebookUrl"];
    [self.elementsToParse addObject:@"TwitterHandle"];
    [self.elementsToParse addObject:@"HoursOfOperation"];
    [self.elementsToParse addObject:@"MultipleMenus"];
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_scrollView setBackgroundColor:BACKGROUNDCOLOR];     
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
}

-(void)viewDidAppear:(BOOL)animated
{
    [self getRestaurantLocations];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"Home" withError:&error];
}

- (IBAction) handleButton:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int tag = [button tag];
    
    switch (tag)
    {
        case BUTTON_CHEFSPECIAL:
            [self displayChefSpecial];
            break;
        case BUTTON_FEATUREDDEAL:
            [self displayFeaturedDeals];
            break;
        case BUTTON_HOTDEALS:
            [self displayHotDeals]; 
            break;
        default:
            break;
    }
}


-(void) displayChefSpecial
{
    
    HomeViewController *homeView =[[HomeViewController alloc]initWithNibName:@"HomeView" bundle:nil];
    [homeView setSelectedDealType:0];
    [self.navigationController pushViewController:homeView animated:YES]; 
    
}

-(void) displayFeaturedDeals
{
    
    HomeViewController *homeView =[[HomeViewController alloc]initWithNibName:@"HomeView" bundle:nil];
    [homeView setSelectedDealType:1];
    [self.navigationController pushViewController:homeView animated:YES]; 
    
}

-(void) displayHotDeals
{
    HotDealsViewController *hotDealsView =[[HotDealsViewController alloc]initWithNibName:@"HotDealsViewController" bundle:nil];
    [self.navigationController pushViewController:hotDealsView animated:YES]; 
}

- (void) displayMyOrder
{
    [[[[ApplicationManager instance].uiManager orderController] orderTable] reloadData];
    [self presentModalViewController:(UIViewController*)[[ApplicationManager instance].uiManager orderController] animated:YES];
}

- (void) displayMyProfile
{
    if ([[ApplicationManager instance].dataCacheManager loginStatus] == FALSE)
    {
        SignInViewController *signIn =[[SignInViewController alloc]initWithNibName:@"SignInViewController" bundle:nil];
        [self presentModalViewController:signIn animated:YES];
    }
    else
    {
        MyProfileViewController *MyProfileView =[[MyProfileViewController alloc]initWithNibName:@"MyProfileViewController" bundle:nil];
        [self.navigationController pushViewController:MyProfileView animated:YES]; 
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)getRestaurantLocations
{    
    // Control the number of synch calls made to server for each menu item group
    // Get data from server only after an interval of x(refer DataCacheManager) calls to the cache manager
    
    if ([[ApplicationManager instance].dataCacheManager getLocationsSynchStatus] == FALSE)
    {
        return;
    }
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Please check your data connection and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    NSString *soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<GetRestaurantLocations_XML xmlns=\"http://emunching.org/\">\n"
                            "<UserName>eMunch</UserName>\n"
                            "<PassWord>idnlgeah11</PassWord>\n"
                            "<RestaurantID>%i</RestaurantID>\n" 
                            "</GetRestaurantLocations_XML>\n"
                            "</soap:Body>\n"
                            "</soap:Envelope>\n",RESTAURANT_ID];
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/GetRestaurantLocations_XML" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        m_locationResults = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}

-(void) connection:(NSURLConnection *) connection 
didReceiveResponse:(NSURLResponse *) response 
{
    [m_locationResults setLength: 0];
}


-(void) connection:(NSURLConnection *) connection 
    didReceiveData:(NSData *) data 
{
    [m_locationResults appendData:data];
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error 
{
    [m_locationResults release];
    [connection release];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection 
{
    
    NSLog(@"DONE. Received Bytes: %d", [m_locationResults length]);
    
    NSString *theXML = [[NSString alloc] 
                        initWithBytes: [m_locationResults mutableBytes] 
                        length:[m_locationResults length] 
                        encoding:NSUTF8StringEncoding];
    
    //---shows the XML---
    NSLog(@"%@",theXML);
    
    [theXML release];  
    
    [m_parsedLocations removeAllObjects];
    
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:m_locationResults]autorelease];
    [parser setDelegate:self];
    [parser parse];
    
    [connection release];
    [m_locationResults release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"Location"])
    {
        self.locationData = [[[Location alloc] init] autorelease];
    }
    
    m_storingCharacterData = [m_elementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if (self.locationData)
    {
        if (m_storingCharacterData)
        {
            NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [m_workingPropertyString setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:@"LocaID"])
            {
                self.locationData.locationId = trimmedString;
            }
            else if ([elementName isEqualToString:@"LName"])
            {
                self.locationData.locationName = trimmedString;
            }
            else if ([elementName isEqualToString:@"StreetAddress"])
            {
                self.locationData.locationStreetAddress = trimmedString;
            }
            else if ([elementName isEqualToString:@"City"])
            {
                self.locationData.locationCity = trimmedString;
            }
            else if ([elementName isEqualToString:@"Region"])
            {
                self.locationData.locationRegion = trimmedString;
            }
            else if ([elementName isEqualToString:@"Country"])
            {
                self.locationData.locationCountry = trimmedString;
            }
            else if ([elementName isEqualToString:@"Latitude"])
            {
                self.locationData.locationLatitiude = trimmedString;
            }
            else if ([elementName isEqualToString:@"Longitude"])
            {
                self.locationData.locationLongitude = trimmedString;
            }
            else if ([elementName isEqualToString:@"PhoneNumber"])
            {
                self.locationData.locationPhoneNumber = trimmedString;
            }
            else if ([elementName isEqualToString:@"EmailAddress"])
            {
                self.locationData.locationEmailAddress = trimmedString;
            }
            else if ([elementName isEqualToString:@"WebSite"])
            {
                self.locationData.locationWebSite = trimmedString;
            }
            else if ([elementName isEqualToString:@"FacebookUrl"])
            {
                self.locationData.locationFacebookUrl = trimmedString;
            }
            else if ([elementName isEqualToString:@"TwitterHandle"])
            {
                self.locationData.locationTwitterUrl = trimmedString;
            }
            else if ([elementName isEqualToString:@"HoursOfOperation"])
            {
                self.locationData.locationHoursOfOperation = trimmedString;
            }
            else if ([elementName isEqualToString:@"MultipleMenus"])
            {
                self.locationData.multipleMenuStatus = trimmedString;
            }
         }
        
        if ([elementName isEqualToString:@"Location"])
        {
            [self.parsedLocations addObject:self.locationData];  
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (m_storingCharacterData)
        [m_workingPropertyString appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Check if parserDidEndDocument is called after parse error
    // If not, do the same actions as parserDidEndDocument
    
    //m_statuslabel.hidden = FALSE;
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([m_parsedLocations count])
    {
        [[ApplicationManager instance].dataCacheManager setLocations:m_parsedLocations];
        
        Location *location = [m_parsedLocations objectAtIndex:0];
        [[ApplicationManager instance].dataCacheManager setPreferredLocation:location];
        
        NSString *prefLoc = [[ApplicationManager instance].dataCacheManager prefLocationId];
        for(int i=0;i<[m_parsedLocations count];i++)
        {
            if ([prefLoc isEqualToString:[[m_parsedLocations objectAtIndex:i] locationId]])
            {
                Location *preflocation = [m_parsedLocations objectAtIndex:i];
                [[ApplicationManager instance].dataCacheManager setPreferredLocation:preflocation];
            }
        }
    }
}


@end
