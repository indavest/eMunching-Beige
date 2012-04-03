//
//  MyReviewViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyReviewViewController.h"
#import "MyOrderViewController.h"
#import "SubmitReviewViewController.h"
#import "MyReviewTableViewCell.h"
#import "DetailReviewViewController.h"
#import "Reachability.h"

@interface MyReviewViewController (PrivateMethods)

    -(void) displayMyReview;
    -(void) getReviews;

@end

@implementation MyReviewViewController

@synthesize reviewTable = m_reviewTable;
@synthesize userReviews = m_userReviews;
@synthesize buttonLabel = m_buttonLabel;
@synthesize headerLabel = m_headerLabel;

@synthesize fetchedResults          = m_fetchedResults;
@synthesize parsedReviews           = m_parsedReviews;
@synthesize reviews                 = m_reviews;
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
    
    [m_parsedReviews release];
    [m_workingPropertyString release];
    [m_fetchedResults release];
    [m_userReviews release];
    [m_reviews release];

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

    self.navigationItem.title =@"Reviews";
    //Add a My Order button to RightBarButtonItem
    UIBarButtonItem *myOrderButton = [[UIBarButtonItem alloc] 
                                      initWithTitle:@"My Order"                                            
                                      style:UIBarButtonItemStyleBordered 
                                      target:self 
                                      action:@selector(displayMyOrder)];
    
    self.navigationItem.rightBarButtonItem = myOrderButton;        

    [self getReviews];
    
    //Set colors from templates   
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];  
    
    [m_buttonLabel setTextColor:TEXTCOLOR3];
    [m_headerLabel setTextColor:TEXTCOLOR1];
    
    [m_buttonLabel  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];   
    [m_headerLabel  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]]; 
}

-(void)viewDidAppear:(BOOL)animated
{
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"Reviews" withError:&error];
}

