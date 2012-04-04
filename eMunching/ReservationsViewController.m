//
//  ReservationViewController.m
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReservationsViewController.h"
#import "MyOrderViewController.h"
#import "ModalUIPickerViewController.h"
#import "DateSelectionViewController.h"
#import "Reachability.h"
#import "SignInViewController.h"


@interface ReservationsViewController (PrivateMethods)

- (void) displayMyOrder;
- (void) makeReservation;
- (void) uiPickerPopUpDisplay;
- (void) animatePickerUp;
- (void) animatePickerDown;

-(void)  GetRestaurantResvConfig;
-(void)  createReservation;

@end


@implementation ReservationsViewController

@synthesize scrollView      = m_scrollView;

@synthesize emailButton     = m_emailButton;
@synthesize emailIdLabel    = m_emailIdLabel;

@synthesize reserveEmailHeader     = m_reserveEmailHeader;
@synthesize reserveNameHeader      = m_reserveNameHeader;
@synthesize reservePhoneNoHeader   = m_reservePhoneNoHeader;
@synthesize reserveMessageHeader   = m_reserveMessageHeader;
@synthesize reserveLocationHeader  = m_reserveLocationHeader;
@synthesize reserveNoOfGuestHeader = m_reserveNoOfGuestHeader;
@synthesize reserveDateHeader      = m_reserveDateHeader;

@synthesize reserveName     = m_reserveName;
@synthesize reservePhoneNo  = m_reservePhoneNo;
@synthesize reserveMessage  = m_reserveMessage;
@synthesize reserveLocation = m_reserveLocation;
@synthesize numberOfGuest   = m_numberOfGuest;
@synthesize dateTimeLabel   = m_DateTimeLabel;

@synthesize fetchedResults          = m_fetchedResults;
@synthesize reserveConfigResults    = m_reserveConfigResults;
@synthesize workingPropertyString   = m_workingPropertyString;
@synthesize reservationStatusString = m_reservationStatusString;
@synthesize elementsToParse         = m_elementsToParse;

@synthesize parsedreservationConfig = m_parsedreservationConfig;
@synthesize reservationItem         = m_reservationItem;

@synthesize minDate                 = m_minDate;
@synthesize maxDate                 = m_maxDate;

@synthesize storingCharacterData    = m_storingCharacterData;
@synthesize storingCharacterData1   = m_storingCharacterData1;

