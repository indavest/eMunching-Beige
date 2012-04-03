//
//  SignInViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 26/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "SignInViewController.h"
#import "RegisterViewController.h"
#import "ConfirmationViewController.h"
#import "Reachability.h"

#import "Objects.h"
#import "FontLabel.h"
#import "SecurityWrapper.h"


@implementation SignInViewController

@synthesize navBar = m_navBar;

@synthesize emailHeader          = m_emailHeader;
@synthesize passwordHeader       = m_passwordHeader;
@synthesize forgotPasswordPrompt = m_forgotPasswordPrompt;
@synthesize registerUserPrompt   = m_registerUserPrompt;

@synthesize email    = m_email;
@synthesize password = m_password;

@synthesize label1 = m_label1;
@synthesize label2 = m_label2;

@synthesize firstName         = m_firstName;
@synthesize lastName          = m_lastName;
@synthesize phoneNumber       = m_phoneNumber;
@synthesize preferredLocation = m_preferredLocation;

@synthesize fetchedResults               = m_fetchedResults;
@synthesize forgotPasswordFetchedResults = m_forgotPasswordFetchedResults;
@synthesize workingPropertyString        = m_workingPropertyString;
@synthesize storingCharacterData         = m_storingCharacterData;
@synthesize storingCharacterData1        = m_storingCharacterData1;
@synthesize storingCharacterData2        = m_storingCharacterData2;
@synthesize loginStatusString            = m_loginStatusString;
@synthesize forgotPasswordStatusString   = m_forgotPasswordStatusString;
@synthesize saltStringFetchedResults     = m_saltStringFetchedResults;
@synthesize fetchedSaltString            = m_fetchedSaltString;

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
    [m_fetchedResults release];
    [m_forgotPasswordFetchedResults release];
    [m_workingPropertyString release];
    
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
    //Set colors from templates   
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_navBar setTintColor:TINTCOLOR];
    
    [m_emailHeader          setTextColor:TEXTCOLOR2];      
    [m_email                setTextColor:TEXTCOLOR1];    
    [m_passwordHeader       setTextColor:TEXTCOLOR2];    
    [m_password             setTextColor:TEXTCOLOR1];    
    [m_forgotPasswordPrompt setTextColor:TEXTCOLOR1];   
    [m_label1               setTextColor:TEXTCOLOR2];
    [m_label2               setTextColor:TEXTCOLOR2];    
    [m_registerUserPrompt   setTextColor:TEXTCOLOR3];
    
    [m_label1               setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];
    [m_label2               setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];
    
    [m_emailHeader          setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];  
    [m_passwordHeader       setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]]; 
    [m_forgotPasswordPrompt setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
    [m_registerUserPrompt   setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"SignIn" withError:&error];
}

-(void)getSaltByUserId
{
    m_serverCallMode = @"SaltString";
    
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
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<GetUserByUserID xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<UserID>%@</UserID>\n"
    "</GetUserByUserID>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n",m_email.text];
    
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/GetUserByUserID" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        m_saltStringFetchedResults = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }

}


-(void)loginUser
{
    m_serverCallMode = @"SignIn";
      
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

    NSString *soapMessage = [NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<LoginUser xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<RestaurantID>%i</RestaurantID>\n"
    "<UserID>%@</UserID>\n"
    "<UserPassword>%@</UserPassword>\n"
    "</LoginUser>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n",RESTAURANT_ID,m_email.text,m_encryptedPassword];


    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/LoginUser" forHTTPHeaderField:@"SOAPAction"];
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

-(void)forgotPassword
{    
    m_serverCallMode = @"ForgotPassword";
    
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
    
    
    NSString *soapMessage=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<GetForgottenPassword_XML xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<UserID>%@</UserID>\n"
    "<RestID>%i</RestID>\n"
    "</GetForgottenPassword_XML>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n",m_email.text,RESTAURANT_ID];
    
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/GetForgottenPassword_XML" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
       m_forgotPasswordFetchedResults = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}

-(void) connection:(NSURLConnection *) connection 
didReceiveResponse:(NSURLResponse *) response {
    if([m_serverCallMode isEqualToString:@"SignIn"])
    {
        [m_fetchedResults setLength: 0];
    }
    else if([m_serverCallMode isEqualToString:@"ForgotPassword"])
    {
        [m_forgotPasswordFetchedResults setLength:0];
    }
    else if([m_serverCallMode isEqualToString:@"SaltString"]) 
    {
        [m_saltStringFetchedResults setLength:0];        
    }
}


