//
//  MyProfileViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 27/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ModalUIPickerViewController.h"
#import "Objects.h"
#import "Reachability.h"
#import "SecurityWrapper.h"

@interface MyProfileViewController (PrivateMethods)

- (void) uiPickerPopUpDisplay;
- (void) animatePickerUp;
- (void) animatePickerDown;
- (void) getSaltByUserId;

@end


@implementation MyProfileViewController

@synthesize scrollView     = m_scrollView;

@synthesize modalPicker       = m_modalPicker;

@synthesize emailIdHeader    = m_emailIdHeader;
@synthesize nameHeader       = m_nameHeader;
@synthesize phoneNoHeader    = m_phoneNoHeader;
@synthesize locationHeader   = m_locationHeader;
@synthesize currentPwdHeader = m_currentPwdHeader;
@synthesize changedPwdHeader = m_changedPwdHeader;
@synthesize retypePwdHeader  = m_retypePwdHeader;

@synthesize emailIdLabel      = m_emailIdLabel;
@synthesize nameLabel         = m_nameLabel;

@synthesize oldPassword           = m_oldPassword;
@synthesize changedPassword       = m_changedPassword;
@synthesize retypeChangedPassword = m_retypeChangedPassword;
@synthesize changedPhoneNo        = m_changedPhoneNo;
@synthesize changedLocation       = m_changedLocation;

@synthesize fetchedResults           = m_fetchedResults;
@synthesize saltStringFetchedResults = m_saltStringFetchedResults;
@synthesize workingPropertyString    = m_workingPropertyString;
@synthesize storingCharacterData     = m_storingCharacterData;
@synthesize storingCharacterData1    = m_storingCharacterData1;
@synthesize profileStatusString      = m_profileStatusString;
@synthesize fetchedSaltString        = m_fetchedSaltString;


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
    
    [m_scrollView setScrollEnabled:YES];
    [m_scrollView setContentSize:CGSizeMake(320,420)];
    
    self.title = @"My Profile";
        
//    [m_emailIdLabel  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]]; 
    
    UIBarButtonItem *submit = [[UIBarButtonItem alloc]
                             initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(Save:)]; 
    
    self.navigationItem.rightBarButtonItem = submit;
    
    [self getSaltByUserId];//Call to get Salt 
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_scrollView setBackgroundColor:BACKGROUNDCOLOR]; 
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
    
    [m_emailIdHeader         setTextColor:TEXTCOLOR2];
    [m_emailIdLabel          setTextColor:TEXTCOLOR4];
    [m_nameHeader            setTextColor:TEXTCOLOR2];
    [m_nameLabel             setTextColor:TEXTCOLOR1];
    [m_phoneNoHeader         setTextColor:TEXTCOLOR2];
    [m_changedPhoneNo        setTextColor:TEXTCOLOR1];
    [m_locationHeader        setTextColor:TEXTCOLOR2];
    [m_changedLocation       setTextColor:TEXTCOLOR1];
    [m_currentPwdHeader      setTextColor:TEXTCOLOR2];
    [m_oldPassword           setTextColor:TEXTCOLOR1];
    [m_changedPwdHeader      setTextColor:TEXTCOLOR2];
    [m_changedPassword       setTextColor:TEXTCOLOR1];
    [m_retypePwdHeader       setTextColor:TEXTCOLOR2];
    [m_retypeChangedPassword setTextColor:TEXTCOLOR1];
    
    [m_emailIdHeader    setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]]; 
    [m_nameHeader       setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
    [m_phoneNoHeader    setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
    [m_locationHeader   setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
    [m_currentPwdHeader setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
    [m_changedPwdHeader setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
    [m_retypePwdHeader  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[ApplicationManager instance].dataCacheManager emailId])
    {
        [m_emailIdLabel setText:[[ApplicationManager instance].dataCacheManager emailId]];
        
        NSString *firstName = [[ApplicationManager instance].dataCacheManager firstName];
        NSString *lastName = [[ApplicationManager instance].dataCacheManager lastName];
        NSString *name = [[firstName  stringByAppendingString:@" "]stringByAppendingString:lastName];
        [m_nameLabel setText:name];
        
        [m_changedPhoneNo   setText:[[ApplicationManager instance].dataCacheManager phoneNumber]];
        [m_changedLocation  setText:[[ApplicationManager instance].dataCacheManager preferredLocation].locationName];
    }
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"MyProfile" withError:&error];
}

- (void)getSaltByUserId
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
    
    NSString *emailId = [[ApplicationManager instance].dataCacheManager emailId];
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<GetUserByUserID xmlns=\"http://emunching.org/\">\n"
                             "<UserName>eMunch</UserName>\n"
                             "<PassWord>idnlgeah11</PassWord>\n"
                             "<UserID>%@</UserID>\n"
                             "</GetUserByUserID>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",emailId];
    
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


- (void)updateProfile
{
    m_serverCallMode = @"UpdateProfile";
    
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
    NSLog(@"%@",m_fetchedSaltString);
    NSLog(@"%@",m_changedPassword.text);
    NSLog(@"%@",m_emailIdLabel.text);
    
    
    NSString *m_encryptedPassword = [SecurityWrapper sha256:[NSString stringWithFormat:@"%@%@%@", m_emailIdLabel.text, m_fetchedSaltString, m_changedPassword.text]];
     NSLog(@"%@",m_encryptedPassword);
    
    NSString *soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<UpdateProfile xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<UserId>%@</UserId>\n"
    "<UserPassword>%@</UserPassword>\n"
    "<Phone>%@</Phone>\n"
    "<Location>%@</Location>\n"
    "</UpdateProfile>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n",m_emailIdLabel.text,m_encryptedPassword,m_changedPhoneNo.text,locationID];
 
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/UpdateProfile" forHTTPHeaderField:@"SOAPAction"];
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
    
    if([m_serverCallMode isEqualToString:@"SaltString"])
    {
        [m_saltStringFetchedResults setLength:0];
    }
    else if ([m_serverCallMode isEqualToString:@"UpdateProfile"])
    {
        [m_fetchedResults setLength: 0];
    }
}


