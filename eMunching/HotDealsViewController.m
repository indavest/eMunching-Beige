//
//  HotDealsViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 03/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HotDealsViewController.h"
#import "Reachability.h"
#import "Objects.h"
#import "HotDealsViewCell.h"
#import "WebViewController.h"


@interface HotDealsViewController (PrivateMethods)

-(void) getHotDeals;

@end

@implementation HotDealsViewController

@synthesize hotDealsTable = m_hotDealsTable;

@synthesize currentHotDeals         = m_currentHotDeals;
@synthesize fetchedResults          = m_fetchedResults;
@synthesize parsedHotDeals          = m_parsedHotDeals;
@synthesize hotDeal                 = m_hotDeal;
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

    self.navigationItem.title = @"Hot Deals"; 
    [self getHotDeals];
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_hotDealsTable setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];
}



-(void)getHotDeals
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
    
    self.parsedHotDeals        = [NSMutableArray array];
    self.workingPropertyString = [NSMutableString string];
    
    self.elementsToParse = [[NSMutableArray alloc] init];
    [self.elementsToParse addObject:@"Title"];
    [self.elementsToParse addObject:@"Desc"];
    [self.elementsToParse addObject:@"Thumbnail"];
    [self.elementsToParse addObject:@"Image"];
    [self.elementsToParse addObject:@"Type"];
    [self.elementsToParse addObject:@"Value"];
    [self.elementsToParse addObject:@"Starts"];
    [self.elementsToParse addObject:@"Expires"];
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
   "<soap:Body>\n"
   "<GetDeals_XML xmlns=\"http://emunching.org/\">\n"
   "<UserName>eMunch</UserName>\n"
   "<PassWord>idnlgeah11</PassWord>\n"
   "<RestaurantID>%i</RestaurantID>\n"
   "</GetDeals_XML>\n"
   "</soap:Body>\n"
   "</soap:Envelope>\n",RESTAURANT_ID];
    
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/GetDeals_XML" forHTTPHeaderField:@"SOAPAction"];
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
    if ([elementName isEqualToString:@"Deal"])
	{
        self.hotDeal = [[[HotDeal alloc] init] autorelease];
    }
    
    m_storingCharacterData = [m_elementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if (self.hotDeal)
	{
        if (m_storingCharacterData)
        {
            NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [m_workingPropertyString setString:@""];  // clear the string for next time
            
            if ([elementName isEqualToString:@"Title"])
            {
                self.hotDeal.dealTitle = trimmedString;                
            }
            else if ([elementName isEqualToString:@"Desc"])
            {
                self.hotDeal.dealDescription = trimmedString; 
            }
            else if ([elementName isEqualToString:@"Type"])
            {
                self.hotDeal.dealType = trimmedString;
            }
            else if ([elementName isEqualToString:@"Value"])
            {
                self.hotDeal.dealValue = trimmedString;
            } 
            else if ([elementName isEqualToString:@"Starts"])
            {
                self.hotDeal.dealStart = trimmedString;
            } 
            else if ([elementName isEqualToString:@"Expires"])
            {
                self.hotDeal.dealStop = trimmedString;
            }  
        }
        
        if ([elementName isEqualToString:@"Deal"])
        {
            [self.parsedHotDeals addObject:self.hotDeal];  
            self.hotDeal = nil;
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
    
    [[ApplicationManager instance].dataCacheManager setHotDeals:m_parsedHotDeals];
    
    [[self hotDealsTable] reloadData];
    
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
    [[GANTracker sharedTracker] trackPageview:@"HotDeals" withError:&error];
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
    [m_currentHotDeals release];
    m_currentHotDeals = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager hotDeals]];
    
    return [m_currentHotDeals count];   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%i%i",[indexPath section],[indexPath row]];
    
    // Configure the cell...
     HotDealsViewCell *tableCell = [[HotDealsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HotDealsViewCell" owner:nil options:nil];
    
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[HotDealsViewCell class]])
        {
            tableCell = (HotDealsViewCell*)currentObject;
            break;	
        }
    }
    
    if ([indexPath row]%2 != 0)
    {
        [[tableCell backgroundImage] setImage:[UIImage imageNamed:@"events_bg_brown.png"]];
        [[tableCell dealTitle] setTextColor:TEXTCOLOR1];
        [[tableCell dealStart] setTextColor:TEXTCOLOR3];
        [[tableCell dealExpire] setTextColor:TEXTCOLOR3];
    }
    else
    {
        [[tableCell backgroundImage] setImage:[UIImage imageNamed:@"events_bg_white.png"]];
        [[tableCell dealTitle] setTextColor:TEXTCOLOR1];
        [[tableCell dealStart] setTextColor:TEXTCOLOR1];
        [[tableCell dealExpire] setTextColor:TEXTCOLOR1];
    }
    
    HotDeal *hotDeals = [m_currentHotDeals objectAtIndex:[indexPath row]];
    
    [[tableCell dealTitle]   setText:[hotDeals dealTitle]];
    [[tableCell dealStart]   setText:[[[NSString stringWithFormat:@"STARTS ON"]stringByAppendingString:@" : "]stringByAppendingString:[hotDeals dealStart]]];
    [[tableCell dealExpire]  setText:[[[NSString stringWithFormat:@"ENDS ON   "]stringByAppendingString:@" : "]stringByAppendingString:[hotDeals dealStop]]];
    
    
    [[tableCell dealTitle]  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]]; 
    [[tableCell dealStart]  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];    
    [[tableCell dealExpire] setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]]; 
    
    
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return tableCell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *webPage = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    
    [webPage setDisplayPage:@"HotDealsPage"];
    [webPage setHotDealTitle:[[m_currentHotDeals objectAtIndex:[indexPath row]] dealTitle]];
    [webPage setContentToDisplay:[[m_currentHotDeals objectAtIndex:[indexPath row]] dealDescription]];
    
    [self.navigationController pushViewController:webPage animated:YES];   
}

@end