-(void) connection:(NSURLConnection *) connection 
    didReceiveData:(NSData *) data {
    if([m_serverCallMode isEqualToString:@"SignIn"])
    {
        [m_fetchedResults appendData:data];
    }
    else if([m_serverCallMode isEqualToString:@"ForgotPassword"])
    {
        [m_forgotPasswordFetchedResults appendData:data];
    }
    else if ([m_serverCallMode isEqualToString:@"SaltString"])
    {
        [m_saltStringFetchedResults appendData:data];
    }
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error {
    if([m_serverCallMode isEqualToString:@"SignIn"])
    {
        [m_fetchedResults release];
        [connection release];
    }
    else if([m_serverCallMode isEqualToString:@"ForgotPassword"])
    {
        [m_forgotPasswordFetchedResults release];
        [connection release];
    }
    else if([m_serverCallMode isEqualToString:@"SaltString"])
    {
        [m_saltStringFetchedResults release];
        [connection release];
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    
    if([m_serverCallMode isEqualToString:@"SignIn"])
    {
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
    else if([m_serverCallMode isEqualToString:@"ForgotPassword"])
    {
        NSLog(@"DONE. Received Bytes: %d", [m_forgotPasswordFetchedResults length]);
        
        NSString *theXML1 = [[NSString alloc] 
                            initWithBytes: [m_forgotPasswordFetchedResults mutableBytes] 
                            length:[m_forgotPasswordFetchedResults length] 
                            encoding:NSUTF8StringEncoding];
        
        //---shows the XML---
        NSLog(@"%@",theXML1);
        
        [theXML1 release];  
        
        NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:m_forgotPasswordFetchedResults]autorelease];
        [parser setDelegate:self];
        [parser parse];
        
        [connection release];
        [m_forgotPasswordFetchedResults release];
    }
    else if ([m_serverCallMode isEqualToString:@"SaltString"])
    {
        NSLog(@"DONE. Received Bytes: %d", [m_saltStringFetchedResults length]);
        
        NSString *theXML1 = [[NSString alloc] 
                             initWithBytes: [m_saltStringFetchedResults mutableBytes] 
                             length:[m_saltStringFetchedResults length] 
                             encoding:NSUTF8StringEncoding];
        
        //---shows the XML---
        NSLog(@"%@",theXML1);
        
        [theXML1 release];  
        
        NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:m_saltStringFetchedResults]autorelease];
        [parser setDelegate:self];
        [parser parse];
        
        [connection release];
        [m_saltStringFetchedResults release]; 
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if([m_serverCallMode isEqualToString:@"SignIn"])
    {
        if ([elementName isEqualToString:@"IsValid"])
        {
            m_workingPropertyString = [[NSMutableString alloc] init];
            m_storingCharacterData = YES;
        }
    }
    else if([m_serverCallMode isEqualToString:@"ForgotPassword"])
    {
        if ([elementName isEqualToString:@"Sent"])
        {
            m_workingPropertyString = [[NSMutableString alloc] init];
            m_storingCharacterData1 = YES;
        }        
    }
    else if ([m_serverCallMode isEqualToString:@"SaltString"])
    {
        if ([elementName isEqualToString:@"Salt"])
        {
            m_workingPropertyString = [[NSMutableString alloc] init];
            m_storingCharacterData2 = YES;
        } 
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if([m_serverCallMode isEqualToString:@"SignIn"])
    {
        
        if (m_storingCharacterData)
        {
            NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [m_workingPropertyString setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:@"IsValid"])
            {
                self.loginStatusString = trimmedString;
            }
            else if ([elementName isEqualToString:@"FirstName"])
            {
                self.firstName = trimmedString;
            }
            else if ([elementName isEqualToString:@"LastName"])
            {
                self.lastName = trimmedString;
            }
            else if ([elementName isEqualToString:@"PhoneNumber"])
            {
                self.phoneNumber = trimmedString;
            }
            else if ([elementName isEqualToString:@"PrefLoca"])
            {
                self.preferredLocation = trimmedString;
            }
        }
    }
    else if([m_serverCallMode isEqualToString:@"ForgotPassword"])
    {
        if(m_storingCharacterData1)
        {
            NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [m_workingPropertyString setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:@"Sent"])
            {
                self.forgotPasswordStatusString = trimmedString;
            }            
        }
    }
    else if ([m_serverCallMode isEqualToString:@"SaltString"])
    {
        if(m_storingCharacterData2)
        {
            NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [m_workingPropertyString setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:@"Salt"])
            {
                self.fetchedSaltString = trimmedString;
            }            
        }
 
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([m_serverCallMode isEqualToString:@"SignIn"])
    {
        if (m_storingCharacterData)
        {
            [m_workingPropertyString appendString:string];
        }
    }
    else if([m_serverCallMode isEqualToString:@"ForgotPassword"])
    {
        if (m_storingCharacterData1)
        {
            [m_workingPropertyString appendString:string];
        }
    }
    else if ([m_serverCallMode isEqualToString:@"SaltString"])
    {
        if (m_storingCharacterData2)
        {
            [m_workingPropertyString appendString:string];
        }
    }
        
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Check if parserDidEndDocument is called after parse error
    // If not, do the same actions as parserDidEndDocument
    
}