@synthesize pickerSelector          = m_pickerSelector;
@synthesize locationModalPicker     = m_locationModalPicker;
@synthesize guestNoModalPicker      = m_guestNoModalPicker;




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
    
    [m_parsedreservationConfig release];
    [m_workingPropertyString release];
    [m_fetchedResults release];
    [m_reserveConfigResults release];
    [m_reservationItem release];
    
    [m_minDate release];
    [m_maxDate release];
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
    [m_scrollView setContentSize:CGSizeMake(320,420)];
        
    [[[self navigationItem] rightBarButtonItem] setTarget:self];
    [[[self navigationItem] rightBarButtonItem] setAction:@selector(displayMyOrder)];
       
    [[[self navigationItem] leftBarButtonItem] setTarget:self];
    [[[self navigationItem] leftBarButtonItem] setAction:@selector(makeReservation)];
    
    [self GetRestaurantResvConfig];
    
    [m_numberOfGuest setText:@"1"];
    
    m_minDate = [[NSDate alloc] init];
    m_maxDate = [[NSDate alloc] init];
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_scrollView setBackgroundColor:BACKGROUNDCOLOR];  
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
    
    [m_reserveEmailHeader     setTextColor:TEXTCOLOR2];
    [m_emailIdLabel           setTextColor:TEXTCOLOR4];   
    [m_reserveNameHeader      setTextColor:TEXTCOLOR2];     
    [m_reserveName            setTextColor:TEXTCOLOR1];    
    [m_reservePhoneNoHeader   setTextColor:TEXTCOLOR2];      
    [m_reservePhoneNo         setTextColor:TEXTCOLOR1];    
    [m_reserveMessageHeader   setTextColor:TEXTCOLOR2];
    [m_reserveMessage         setTextColor:TEXTCOLOR1];    
    [m_reserveLocationHeader  setTextColor:TEXTCOLOR2];  
    [m_reserveLocation        setTextColor:TEXTCOLOR1];    
    [m_reserveNoOfGuestHeader setTextColor:TEXTCOLOR2];
    [m_numberOfGuest          setTextColor:TEXTCOLOR1];    
    [m_reserveDateHeader      setTextColor:TEXTCOLOR2];     
    [m_DateTimeLabel          setTextColor:TEXTCOLOR1]; 
    
    [m_reserveEmailHeader     setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];  
    [m_reserveNameHeader      setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
    [m_reservePhoneNoHeader   setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]]; 
    [m_reserveMessageHeader   setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]]; 
    [m_reserveLocationHeader  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]]; 
    [m_reserveNoOfGuestHeader setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]]; 
    [m_reserveDateHeader      setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];      
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[ApplicationManager instance].dataCacheManager loginStatus] == TRUE)
    {
        [m_emailButton setUserInteractionEnabled:FALSE];
        [m_emailIdLabel setText:[[ApplicationManager instance].dataCacheManager emailId]];
        
        NSString *firstName = [[ApplicationManager instance].dataCacheManager firstName];
        NSString *lastName = [[ApplicationManager instance].dataCacheManager lastName];
        NSString *name = [[firstName  stringByAppendingString:@" "]stringByAppendingString:lastName];
        [m_reserveName setText:name];
        
        if ([m_reservePhoneNo.text isEqualToString:@""])
        {
            [m_reservePhoneNo setText:[[ApplicationManager instance].dataCacheManager phoneNumber]];
        }
    }
    else
    {
        [m_emailButton setUserInteractionEnabled:TRUE];
        [m_emailIdLabel setText:@""];
    }
    
    [m_reserveLocation setText:[[[ApplicationManager instance].dataCacheManager preferredLocation] locationName]];
    
    NSDate *dateTime =[[ApplicationManager instance].dataCacheManager selectedDate];
    
    NSDateFormatter *buttonDateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [buttonDateFormatter setDateFormat:@"EEE MMM d, YYYY,  h:mm aaa"];
    NSString *dateString = [buttonDateFormatter stringFromDate:dateTime];
    
    [m_DateTimeLabel setText:dateString];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"Reservation" withError:&error];
}


-(void)GetRestaurantResvConfig
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
    
    self.parsedreservationConfig = [NSMutableArray array];
    self.workingPropertyString   = [NSMutableString string];
    
    self.elementsToParse = [[NSMutableArray alloc] init];
    [self.elementsToParse addObject:@"Enabled"];
    [self.elementsToParse addObject:@"WeeksInAdvance"];
    [self.elementsToParse addObject:@"WeekDayStart"];
    [self.elementsToParse addObject:@"WeekDayStop"];
    [self.elementsToParse addObject:@"StartTime"];
    [self.elementsToParse addObject:@"StopTime"];
    [self.elementsToParse addObject:@"Interval"];
    [self.elementsToParse addObject:@"TableThreshold"];
    
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version =\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<GetRestaurantResvConfig_XML xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<RestaurantID>%i</RestaurantID>\n"
    "</GetRestaurantResvConfig_XML>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n",RESTAURANT_ID];
    
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/GetRestaurantResvConfig_XML" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        m_reserveConfigResults = [[NSMutableData data] retain];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
  
}


