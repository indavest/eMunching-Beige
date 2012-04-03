//
//  AboutUsViewController.m
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsTableViewCell.h"
#import "MyOrderViewController.h"
#import "MyReviewViewController.h"
#import "ContactUsViewController.h"
#import "MyProfileViewController.h"
#import "EventViewController.h"
#import "SignInViewController.h"
#import "MapViewController.h"
#import "WebViewController.h"

#import "FontLabel.h"
#import "Objects.h"


#import "Reachability.h"


@interface AboutUsViewController (PrivateMethods)

- (void) displayMyOrder;
- (void) displayMyProfile;
- (void) getRestaurantAboutUs;

@end


@implementation AboutUsViewController

@synthesize aboutUsTable            = m_aboutUsTable;
@synthesize aboutUs                 = m_aboutUs;

@synthesize hoursOfOperation        = m_hoursOfOperation;

@synthesize fetchedResults          = m_fetchedResults;
@synthesize workingPropertyString   = m_workingPropertyString;
@synthesize storingCharacterData    = m_storingCharacterData;
@synthesize historyHTMLContent      = m_historyHTMLContent; 


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
    
    FontLabel *hiddenLabel;
    hiddenLabel = [[FontLabel alloc] initWithFrame:CGRectMake(0, -75, 320, 60)];
    hiddenLabel.backgroundColor = [UIColor clearColor];
    hiddenLabel.textColor = [UIColor darkGrayColor];
    hiddenLabel.textAlignment = UITextAlignmentCenter;
    hiddenLabel.numberOfLines = 2;
    hiddenLabel.text   = [[EMUNCHINGBRANDING stringByAppendingString:@"\n"] stringByAppendingString: APPVERSION];
    [hiddenLabel setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:15.0f]];
    [self.aboutUsTable addSubview:hiddenLabel];
    
    m_aboutUs = [[NSMutableArray alloc] init];
    [m_aboutUs addObject:@"OUR HISTORY"];
    [m_aboutUs addObject:@"OUR LOCATIONS"];
    [m_aboutUs addObject:@"EVENTS"];
    [m_aboutUs addObject:@"REVIEWS"];
    [m_aboutUs addObject:@"CONTACT US"];
        
    [[[self navigationItem] rightBarButtonItem] setTarget:self];
    [[[self navigationItem] rightBarButtonItem] setAction:@selector(displayMyOrder)];
    [[[self navigationItem] leftBarButtonItem] setTarget:self];
    [[[self navigationItem] leftBarButtonItem] setAction:@selector(displayMyProfile)];
    
    //Call to getRestaurantAbout service call
    [self getRestaurantAboutUs];
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_aboutUsTable setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
    
    [m_hoursOfOperation setTextColor:TEXTCOLOR5];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"Reservation" withError:&error];
    
    Location *prefLocation = [[ApplicationManager instance].dataCacheManager preferredLocation];
    
    if (prefLocation != nil)
    {
        m_hoursOfOperation.text   =[[[NSString stringWithFormat:@"HOURS OF OPERATION"]stringByAppendingString:@" : "]stringByAppendingString:prefLocation.locationHoursOfOperation];
    }
}


-(void)getRestaurantAboutUs
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Please check your data connection and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    //Start an activity indicator before the data is loaded from server
    m_activityIndicator =[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 40.0f, 40.0f)];
    [m_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    m_activityIndicator.center = self.view.center;
    [self.view addSubview:m_activityIndicator];
    [m_activityIndicator startAnimating];   
    
    //self.parsedHistory= [NSMutableArray array];
    self.workingPropertyString = [NSMutableString string];
    
    //self.elementsToParse = [[NSMutableArray alloc] init];
    //[self.elementsToParse addObject:@"History"];
      
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
     "<soap:Body>\n"
     "<GetRestaurantAbout_XML xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<RestaurantID>%i</RestaurantID>\n"
    "</GetRestaurantAbout_XML>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n",RESTAURANT_ID];   
   
   
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/GetRestaurantAbout_XML" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        m_fetchedResults = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }    
}

