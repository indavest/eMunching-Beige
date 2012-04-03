//
//  SubmitReviewViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubmitReviewViewController.h"
#import "Reachability.h"
#import "SignInViewController.h"

@interface SubmitReviewViewController (PrivateMethods)

    -(void)submitReview ;
    -(void)submit;

@end

@implementation SubmitReviewViewController

@synthesize reviewText = m_reviewText;
@synthesize rating = m_rating;

@synthesize fetchedResults          = m_fetchedResults;
@synthesize workingPropertyString   = m_workingPropertyString;
@synthesize storingCharacterData    = m_storingCharacterData;
@synthesize reviewStatusString      = m_reviewStatusString;

@synthesize rateView = m_rateView;


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
    [m_fetchedResults release];
    [m_workingPropertyString release];
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
    self.navigationItem.title = @"My Review";
    //Add a My Order button to RightBarButtonItem
    UIBarButtonItem *myOrderButton = [[UIBarButtonItem alloc] 
                                      initWithTitle:@"Submit"                                            
                                      style:UIBarButtonItemStyleBordered 
                                      target:self 
                                      action:@selector(submit)];
    
    self.navigationItem.rightBarButtonItem = myOrderButton;
    
    
    m_rateView.notSelectedImage = [UIImage imageNamed:@"star_inactive.png"];
    m_rateView.halfSelectedImage = [UIImage imageNamed:@"star_active.png"];
    m_rateView.fullSelectedImage = [UIImage imageNamed:@"star_active.png"];
    m_rateView.rating = 0;
    m_rateView.editable = YES;
    m_rateView.maxRating = 5;
    m_rateView.delegate = self;
    
    //Set colors from templates    
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
    
    [m_reviewText setTextColor:TEXTCOLOR1];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"SubmitReviews" withError:&error];
}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    //Here the "rating" will give the rating in numbers
    self.rating = [NSString stringWithFormat:@"%.0f", rating];
}

-(BOOL)lengthValidation: (int) index
{   
    int length = 0;
    NSString *errorMsg1;
    NSString *errorMsg2;
    
    
    if (index == 0)
    {
        length = [m_reviewText.text length];
        errorMsg1 = @"Check Review!";
        errorMsg2 = @"Please enter your review";        
    }
    
    if (index == 1)
    {
        length = m_rating.intValue;
        errorMsg1 = @"Check Rating!";
        errorMsg2 = @"Please enter your rating";        
    }
    
    //Valid length
    if (length) 
    {
        return TRUE; 
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorMsg1 message:errorMsg2 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	    [alert show];
	    [alert release];
        
        return FALSE;
    }
}

-(void)submit
{
    if ([[ApplicationManager instance].dataCacheManager loginStatus] == FALSE)
    {
        SignInViewController *signIn =[[SignInViewController alloc]initWithNibName:@"SignInViewController" bundle:nil];
        [self presentModalViewController:signIn animated:YES];        
    }
    else
    {
        if ([self lengthValidation:0])
        {
            if ([self lengthValidation:1])
            {
                [self submitReview];
            }
        }
    }
}

-(void)submitReview //Server call
{
    NSLog(@"Clicked");
   Reachability *reachability = [Reachability reachabilityForInternetConnection];  
   NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Please check you data connection and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    
    NSString *locationID = @"1";
    if ([[ApplicationManager instance].dataCacheManager preferredLocation] != nil)
    {
        Location *prefLocation = [[ApplicationManager instance].dataCacheManager preferredLocation];
        locationID = [prefLocation locationId];
    }
            
    NSString *UserId = [[ApplicationManager instance].dataCacheManager emailId];
    
    NSString *starRating = m_rating;
    NSLog(@"%@",starRating);

           
    NSString *soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<CreateReview xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<UserId>%@</UserId>\n"
    "<Restaurant>%i</Restaurant>\n"
    "<LocaID>%@</LocaID>\n"
    "<Rating>%@</Rating>\n"
    "<Review>%@</Review>\n"
    "</CreateReview>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n",UserId,RESTAURANT_ID,locationID,starRating,m_reviewText.text];
    
   
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/CreateReview" forHTTPHeaderField:@"SOAPAction"];
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

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"CreateReviewResult"])
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
        if ([elementName isEqualToString:@"CreateReviewResult"])
        {
            self.reviewStatusString = trimmedString;
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
    
    int returnValue = [m_reviewStatusString integerValue];
    
    bool status;
    if (returnValue >0)
        status = TRUE;
    else
        status = FALSE;
    
    NSLog(status ? @"Yes" : @"No");
    
    [m_activityIndicator stopAnimating];
    m_activityIndicator.hidden = YES;
    [m_activityIndicator release];
    
    if(status)
    {
                
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Review Submitted!" message:@"We value your feedback. Thank you for the effort!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [success show];
        [success release];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Review not Submitted!" message:@"We are unable to submit reviews now. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [fail show];
        [fail release];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
   [m_reviewText becomeFirstResponder];
    m_rating = @"0";
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