- (void) getReviews
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
    [m_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    m_activityIndicator.center = self.view.center;
    [self.view addSubview:m_activityIndicator];
    [m_activityIndicator startAnimating];     
    
    self.parsedReviews = [NSMutableArray array];
    self.workingPropertyString = [NSMutableString string];
    
    self.elementsToParse = [[NSMutableArray alloc] init];
    [self.elementsToParse addObject:@"Rating"];
    [self.elementsToParse addObject:@"ReviewText"];
    [self.elementsToParse addObject:@"ReviewDate"];
    [self.elementsToParse addObject:@"ReviewerName"];
    
    //Making a Soap Request to Server
    NSString *soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<GetReviews_XML xmlns=\"http://emunching.org/\">\n"
                            "<UserName>eMunch</UserName>\n"
                            "<PassWord>idnlgeah11</PassWord>\n"
                            "<RestaurantID>%i</RestaurantID>\n"
                            "</GetReviews_XML>\n"
                            "</soap:Body>\n"
                            "</soap:Envelope>\n",RESTAURANT_ID];
    
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/GetReviews_XML" forHTTPHeaderField:@"SOAPAction"];
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
    
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:m_fetchedResults] autorelease];
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
    if ([elementName isEqualToString:@"Review"])
	{
        self.reviews = [[[Review alloc] init] autorelease];
    }
    
    m_storingCharacterData = [m_elementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if (self.reviews)
	{
        if (m_storingCharacterData)
        {
            NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [m_workingPropertyString setString:@""];  // clear the string for next time

            if ([elementName isEqualToString:@"Rating"])
            {
                self.reviews.reviewRating = trimmedString;
                
            }
            else if ([elementName isEqualToString:@"ReviewText"])
            {
                self.reviews.reviewText = trimmedString;
                
            }
            else if ([elementName isEqualToString:@"ReviewDate"])
            {
                self.reviews.reviewDate = trimmedString;
            }
            else if ([elementName isEqualToString:@"ReviewerName"])
            {
                self.reviews.reviewName = trimmedString;
            }
        }
        
        if ([elementName isEqualToString:@"Review"])
        {
            [self.parsedReviews addObject:self.reviews];  
            self.reviews = nil;
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
    
    [[ApplicationManager instance].dataCacheManager setReviews:m_parsedReviews];
        
    [[self reviewTable] reloadData];
          
    [m_activityIndicator stopAnimating];
     m_activityIndicator.hidden = YES;
    [m_activityIndicator release];
}


-(void) displayMyOrder
{
   [[[[ApplicationManager instance].uiManager orderController] orderTable] reloadData];
   [self presentModalViewController:(UIViewController*)[[ApplicationManager instance].uiManager orderController] animated:YES];
}


-(IBAction)showMyReviewPage:(id)sender
{
    SubmitReviewViewController *submitReview = [[SubmitReviewViewController alloc]initWithNibName:@"SubmitReviewViewController" bundle:nil];
    [self.navigationController pushViewController:submitReview animated:YES]; 
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
     return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section
    [m_userReviews release];
    m_userReviews = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager reviews]];

    return [m_userReviews count];
}   

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%i%i",[indexPath section],[indexPath row]];
    
    // Configure the cell...
    MyReviewTableViewCell *tableCell = [[MyReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyReviewTableViewCell" owner:nil options:nil];
    
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[MyReviewTableViewCell class]])
        {
            tableCell = (MyReviewTableViewCell*)currentObject;
            break;	
        }
    }
       
    if ([indexPath row]%2 != 0)
    {
        [[tableCell backgroundImage] setImage:[UIImage imageNamed:@"shelf_reviews_blue.png"]];
//        [tableCell reverseLocations];
    }
    else
    {
        [[tableCell backgroundImage] setImage:[UIImage imageNamed:@"shelf_reviews_white.png"]];
    }
    [tableCell reverseLocations];
    
    Review *reviews = [m_userReviews objectAtIndex:[indexPath row]];
    
    [[tableCell reviewData]   setText:[reviews reviewText]];
    [[tableCell reviewData] setTextColor:TEXTCOLOR1];
    [[tableCell reviewName]   setText:[reviews reviewName]];
    [[tableCell reviewName] setTextColor:TEXTCOLOR1];
    
    [[tableCell reviewData]  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];   
    [[tableCell reviewName]  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]]; 
     
    NSString *starRating =[reviews reviewRating];
    NSLog(@"%@",starRating);
    
    if ([starRating isEqualToString:@"1"])
    {
        [[tableCell star1] setImage:[UIImage imageNamed:@"star_active.png"]];
    }
    else if ([starRating isEqualToString:@"2"])
    {
        [[tableCell star1] setImage:[UIImage imageNamed:@"star_active.png"]];
        [[tableCell star2] setImage:[UIImage imageNamed:@"star_active.png"]];
    }
    else if ([starRating isEqualToString:@"3"])
    {
        [[tableCell star1] setImage:[UIImage imageNamed:@"star_active.png"]];
        [[tableCell star2] setImage:[UIImage imageNamed:@"star_active.png"]];
        [[tableCell star3] setImage:[UIImage imageNamed:@"star_active.png"]];  
    }
    else if ([starRating isEqualToString:@"4"])
    {
        [[tableCell star1] setImage:[UIImage imageNamed:@"star_active.png"]];
        [[tableCell star2] setImage:[UIImage imageNamed:@"star_active.png"]];
        [[tableCell star3] setImage:[UIImage imageNamed:@"star_active.png"]];
        [[tableCell star4] setImage:[UIImage imageNamed:@"star_active.png"]];
    }
    else if ([starRating isEqualToString:@"5"])
    {
        [[tableCell star1] setImage:[UIImage imageNamed:@"star_active.png"]];
        [[tableCell star2] setImage:[UIImage imageNamed:@"star_active.png"]];
        [[tableCell star3] setImage:[UIImage imageNamed:@"star_active.png"]];
        [[tableCell star4] setImage:[UIImage imageNamed:@"star_active.png"]];
        [[tableCell star5] setImage:[UIImage imageNamed:@"star_active.png"]];
    }
    
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return tableCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailReviewViewController *detailReview = [[DetailReviewViewController alloc] initWithNibName:@"DetailReviewViewController" bundle:nil];
    
    [detailReview setPageToDisplay:@"detailedreview"];
    [detailReview setReviewDetail:[m_userReviews  objectAtIndex:[indexPath row]]];
   
    [self.navigationController pushViewController:detailReview animated:YES]; 
    [detailReview release];
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