-(void) connection:(NSURLConnection *) connection 
didReceiveResponse:(NSURLResponse *) response {
    [m_fetchedResults setLength: 0];
}

-(void) connection:(NSURLConnection *) connection 
    didReceiveData:(NSData *) data {
    [m_fetchedResults appendData:data];
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error {
    [m_fetchedResults release];
    [connection release];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    
    NSLog(@"DONE. Received Bytes: %d", [m_fetchedResults length]);
    
    NSString *theXML = [[NSString alloc] 
                        initWithBytes: [m_fetchedResults mutableBytes] 
                        length:[m_fetchedResults length] 
                        encoding:NSUTF8StringEncoding];
    
    //---shows the XML---
    NSLog(@"%@",theXML);
    
    [theXML release];  
    
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:m_fetchedResults]autorelease];
	[parser setDelegate:self];
    [parser parse];
	
    [connection release];
    [m_fetchedResults release];
}

#pragma mark -
#pragma mark RSS processing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"About"])
	{
        m_workingPropertyString = [[NSMutableString alloc] init];
        m_storingCharacterData = YES;
    }   
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    
        if (m_storingCharacterData)
        {
            NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [m_workingPropertyString setString:@""];  // clear the string for next time
            
            if ([elementName isEqualToString:@"History"])
            {
                self.historyHTMLContent = trimmedString; 
                
            }
        }
        
} 
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (m_storingCharacterData)
    {
        [m_workingPropertyString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Check if parserDidEndDocument is called after parse error
    // If not, do the same actions as parserDidEndDocument       
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
   [m_activityIndicator stopAnimating];
   m_activityIndicator.hidden = YES;
   [m_activityIndicator release];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section

    return [m_aboutUs count];
}   
    


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%i%i",[indexPath section],[indexPath row]];
    
    // Configure the cell...
    AboutUsTableViewCell *tableCell = [[AboutUsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AboutUsTableViewCell" owner:nil options:nil];
    
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[AboutUsTableViewCell class]])
        {
            tableCell = (AboutUsTableViewCell*)currentObject;
            break;	
        }
    }
    
    tableCell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
    if ([indexPath row]%2 != 0)
    {
        [[tableCell aboutUsTitle] setTextColor:TEXTCOLOR3];
        [[tableCell titleBackground] setImage:[UIImage imageNamed:@"shelf_grey.png"]];
    }
    else
    {
        [[tableCell aboutUsTitle] setTextColor:TEXTCOLOR1];
    }
    
    [[tableCell aboutUsTitle] setText:[m_aboutUs objectAtIndex:[indexPath row]]];
    [[tableCell aboutUsTitle] setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:18.0f]];    
    
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return tableCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0)
    {
        WebViewController *webView = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        [webView setDisplayPage:@"HistoryPage"];
        [webView setContentToDisplay:m_historyHTMLContent];
        [self.navigationController pushViewController:webView animated:YES];  
    }        
    if(indexPath.row == 1)
    {
        MapViewController *event = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
        [event setAllLocations:TRUE];
        [self.navigationController pushViewController:event animated:YES];         
    }
    if(indexPath.row == 2)
    {
        EventViewController *event = [[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil];
        [self.navigationController pushViewController:event animated:YES];         
    }    
    if(indexPath.row == 3)
    {
        MyReviewViewController *review = [[MyReviewViewController alloc] initWithNibName:@"MyReviewViewController" bundle:nil];
        [self.navigationController pushViewController:review animated:YES];         

    }
    if(indexPath.row == 4)
    {
        ContactUsViewController *contactUsView =[[ContactUsViewController alloc]initWithNibName:@"ContactUsView" bundle:nil];
        [self.navigationController pushViewController:contactUsView animated:YES]; 
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

@end