-(void)parserDidEndDocument:(NSXMLParser *)parser
{    
    if([m_serverCallMode isEqualToString:@"SignIn"])
    {
        BOOL boolValue = [m_loginStatusString boolValue];
        NSLog(boolValue ? @"Yes" : @"No");
        
        [m_activityIndicator stopAnimating];
        m_activityIndicator.hidden = YES;
        [m_activityIndicator release];
        
        if(boolValue)
        {
            [[ApplicationManager instance].dataCacheManager setEmailId:m_email.text];
            [[ApplicationManager instance].dataCacheManager setPassword:m_password.text];
            [[ApplicationManager instance].dataCacheManager setRegisterStatus:TRUE];
            [[ApplicationManager instance].dataCacheManager setAuthenticationStatus:TRUE];
            [[ApplicationManager instance].dataCacheManager setLoginStatus:TRUE];
            
            [[ApplicationManager instance].dataCacheManager setFirstName:m_firstName];
            [[ApplicationManager instance].dataCacheManager setLastName: m_lastName];
            [[ApplicationManager instance].dataCacheManager setPhoneNumber:m_phoneNumber];
            
            NSMutableArray *locations = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager locations]];
            
            for(int i=0;i<[locations count];i++)
            {
                if ([m_preferredLocation isEqualToString:[[locations objectAtIndex:i] locationId]])
                {
                    Location *location = [locations objectAtIndex:i];
                    [[ApplicationManager instance].dataCacheManager setPreferredLocation:location];
                }
            }
            
            [locations release];
            
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Sucess!" message:@"You are now signed in"
                                                             delegate:self cancelButtonTitle:nil  otherButtonTitles:@"OK", nil];
            [success show];
            [success release];
        }
        else
        {
            UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Login Failed!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [fail show];
            [fail release];
        }
    }
    else if([m_serverCallMode isEqualToString:@"ForgotPassword"])
    {
        BOOL boolValue = [m_forgotPasswordStatusString boolValue];
        NSLog(boolValue ? @"Yes" : @"No");
              
        [m_activityIndicator stopAnimating];
        m_activityIndicator.hidden = YES;
        [m_activityIndicator release];
        
        if(boolValue)
        {
                       
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Password Sent!" message:@"Your password has been sent to your registered email ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [success show];
            [success release];
        }
        else
        {
            UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Password Not Sent!" message:@"Please enter your registered email and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [fail show];
            [fail release];
        }
    }
    else if ([m_serverCallMode isEqualToString:@"SaltString"])
    {
        NSString *saltString = m_fetchedSaltString;
        NSLog(@"saltStringsignIn:%@",saltString);
        
        [m_activityIndicator stopAnimating];
        m_activityIndicator.hidden = YES;
        [m_activityIndicator release];
        
        if([saltString length])
        {             
            
             NSLog(@"email:%@",m_email.text);
            NSLog(@"password:%@",m_password.text);
            
            m_encryptedPassword = [SecurityWrapper sha256:[NSString stringWithFormat:@"%@%@%@", m_email.text, saltString, m_password.text]];
            NSLog(@"encryptedPassword%@",m_encryptedPassword);
            [self loginUser];
        }
        else
        {
            UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"We are unable to login you right now. Please call the restaurant for further assistance" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [fail show];
            [fail release];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        [self dismissModalViewControllerAnimated:YES];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)emailValidation
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    //Valid email address
    if ([emailTest evaluateWithObject:m_email.text] == YES) 
    {
        return TRUE; 
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Email!" message:@"Please enter a valid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	    [alert show];
	    [alert release];
        
        return FALSE;
     }
}

-(BOOL)passwordValidation
{    
    //Valid password
    if ([m_password.text length]) 
    {
        return TRUE; 
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Password!" message:@"Please enter a valid password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	    [alert show];
	    [alert release];
        
        return FALSE;
    }
}
    
-(IBAction) cancelButton:(id)sender
{
    NSLog(@"%@",[self.parentViewController.navigationItem title]);
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) signIn:(id)sender
{
    [m_password resignFirstResponder];
    [m_email resignFirstResponder];

    if ([self emailValidation])
    {
        if ([self passwordValidation])
        {
            [self getSaltByUserId];
        }
    }
}

-(IBAction) registerPage:(id)sender
{
    
    if ([[ApplicationManager instance].dataCacheManager registerStatus] == TRUE)
    {
        if ([[ApplicationManager instance].dataCacheManager authenticationStatus] == FALSE)
        {
            ConfirmationViewController *confirmationView =[[ConfirmationViewController alloc]initWithNibName:@"ConfirmationViewController" bundle:nil];
            [self presentModalViewController:confirmationView animated:YES];
        }
        else
        {
            UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Registration Complete" message:@"Please sign in using your email and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [fail show];
            [fail release];
        }
    }
    else
    {
        RegisterViewController *registerView =[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
        [self presentModalViewController:registerView animated:YES];
    }
    
}

-(IBAction) getPassword:(id) sender
{
    [m_password resignFirstResponder];
    [m_email resignFirstResponder];
    
    if ([self emailValidation])
    {
        [self forgotPassword];
    }
}

@end
