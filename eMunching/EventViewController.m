//
//  EventViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 06/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventViewController.h"
#import "EventTableViewCell.h"
#import "WebViewController.h"
#import "Reachability.h"


@interface EventViewController (PrivateMethods)

    -(void) getEvents;
@end

@implementation EventViewController
@synthesize eventsTable = m_eventsTable;

@synthesize currentEvents           = m_currentEvents;
@synthesize fetchedResults          = m_fetchedResults;
@synthesize parsedEvents            = m_parsedEvents;
@synthesize event                   = m_event;
@synthesize elementsToParse         = m_elementsToParse;
@synthesize workingPropertyString   = m_workingPropertyString;
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
    [m_parsedEvents release];
    [m_workingPropertyString release];
    [m_fetchedResults release];
    [m_currentEvents release];
    [m_event release];
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
    
    self.navigationItem.title = @"Events";
    
    [self getEvents];
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_eventsTable setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
}


-(void)getEvents
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
    
    self.parsedEvents= [NSMutableArray array];
    self.workingPropertyString = [NSMutableString string];
    
    self.elementsToParse = [[NSMutableArray alloc] init];
    [self.elementsToParse addObject:@"EventTitle"];
    [self.elementsToParse addObject:@"EventDesc"];
    [self.elementsToParse addObject:@"EventDate"];
    [self.elementsToParse addObject:@"EventTime"];
    

    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<GetEvents_XML xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<RestaurantID>%i</RestaurantID>\n"
    "</GetEvents_XML>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n",RESTAURANT_ID];
    
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/GetEvents_XML" forHTTPHeaderField:@"SOAPAction"];
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
    if ([elementName isEqualToString:@"Event"])
	{
        self.event = [[[Event alloc] init] autorelease];
    }
    
    m_storingCharacterData = [m_elementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if (self.event)
	{
        if (m_storingCharacterData)
        {
            NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [m_workingPropertyString setString:@""];  // clear the string for next time
            
            if ([elementName isEqualToString:@"EventTitle"])
            {
                self.event.eventName = trimmedString;                
            }
            else if ([elementName isEqualToString:@"EventDesc"])
            {
                self.event.eventDesc = trimmedString;                
            }
            else if ([elementName isEqualToString:@"EventDate"])
            {
                self.event.eventDate = trimmedString;
            }
            else if ([elementName isEqualToString:@"EventTime"])
            {
                self.event.eventTime = trimmedString;
            }      
        }
        
        if ([elementName isEqualToString:@"Event"])
        {
            [self.parsedEvents addObject:self.event];  
            self.event = nil;
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
    
    [[ApplicationManager instance].dataCacheManager setRestaurantEvent:m_parsedEvents];
    
    [[self eventsTable] reloadData];
    
    [m_activityIndicator stopAnimating];
    m_activityIndicator.hidden = YES;
    [m_activityIndicator release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"Events" withError:&error];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    [m_currentEvents release];
    m_currentEvents = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager restaurantEvent]];
    
    return [m_currentEvents count];   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%i%i",[indexPath section],[indexPath row]];
    
    // Configure the cell...
    EventTableViewCell *tableCell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EventTableViewCell" owner:nil options:nil];
    
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[EventTableViewCell class]])
        {
            tableCell = (EventTableViewCell*)currentObject;
            break;	
        }
    }
    
    if ([indexPath row]%2 != 0)
    {
        [[tableCell backgroundImage] setImage:[UIImage imageNamed:@"events_bg_brown.png"]];
        [[tableCell eventName] setTextColor:TEXTCOLOR1];
        [[tableCell eventDate] setTextColor:TEXTCOLOR3];
        [[tableCell eventTime] setTextColor:TEXTCOLOR3];
    }
    else
    {
        [[tableCell backgroundImage] setImage:[UIImage imageNamed:@"events_bg_white.png"]];
        [[tableCell eventName] setTextColor:TEXTCOLOR1];
        [[tableCell eventDate] setTextColor:TEXTCOLOR1];
        [[tableCell eventTime] setTextColor:TEXTCOLOR1];
    }
    
    Event *events = [m_currentEvents objectAtIndex:[indexPath row]];
       
    [[tableCell  eventName]   setText:[events eventName]];
    [[tableCell  eventDate]   setText:[[[NSString stringWithFormat:@"STARTS ON"]stringByAppendingString:@" : "]stringByAppendingString:[events eventDate]]];
    [[tableCell  eventTime]   setText:[[[NSString stringWithFormat:@"AT"]       stringByAppendingString:@"                : "]stringByAppendingString:[events eventTime]]];    
           
    
    [[tableCell eventName]  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];   
    
    [[tableCell eventDate]  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];    
    
    [[tableCell eventTime]  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];    
        
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return tableCell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *webPage = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    
    [webPage setDisplayPage:@"EventsPage"];
    [webPage setEventTitle :[[m_currentEvents objectAtIndex:[indexPath row]]eventName ]];
    [webPage setContentToDisplay:[[m_currentEvents  objectAtIndex:[indexPath row]] eventDesc]];
    
    [self.navigationController pushViewController:webPage animated:YES];   

    
}

@end