-(void)createReservation
{
    m_submitMode = TRUE;
    
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
    
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
    NSDate *dateTime = [[ApplicationManager instance].dataCacheManager selectedDate];
    [serverDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *selectedDateTime = [serverDateFormatter stringFromDate:dateTime];
    
    NSLog(@"%@",m_reserveName.text);
    NSLog(@"%@",m_reservePhoneNo.text);
    NSLog(@"%i",RESTAURANT_ID);
    NSLog(@"%@",locationID);
    NSLog(@"%@",m_emailIdLabel.text);
    NSLog(@"%@",m_numberOfGuest.text);
    NSLog(@"%@",selectedDateTime);
    
    NSString *soapMessage =[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
   "<soap:Body>\n"
   "<CreateReservation xmlns=\"http://emunching.org/\">\n"
   "<UserName>eMunch</UserName>\n"
   "<PassWord>idnlgeah11</PassWord>\n"
   "<ResName>%@</ResName>\n"
   "<CallBackNumber>%@</CallBackNumber>\n"
   "<RestaurantID>%i</RestaurantID>\n"
   "<RestaurantLocaID>%@</RestaurantLocaID>\n"
   "<UserID>%@</UserID>\n"
   "<NumGuests>%@</NumGuests>\n"
   "<TimeSlot>%@</TimeSlot>\n"
   "</CreateReservation>\n"
   "</soap:Body>\n"
   "</soap:Envelope>\n",m_reserveName.text,m_reservePhoneNo.text,RESTAURANT_ID,locationID,m_emailIdLabel.text,m_numberOfGuest.text,selectedDateTime];
                            
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/CreateReservation" forHTTPHeaderField:@"SOAPAction"];
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
didReceiveResponse:(NSURLResponse *) response 
{
    NSLog(@"Receieved Data");
    
    if(m_submitMode)
        [m_fetchedResults setLength: 0];
    else
        [m_reserveConfigResults setLength:0];
}


-(void) connection:(NSURLConnection *) connection 
    didReceiveData:(NSData *) data
{
    NSLog(@"Receieved Data");
    
    if(m_submitMode)
        [m_fetchedResults appendData:data];
    else
        [m_reserveConfigResults appendData:data];
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error 
{
    
    if(m_submitMode)
    {
        [m_fetchedResults release];
        [connection release];
    }
    else
    {
        [m_reserveConfigResults release];
        [connection release];
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    
    if(m_submitMode)
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
    else
    {
        NSLog(@"DONE. Received Bytes: %d", [m_reserveConfigResults length]);
        
        NSString *theXML1 = [[NSString alloc] 
                            initWithBytes: [m_reserveConfigResults mutableBytes] 
                            length:[m_reserveConfigResults length] 
                            encoding:NSUTF8StringEncoding];
        
        //---shows the XML---
        NSLog(@"%@",theXML1);
        
        [theXML1 release];  
        
        NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:m_reserveConfigResults]autorelease];
        [parser setDelegate:self];
        [parser parse];
        
        [connection release];
        [m_reserveConfigResults release];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if(m_submitMode)
    {
        if ([elementName isEqualToString:@"CreateReservationResult"])
        {
            m_workingPropertyString = [[NSMutableString alloc] init];
            m_storingCharacterData = YES;
        }
    }
    else
    {
        if ([elementName isEqualToString:@"ResvConfig"])
        {
            self.reservationItem = [[[Reservation alloc] init] autorelease];
        }
        
        m_storingCharacterData1 = [m_elementsToParse containsObject:elementName];
    }
        
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    
    if(m_submitMode)
    {
        if (m_storingCharacterData)
        {
            NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [m_workingPropertyString setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:@"ReturnString"])
            {
                self.reservationStatusString = trimmedString;
            }
         }
    }
    else
        if (self.reservationItem)
        {
            if (m_storingCharacterData1)
            {
                NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [m_workingPropertyString setString:@""];  // clear the string for next time
                if ([elementName isEqualToString:@"Enabled"])
                {
                    self.reservationItem.reservationEnabled = trimmedString;
                }     
                else if ([elementName isEqualToString:@"WeeksInAdvance"])
                {
                    self.reservationItem.reservationWeeksInAdvance = trimmedString;
                }
                else if ([elementName isEqualToString:@"WeekDayStart"])
                {        
                    self.reservationItem.reservationWeekDayStart = trimmedString;
                }
                else if ([elementName isEqualToString:@"WeekDayStop"])
                {
                    self.reservationItem.reservationWeekDayStop = trimmedString;
                }
                else if ([elementName isEqualToString:@"StartTime"])
                {
                    self.reservationItem.reservationStartTime = trimmedString;
                }
                else if ([elementName isEqualToString:@"StopTime"])
                {
                    self.reservationItem.reservationStopTime = trimmedString;
                }
                
                else if ([elementName isEqualToString:@"Interval"])
                {
                    self.reservationItem.reservationInterval = trimmedString;
                }
                
                else if ([elementName isEqualToString:@"TableThreshold"])
                {
                    self.reservationItem.reservationTableThreshold = trimmedString;
                }
            }
            
            if ([elementName isEqualToString:@"ResvConfig"])
            {
                [self.parsedreservationConfig addObject:self.reservationItem];  
                self.reservationItem = nil;
            }
        }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(m_submitMode)
    {
        if (m_storingCharacterData)
        {
            [m_workingPropertyString appendString:string];
        }
    }
    else if (m_storingCharacterData1)
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
    if(m_submitMode)
    {
        
        NSLog(@"%@", self.reservationStatusString);
        
        [m_activityIndicator stopAnimating];
        m_activityIndicator.hidden = YES;
        [m_activityIndicator release];
        
        if([self.reservationStatusString isEqualToString:@"Accepted"])
        {
            [[ApplicationManager instance].dataCacheManager setFirstName   :m_reserveName.text];
            [[ApplicationManager instance].dataCacheManager setPhoneNumber :m_reservePhoneNo.text];
            
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Thank You for Reserving!" message:@"We will update you by email your reservation status" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [success show];
            [success release];
        }
        else if ([self.reservationStatusString isEqualToString:@"Declined"])
        {
            UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"Your reservation has been declined. Please call the restaurant for further assistance" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [fail show];
            [fail release];
        }
    }
    else
    {        
        [m_activityIndicator stopAnimating];
        m_activityIndicator.hidden = YES;
        [m_activityIndicator release];
        
        if ([m_parsedreservationConfig count])
        {
            Reservation *reservation = [m_parsedreservationConfig objectAtIndex:0];
            
            NSDate *currentDate = [NSDate date];
            NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
            [gregorian setFirstWeekday:2];
            NSDateComponents *weekdayComponents =
            [gregorian components:NSWeekdayCalendarUnit fromDate:currentDate];
            int weekday = [weekdayComponents weekday];
            
            if (weekday == 1)
            {
                weekday  = 7;
            }
            else
            {
                weekday = weekday - 1;
            }
            
            NSLog(@"Weekday:"@"%i",weekday);
            
            
            NSArray *weekdays =[[[NSArray alloc]initWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",nil]autorelease];
            
            
            NSInteger startDay = [weekdays indexOfObject:[reservation reservationWeekDayStart]];
            startDay += 1;
            NSLog(@"%i",startDay);
            
            NSInteger endDay = [weekdays indexOfObject:[reservation reservationWeekDayStop]];
            endDay += 1;
            NSLog(@"%i",endDay);

            NSDate *todaysDate =[NSDate date];
            
            NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit fromDate:todaysDate];
            
                     
            int startTime = [[reservation reservationStartTime] intValue];
            
            m_interval  = [reservation reservationInterval];
                       
            [comps setHour:startTime];
            [comps setMinute:00];
            [comps setSecond:00];
            
            NSDate *startDate = [gregorian dateFromComponents:comps];
            
            
            NSDateComponents *startcomps = [[[NSDateComponents alloc] init]autorelease];
            if (startDay < weekday)
            {
                [startcomps setDay:0];
            }
            else
            {
                [startcomps setDay:startDay-weekday];
            }
        
            self.minDate = [gregorian dateByAddingComponents:startcomps toDate:startDate   options:0];
            
            int stopTime = [[reservation reservationStopTime] intValue];
            
            [comps setHour:stopTime];
            [comps setMinute:00];
            [comps setSecond:00];
            
            startDate = [gregorian dateFromComponents:comps];
                       
            NSDateComponents *endComps =[[[NSDateComponents alloc] init]autorelease];
            if (endDay < weekday)
            {
                [endComps setDay:0];
            }
            else
            {
                [endComps setDay:endDay-weekday];
            }
            
            self.maxDate =[gregorian dateByAddingComponents:endComps toDate:startDate options:0];
        }
        
        [[ApplicationManager instance].dataCacheManager setSelectedDate:m_minDate];
        
        NSDateFormatter *buttonDateFormatter = [[[NSDateFormatter alloc] init]autorelease];
        [buttonDateFormatter setDateFormat:@"EEE MMM d, YYYY, h:mm aaa"];
        NSString *dateString = [buttonDateFormatter stringFromDate:m_minDate];
        
        [m_DateTimeLabel setText:dateString];
    }
}


-(BOOL)lengthValidation: (int) index
{   
    int length = 0;
    NSString *errorMsg1;
    NSString *errorMsg2;
    
    
    if (index == 0)
    {
        length = [m_emailIdLabel.text length];
        errorMsg1 = @"Not Signed In";
        errorMsg2 = @"Please sign in to submit your reservation";
        
    }
    else if (index == 1)
    {
        length = [m_reserveName.text length];
        errorMsg1 = @"Check Name!";
        errorMsg2 = @"Please enter a Name";
        
    }
    else if (index == 2)
    {
        length =[m_reserveLocation.text length];
        errorMsg1 = @"Check Location!";
        errorMsg2 = @"Please select a location";
    }
    else if (index == 3)
    {
        length =[m_numberOfGuest.text length];
        errorMsg1 = @"Check Guest Number!";
        errorMsg2 = @"Please select the number of guests";
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


-(BOOL)phoneNoValidation
{
//    NSString *phoneRegEx = @"^\\+(?:[0-9] ?){7,11}[0-9]$";
    NSString *phoneRegEx = @"^\\d+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegEx];
    //Valid email address
    if ([phoneTest evaluateWithObject:m_reservePhoneNo.text] == YES) 
    {
        return TRUE;
    }
    else
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Phone Number" message:@"Please enter the phone number in internationl format: \n + \'countrycode\' \'number\'"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Phone Number" message:@"Please enter a valid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];       
	    [alert show];
	    [alert release];
        
        return FALSE;
    }
    
}


- (void) displayMyOrder
{
    [[[[ApplicationManager instance].uiManager orderController] orderTable] reloadData];
    [self presentModalViewController:(UIViewController*)[[ApplicationManager instance].uiManager orderController] animated:YES];
}



- (void) makeReservation
{
    [m_reserveName resignFirstResponder];
    [m_reservePhoneNo resignFirstResponder];
    [m_reserveMessage resignFirstResponder];
    
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
                if ([self phoneNoValidation])
                {
                    if ([self lengthValidation:2])
                    {
                        if ([self lengthValidation:3])
                        {
                            UIAlertView *createReservation= [[UIAlertView alloc] initWithTitle:@"Submit Reservation" message:@"Are you sure?"
                                                                                      delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"OK", nil];   
                            [createReservation show];
                            [createReservation release];
                        }
                    }
                }
            }
        }
    }
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex != [alertView cancelButtonIndex])
    {
        [self createReservation];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance   = 60; // tweak as needed
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
    if(textField == m_reservePhoneNo)
    {
        [self animateTextField: textField up: NO]; 
    }
    else if(textField == m_reserveMessage)
    {
        [self animateTextField:textField up:NO];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == m_reservePhoneNo)
    {
        [self animateTextField:textField up:YES];
    }
    else if(textField == m_reserveMessage)
    {
        [self animateTextField:textField up:YES];
    }
}

-(IBAction)selectLocation:(id)sender
{
    [m_reserveName resignFirstResponder];
    [m_reservePhoneNo resignFirstResponder];
    [m_reserveMessage resignFirstResponder];
    
    m_pickerSelector = 0;
    [self uiPickerPopUpDisplay];
}

-(IBAction)selectNumberOfGuest:(id)sender
{
    [m_reserveName resignFirstResponder];
    [m_reservePhoneNo resignFirstResponder];
    [m_reserveMessage resignFirstResponder];
    
    m_pickerSelector = 1;
    [self uiPickerPopUpDisplay];
}


- (void) uiPickerPopUpDisplay
{
    
    if(m_pickerSelector == 0)
    {
        if (m_locationModalPicker == nil)
            m_locationModalPicker = [[ModalUIPickerViewController alloc] initWithNibName:@"ModalUIPickerView" bundle:nil];
        
        [[m_locationModalPicker view] setFrame:CGRectMake(0, 
                                                  480, 
                                                  m_locationModalPicker.view.frame.size.width, 
                                                  m_locationModalPicker.view.frame.size.height)];
        
        NSMutableArray *locations = [[[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager locations]]autorelease];
        
        for(int i=0;i<[locations count];i++)
        {
            Location *location = [locations objectAtIndex:i];
            [[m_locationModalPicker pickerValues] addObject:[location locationName]];
        }
        
        // Setup the array
        [m_locationModalPicker setDelegate:self];
        
        
        [self animatePickerUp];
    }
    else if(m_pickerSelector == 1)
    {
        if (m_guestNoModalPicker == nil)
            m_guestNoModalPicker = [[ModalUIPickerViewController alloc] initWithNibName:@"ModalUIPickerView" bundle:nil];
        
        [[m_guestNoModalPicker view] setFrame:CGRectMake(0, 
                                                  480, 
                                                  m_guestNoModalPicker.view.frame.size.width, 
                                                  m_guestNoModalPicker.view.frame.size.height)];
        
        for (int i=1;i<11; i++)
        {
            [[m_guestNoModalPicker pickerValues] addObject:[NSString stringWithFormat:@"%i",i]];
        }
        
        
        // Setup the array
        [m_guestNoModalPicker setDelegate:self];
        [self animatePickerUp];
    }
}

- (void) animatePickerUp
{
    // Animate Up from bottom
    if(m_pickerSelector == 0)
    {
        [UIView beginAnimations:@"" context:NULL];
        [[m_locationModalPicker view] setFrame: CGRectMake(0,
                                                   self.view.frame.size.height - m_locationModalPicker.view.frame.size.height,
                                                   m_locationModalPicker.view.frame.size.width,
                                                   m_locationModalPicker.view.frame.size.height)];
        //The animation duration
        [UIView setAnimationDuration:8.0];
        [[self view] addSubview:[m_locationModalPicker view]];
        [UIView commitAnimations];
    }
    else if(m_pickerSelector == 1)
    {
        [UIView beginAnimations:@"" context:NULL];
        [[m_guestNoModalPicker view] setFrame: CGRectMake(0,
                                                           self.view.frame.size.height - m_guestNoModalPicker.view.frame.size.height,
                                                           m_guestNoModalPicker.view.frame.size.width,
                                                           m_guestNoModalPicker.view.frame.size.height)];
        //The animation duration
        [UIView setAnimationDuration:8.0];
        [[self view] addSubview:[m_guestNoModalPicker view]];
        [UIView commitAnimations];
        
        m_pickerSelector = 1;
    }
}

- (void) animatePickerDown
{
    // Animate Up from bottom
    if(m_pickerSelector == 0)
    {
        [UIView beginAnimations:@"" context:NULL];
        [[m_locationModalPicker view] setFrame: CGRectMake(0,
                                                   self.view.frame.size.height,
                                                   m_locationModalPicker.view.frame.size.width,
                                                   m_locationModalPicker.view.frame.size.height)];
        //The animation duration
        [UIView setAnimationDuration:8.0];
        [UIView commitAnimations];
    }
    else if(m_pickerSelector == 1)
    {
        [UIView beginAnimations:@"" context:NULL];
        [[m_guestNoModalPicker view] setFrame: CGRectMake(0,
                                                           self.view.frame.size.height,
                                                           m_guestNoModalPicker.view.frame.size.width,
                                                           m_guestNoModalPicker.view.frame.size.height)];
        //The animation duration
        [UIView setAnimationDuration:8.0];
        [UIView commitAnimations];
    }
}


#pragma mark - 
#pragma ModalPickerDelegate
- (void) stringResultSelected:(NSString*)selected
{
    if(m_pickerSelector == 0)
    {
        [m_reserveLocation setText:selected];
        [self animatePickerDown];
        
        NSMutableArray *locations = [[[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager locations]]autorelease];
        
        for(int i=0;i<[locations count];i++)
        {
            if ([selected isEqualToString:[[locations objectAtIndex:i] locationName]])
            {
                Location *location = [locations objectAtIndex:i];
                [[ApplicationManager instance].dataCacheManager setPreferredLocation:location];
            }
        }
    }
    else if(m_pickerSelector == 1)
    {
        [m_numberOfGuest setText:selected];
        [self animatePickerDown];
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

-(IBAction)DateSelection:(id)sender
{
    DateSelectionViewController *dateSelection =[[DateSelectionViewController alloc]initWithNibName:@"DateSelectionViewController" bundle:nil];

    
    [dateSelection setMindate:m_minDate];
    [dateSelection setMaxDate:m_maxDate];
    
    NSInteger interval =[m_interval integerValue]; 
    NSLog(@"%i",interval);
    [dateSelection setInterval:interval];
         
    [self.navigationController pushViewController:dateSelection animated:YES]; 
}

-(IBAction)LoginUser:(id)sender
{
    if ([[ApplicationManager instance].dataCacheManager loginStatus] == FALSE)
    {
        SignInViewController *signIn =[[SignInViewController alloc]initWithNibName:@"SignInViewController" bundle:nil];
        [self presentModalViewController:signIn animated:YES];
    }
}

@end