-(void) connection:(NSURLConnection *) connection 
    didReceiveData:(NSData *) data {
    
    if([m_serverCallMode isEqualToString:@"SaltString"])
    {
        [m_saltStringFetchedResults appendData:data];
    }
    else if ([m_serverCallMode isEqualToString:@"UpdateProfile"])
    {    
        [m_fetchedResults appendData:data];
    }
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error {
    if([m_serverCallMode isEqualToString:@"SaltString"])
    {    
        [m_saltStringFetchedResults release];
        [connection release];
    }
    else if ([m_serverCallMode isEqualToString:@"UpdateProfile"])
    {        
        [m_fetchedResults release];   
        [connection release];
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    
    if([m_serverCallMode isEqualToString:@"SaltString"])
    {
        NSLog(@"DONE. Received Bytes: %d", [m_saltStringFetchedResults length]);
        
        NSString *theXML = [[NSString alloc] 
                            initWithBytes: [m_saltStringFetchedResults mutableBytes] 
                            length:[m_saltStringFetchedResults length] 
                            encoding:NSUTF8StringEncoding];
        
        //---shows the XML---
        NSLog(@"%@",theXML);
        
        [theXML release];  
        
        NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:m_saltStringFetchedResults]autorelease];
        [parser setDelegate:self];
        [parser parse];
        
        [connection release];
        [m_saltStringFetchedResults release];
    }
    else if ([m_serverCallMode isEqualToString:@"UpdateProfile"])
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
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([m_serverCallMode isEqualToString:@"SaltString"])
    {
        if ([elementName isEqualToString:@"Salt"])
        {
            m_workingPropertyString = [[NSMutableString alloc] init];
            m_storingCharacterData = YES;
        }
    }
    else if ([m_serverCallMode isEqualToString:@"UpdateProfile"])
    {    
        if ([elementName isEqualToString:@"UpdateProfileResult"])
        {
            m_workingPropertyString = [[NSMutableString alloc] init];
            m_storingCharacterData1 = YES;
        }
    }    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{   
    if ([m_serverCallMode isEqualToString:@"SaltString"])
    {
        if(m_storingCharacterData)
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
   else if ([m_serverCallMode isEqualToString:@"UpdateProfile"])
    {   
        if (m_storingCharacterData1)
        {
            NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [m_workingPropertyString setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:@"UpdateProfileResult"])
            {
                self.profileStatusString = trimmedString;
            }
            
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
   
    if ([m_serverCallMode isEqualToString:@"SaltString"])
    {
        if(m_storingCharacterData)
        {
            [m_workingPropertyString appendString:string];
        }
    }
    else if ([m_serverCallMode isEqualToString:@"UpdateProfile"])
    {    
        if (m_storingCharacterData1)
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
    
    if ([m_serverCallMode isEqualToString:@"SaltString"])
    {
        [m_activityIndicator stopAnimating];
        m_activityIndicator.hidden = YES;
        [m_activityIndicator release];
        
        if([m_fetchedSaltString length])
        {             
            return;          
        }
        else
        {
            UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Connection Error!" message:@"Please check your data connection and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [fail show];
            [fail release];
        }
    }
    else if ([m_serverCallMode isEqualToString:@"UpdateProfile"])
    {   
        int returnValue = [m_profileStatusString integerValue];
        
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
            [[ApplicationManager instance].dataCacheManager setPassword :m_retypeChangedPassword.text];
            [[ApplicationManager instance].dataCacheManager setPhoneNumber :m_changedPhoneNo.text];
            
            m_oldPassword.text = @"";
            m_changedPassword.text = @"";
            m_retypeChangedPassword.text = @"";
            
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Profile Updated!" message:@"Your profile has been updated with the new information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [success show];
            [success release];
        }
        else
        {
            UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Profile Not Updated!" message:@"Please check the entered details and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [fail show];
            [fail release];
        }
    }
}
    
  

-(BOOL)lengthValidation: (int) index
{   
    int length = 0;
    NSString *errorMsg1;
    NSString *errorMsg2;
    

    if (index == 0)
    {
        length = [m_changedPassword.text length];
        errorMsg1 = @"Check Password!";
        errorMsg2 = @"Please enter a valid new password";
        
    }
    else if (index == 1)
    {
        length = [m_retypeChangedPassword.text length];
        errorMsg1 = @"Retype Same Password";
        errorMsg2 = @"Please retype a valid matching password";
        
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
    if([m_retypeChangedPassword.text isEqualToString: m_changedPassword.text])
    {
        NSLog(@"Password Match");
        
        return TRUE;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwords dont match" message:@"Please enter a matching password" delegate:nil cancelButtonTitle:@"OK"    otherButtonTitles:nil];
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
    if ([phoneTest evaluateWithObject:m_changedPhoneNo.text] == YES) 
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

-(BOOL)currentPasswordCheck
{
    NSString *cachePassword = [[ApplicationManager instance].dataCacheManager password];    
    if([cachePassword isEqualToString:m_oldPassword.text])
    {
        return TRUE; 
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Current Password" message:@"Please check your current password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	    [alert show];
	    [alert release];
        return FALSE;
    }
}
 
-(IBAction)Save:(id)sender
{
    [m_oldPassword resignFirstResponder];
    [m_changedPassword resignFirstResponder];
    [m_retypeChangedPassword resignFirstResponder];
    [m_changedPhoneNo resignFirstResponder];
    
    if([self phoneNoValidation])
    {
        if ([self currentPasswordCheck])
        {
            if (![m_changedPassword.text length] && ![m_retypeChangedPassword.text length])
            {
                m_changedPassword.text = m_oldPassword.text;
                m_retypeChangedPassword.text = m_oldPassword.text;
            }
            
            if ( [self passwordMatching])
            {
                [self updateProfile];
            }
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance   = 170; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.scrollView.frame = CGRectOffset(self.scrollView.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == m_oldPassword)
    {
        [self animateTextField: textField up: NO]; 
    }
    if(textField == m_changedPassword)
    {
        [self animateTextField: textField up: NO]; 
    }
    else if(textField == m_retypeChangedPassword)
    {
        [self animateTextField: textField up: NO]; 
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == m_oldPassword)
    {
        [self animateTextField: textField up: YES]; 
    }
    if(textField == m_changedPassword)
    {
        [self animateTextField:textField up:YES];
    }
    else if(textField == m_retypeChangedPassword)
    {
        [self animateTextField:textField up:YES];
    }
}

-(IBAction)selectLocation:(id)sender
{
    [m_oldPassword resignFirstResponder];
    [m_changedPassword resignFirstResponder];
    [m_retypeChangedPassword resignFirstResponder];
    [m_changedPhoneNo resignFirstResponder];
    
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
    [m_changedLocation setText:selected];
    [self animatePickerDown];
    
    NSMutableArray *locations = [[[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager locations]] autorelease];
    
    for(int i=0;i<[locations count];i++)
    {
        if ([selected isEqualToString:[[locations objectAtIndex:i] locationName]])
        {
            Location *location = [locations objectAtIndex:i];
            [[ApplicationManager instance].dataCacheManager setPreferredLocation:location];
        }
    }
}

- (void) cancelSelected
{
    [self animatePickerDown];
}

-(IBAction) cancelButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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
