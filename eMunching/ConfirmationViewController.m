//
//  ConfirmationViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 27/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConfirmationViewController.h"
#import "FontLabel.h"
#import "MyOrderViewController.h"
#import "SignInViewController.h"
#import "Reachability.h"

@implementation ConfirmationViewController

@synthesize navBar = m_navBar;

@synthesize confirmationPrompt     = m_confirmationPrompt;
@synthesize confirmationCodeHeader = m_confirmationCodeHeader;
@synthesize confirmationCode       = m_confirmationCode;

@synthesize fetchedResults              = m_fetchedResults;
@synthesize workingPropertyString       = m_workingPropertyString;
@synthesize storingCharacterData        = m_storingCharacterData;
@synthesize authenticationStatusString  = m_authenticationStatusString;


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
    
    //Set colors from templates   
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_navBar setTintColor:TINTCOLOR];    
    [m_confirmationPrompt     setTextColor:TEXTCOLOR5];
    [m_confirmationCodeHeader setTextColor:TEXTCOLOR2];
    [m_confirmationCode       setTextColor:TEXTCOLOR1];

    [m_confirmationPrompt setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];
    [m_confirmationPrompt setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"RegistrationConfirm" withError:&error];
}

-(void)authenticateUser
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
    
    self.workingPropertyString = [NSMutableString string];
    NSString *userId = [[ApplicationManager instance].dataCacheManager emailId];
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<AuthenticateUser xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<UserID>%@</UserID>\n"
    "<AuthenticationCode>%@</AuthenticationCode>\n"
    "</AuthenticateUser>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n",userId,m_confirmationCode.text];
                             
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
      
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/AuthenticateUser" forHTTPHeaderField:@"SOAPAction"];
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
    
    if ([elementName isEqualToString:@"IsValid"])
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
        if ([elementName isEqualToString:@"IsValid"])
        {
            self.authenticationStatusString = trimmedString;
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
    
    BOOL status = [m_authenticationStatusString boolValue];
    NSLog(status ? @"Yes" : @"No");
    
    [m_activityIndicator stopAnimating];
    m_activityIndicator.hidden = YES;
    [m_activityIndicator release];
    
    if(status)
    {
        [[ApplicationManager instance].dataCacheManager setAuthenticationStatus:TRUE];
        [[ApplicationManager instance].dataCacheManager setLoginStatus:TRUE];
        
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Sucess!" message:@"You are now signed in"
                                                         delegate:self cancelButtonTitle:nil  otherButtonTitles:@"OK", nil];
        [success show];
        [success release];
    }
    else
    {
        UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Authentication Failed!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [fail show];
        [fail release];
    }
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        if ([self respondsToSelector:@selector(presentingViewController)]) 
        {
            if ([self.presentingViewController isKindOfClass:[SignInViewController class]])
                [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
            else
                [self.presentingViewController.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
        } 
        else 
        {
            if ([self.parentViewController isKindOfClass:[SignInViewController class]])
                [self.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
            else
                [self.parentViewController.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
        }
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

-(IBAction)cancel:(id) sender
{
    if ([self respondsToSelector:@selector(presentingViewController)]) 
    {
        if ([self.presentingViewController isKindOfClass:[SignInViewController class]])
            [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
        else
            [self.presentingViewController.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
    } 
    else 
    {
        if ([self.parentViewController isKindOfClass:[SignInViewController class]])
            [self.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
        else
            [self.parentViewController.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
    }
}  
 
-(IBAction)confirm:(id)sender
{
    [m_confirmationCode resignFirstResponder];
    
    //server call
    [self authenticateUser];
}

-(IBAction)doneButtononKeyBoard:(id)sender
{
    [m_confirmationCode resignFirstResponder];
    [self authenticateUser];
    
}

@end
