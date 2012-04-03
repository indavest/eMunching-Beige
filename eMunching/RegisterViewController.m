//
//  RegisterViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 26/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "ModalUIPickerViewController.h"
#import "ConfirmationViewController.h"
#import "Reachability.h"

#import "Objects.h"
#import "SecurityWrapper.h"

@interface RegisterViewController (PrivateMethods)

- (void) uiPickerPopUpDisplay;
- (void) animatePickerUp;
- (void) animatePickerDown;

- (void) getRestaurantLocations;

@end

@implementation RegisterViewController

@synthesize scrollView  = m_scrollView;

@synthesize navBar      = m_navBar;

@synthesize modalPicker = m_modalPicker;

@synthesize emailHeader     = m_emailHeader;
@synthesize passwordHeader  = m_passwordHeader;
@synthesize retypePwdHeader = m_retypePwdHeader;
@synthesize firstNameHeader = m_firstNameHeader;
@synthesize lastNameHeader  = m_lastNameHeader;
@synthesize phoneNoHeader   = m_phoneNoHeader;
@synthesize locationHeader  = m_locationHeader;


@synthesize email    = m_email;
@synthesize password = m_password;
@synthesize retypePassword = m_retypePassword;
@synthesize firstName = m_firstName;
@synthesize lastName  = m_lastName;
@synthesize phoneNo   = m_phoneNo;
@synthesize location  = m_location;

@synthesize registerResults         = m_registerResults;
@synthesize workingPropertyString   = m_workingPropertyString;
@synthesize elementsToParse         = m_elementsToParse;
@synthesize storingCharacterData    = m_storingCharacterData;

@synthesize registerStatusString    = m_registerStatusString;



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
    
    [m_location setText:[[[ApplicationManager instance].dataCacheManager preferredLocation] locationName]];
    
    //Set colors from templates   
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_scrollView setBackgroundColor:BACKGROUNDCOLOR];
    [m_navBar setTintColor:TINTCOLOR];
    
    [m_emailHeader     setTextColor:TEXTCOLOR2];
    [m_email           setTextColor:TEXTCOLOR1];    
    [m_passwordHeader  setTextColor:TEXTCOLOR2];   
    [m_password        setTextColor:TEXTCOLOR1];    
    [m_retypePwdHeader setTextColor:TEXTCOLOR2];   
    [m_retypePassword  setTextColor:TEXTCOLOR1];    
    [m_firstNameHeader setTextColor:TEXTCOLOR2];
    [m_firstName       setTextColor:TEXTCOLOR1];    
    [m_lastNameHeader  setTextColor:TEXTCOLOR2];   
    [m_lastName        setTextColor:TEXTCOLOR1];    
    [m_phoneNoHeader   setTextColor:TEXTCOLOR2];   
    [m_phoneNo         setTextColor:TEXTCOLOR1];    
    [m_locationHeader  setTextColor:TEXTCOLOR2];     
    [m_location        setTextColor:TEXTCOLOR1];
    
    [m_emailHeader     setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
    [m_passwordHeader  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];  
    [m_retypePwdHeader setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]]; 
    [m_firstNameHeader setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]]; 
    [m_lastNameHeader  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
    [m_phoneNoHeader   setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]]; 
    [m_locationHeader  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];  
    
     
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"Register" withError:&error];
}

-(void)registerUser
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
    
    NSString *locationID = @"1";
    if ([[ApplicationManager instance].dataCacheManager preferredLocation] != nil)
    {
        Location *prefLocation = [[ApplicationManager instance].dataCacheManager preferredLocation];
        locationID = [prefLocation locationId];
    }
    
    self.workingPropertyString = [NSMutableString string];
      
    
    //Generating SaltString and encrypted password to be passed to web service while registering user
    
    NSString *saltString = [SecurityWrapper FZARandomSalt];
    NSLog(@"saltString:%@", saltString);
    
    NSString *encryptedPassword = [SecurityWrapper sha256:[NSString stringWithFormat:@"%@%@%@", m_email.text, saltString, m_password.text]];
    NSLog(@"encryptedPassword:%@",encryptedPassword);
    
    NSString *soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<RegisterRestaurantUser xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<RestaurantID>%i</RestaurantID>\n"
    "<RestaurantLocaID>%@</RestaurantLocaID>\n"
    "<FirstName>%@</FirstName>\n"
    "<LastName>%@</LastName>\n"
    "<Email>%@</Email>\n"
    "<Salt>%@</Salt>\n"                        
    "<RPassword>%@</RPassword>\n"
    "<Phone>%@</Phone>\n"
    "</RegisterRestaurantUser>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n", RESTAURANT_ID, locationID, m_firstName.text, m_lastName.text, m_email.text, saltString, encryptedPassword, m_phoneNo.text];
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/RegisterRestaurantUser" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
   
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

    if( theConnection )
    {
        m_registerResults  = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}

-(void) connection:(NSURLConnection *) connection 
didReceiveResponse:(NSURLResponse *) response 
{
    [m_registerResults setLength:0];
}


-(void) connection:(NSURLConnection *) connection 
    didReceiveData:(NSData *) data 
{
    [m_registerResults appendData:data];
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error 
{
    [m_registerResults release];
    [connection release];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    NSLog(@"DONE. Received Bytes: %d", [m_registerResults length]);
    
    NSString *theXML1 = [[NSString alloc] 
                         initWithBytes: [m_registerResults mutableBytes] 
                         length:[m_registerResults length] 
                         encoding:NSUTF8StringEncoding];
    
    //---shows the XML---
    NSLog(@"%@",theXML1);
    
    [theXML1 release];  
    
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:m_registerResults]autorelease];
    [parser setDelegate:self];
    [parser parse];
    
    [connection release];
    [m_registerResults release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"RegisterRestaurantUserResult"])
    {
        m_workingPropertyString = [[NSMutableString alloc] init];
    }
    
    m_storingCharacterData = YES; 
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if (m_storingCharacterData)
    {
        NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //[m_workingPropertyString setString:@""];  // clear the string for next time
        if ([elementName isEqualToString:@"RegisterRestaurantUserResult"])
        {
            self.registerStatusString = trimmedString;
        }
        
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(m_storingCharacterData)
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
     NSLog(@"%@", self.registerStatusString);
    
    [m_activityIndicator stopAnimating];
    m_activityIndicator.hidden = YES;
    [m_activityIndicator release];
    
    if([self.registerStatusString isEqualToString:@"User successfully created and email sent."])
    {
        [[ApplicationManager instance].dataCacheManager setEmailId:m_email.text];
        [[ApplicationManager instance].dataCacheManager setPassword:m_password.text];
        [[ApplicationManager instance].dataCacheManager setRegisterStatus:TRUE];
        [[ApplicationManager instance].dataCacheManager setAuthenticationStatus:FALSE];
        [[ApplicationManager instance].dataCacheManager setLoginStatus:FALSE];
        [[ApplicationManager instance].dataCacheManager setPhoneNumber:m_phoneNo.text];  
        [[ApplicationManager instance].dataCacheManager setFirstName  :m_firstName.text];
        [[ApplicationManager instance].dataCacheManager setLastName:m_lastName.text]; 
        
        ConfirmationViewController *confirmationView =[[ConfirmationViewController alloc]initWithNibName:@"ConfirmationViewController" bundle:nil];
        [self presentModalViewController:confirmationView animated:YES];
    }
    else
    {
        UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Registration Failed!" message:self.registerStatusString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [fail show];
        [fail release];
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

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 160; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == m_retypePassword)
    {
        [self animateTextField:textField up:YES];
    }
    
    if(textField == m_firstName)
    {
       [self animateTextField: textField up: YES]; 
    }
    
    if(textField == m_lastName)
    {
        [self animateTextField: textField up: YES]; 
    }
    if(textField == m_phoneNo)
    {
        [self animateTextField: textField up: YES]; 
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField == m_retypePassword)
    {
        [self animateTextField:textField up:NO];
    }
       
    if(textField == m_firstName)
    {
        [self animateTextField: textField up: NO]; 
    }
    
    if(textField == m_lastName)
    {
        [self animateTextField: textField up: NO]; 
    }
    if(textField == m_phoneNo)
    {
        [self animateTextField: textField up: NO]; 
    }
}

-(IBAction)selectLocation:(id)sender
{
    [self uiPickerPopUpDisplay];
}

- (void) uiPickerPopUpDisplay
{
    if (m_modalPicker == nil)
        m_modalPicker = [[ModalUIPickerViewController alloc] initWithNibName:@"ModalUIPickerView" bundle:nil];
    
    [[m_modalPicker view] setFrame:CGRectMake(0, 
                                              480, 
                                              m_modalPicker.view.frame.size.width, 
                                              m_modalPicker.view.frame.size.height)];

    NSMutableArray *locations = [[[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager locations]] autorelease];
    
    for(int i=0;i<[locations count];i++)
    {
        Location *location = [locations objectAtIndex:i];
        [[m_modalPicker pickerValues] addObject:[location locationName]];
    }
    
    // Setup the array
    [m_modalPicker setDelegate:self];
    
    [self animatePickerUp];
}

- (void) animatePickerUp
{
    // Animate Up from bottom
    [UIView beginAnimations:@"" context:NULL];
    [[m_modalPicker view] setFrame: CGRectMake(0,
                                               self.view.frame.size.height - m_modalPicker.view.frame.size.height,
                                               m_modalPicker.view.frame.size.width,
                                               m_modalPicker.view.frame.size.height)];
    //The animation duration
    [UIView setAnimationDuration:8.0];
    [[self view] addSubview:[m_modalPicker view]];
    [UIView commitAnimations];
    
}

- (void) animatePickerDown
{
    // Animate Up from bottom
    [UIView beginAnimations:@"" context:NULL];
    [[m_modalPicker view] setFrame: CGRectMake(0,
                                               self.view.frame.size.height,
                                               m_modalPicker.view.frame.size.width,
                                               m_modalPicker.view.frame.size.height)];
    //The animation duration
    [UIView setAnimationDuration:8.0];
    [UIView commitAnimations];
}


#pragma mark - 
#pragma ModalPickerDelegate
- (void) stringResultSelected:(NSString*)selected
{
    [m_location setText:selected];
    [self animatePickerDown];
    
    NSMutableArray *locations = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager locations]];
    
    for(int i=0;i<[locations count];i++)
    {
        if ([selected isEqualToString:[[locations objectAtIndex:i] locationName]])
        {
            Location *location = [locations objectAtIndex:i];
            [[ApplicationManager instance].dataCacheManager setPreferredLocation:location];
        }
    }
    
    [locations release];
}

- (void) cancelSelected
{
    
   
    [self animatePickerDown];
}

-(IBAction) cancelButton:(id)sender
{
    [[ApplicationManager instance].dataCacheManager setPhoneNumber:m_phoneNo.text];  
    [[ApplicationManager instance].dataCacheManager setFirstName  :m_firstName.text];
    [[ApplicationManager instance].dataCacheManager setPassword   :m_password .text]; 

    [[ApplicationManager instance].dataCacheManager setEmailId:m_email.text];
    [[ApplicationManager instance].dataCacheManager setLastName:m_lastName.text]; 

    [self dismissModalViewControllerAnimated:YES];
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

-(BOOL)lengthValidation: (int) index
{   
    int length = 0;
    NSString *errorMsg1;
    NSString *errorMsg2;
    
    if (index == 0)
    {
        length = [m_password.text length];
        errorMsg1 = @"Check Password!";
        errorMsg2 = @"Please enter a valid password";
    }
    else if (index == 1)
    {
        length = [m_retypePassword.text length];
        errorMsg1 = @"Retype Same Password";
        errorMsg2 = @"Please retype a valid matching password";
    }
    else if (index == 2)
    {
        length = [m_firstName.text length];
        errorMsg1 = @"Check First Name!";
        errorMsg2 = @"Please enter a valid first name";
    }
    else if (index == 3)
    {
        length = [m_lastName.text length];
        errorMsg1 = @"Check Last Name!";
        errorMsg2 = @"Please enter a valid last name";
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

-(BOOL)passwordMatching
{
    if([m_retypePassword.text isEqualToString: m_password.text])
    {
        NSLog(@"Password Match");
        return TRUE;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Retype Same Password" message:@"Please retype a valid matching password" delegate:nil cancelButtonTitle:@"OK"    otherButtonTitles:nil];
        [alert show];
        [alert release];   
        return FALSE;
    }
}

-(BOOL)phoneNoValidation
{
//    NSString *phoneRegEx = @"^\\+(?:[0-9] ?){7,11}[0-9]$";
    NSString *phoneRegEx = @"^\\d+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegEx];
    //Valid email address
    if ([phoneTest evaluateWithObject:m_phoneNo.text] == YES) 
    {
        return TRUE;
    }
    else
    {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Phone Number!" message:@"Please enter the phone number in internationl format: \n + \'countrycode\' \'number\'"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
 
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Phone Number" message:@"Please enter a valid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return FALSE;
    }
}

-(IBAction) Done:(id)sender
{
    [m_email resignFirstResponder];
    [m_password resignFirstResponder];
    [m_retypePassword resignFirstResponder];
    [m_firstName resignFirstResponder];
    [m_lastName resignFirstResponder];
    [m_phoneNo resignFirstResponder];
    
    
    if ([self emailValidation])
    {
        if ([self lengthValidation:0])
        {
            if ([self lengthValidation:1])
            {
                if ( [self passwordMatching])
                {
                    if ([self lengthValidation:2])
                    {
                        if ([self lengthValidation:3])
                        {
                            if ([self phoneNoValidation])
                            {
                                [self registerUser];
                            }
                        }
                    }
                }
            }
        }
    }
}

@end
