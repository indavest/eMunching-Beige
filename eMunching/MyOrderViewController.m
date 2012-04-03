//
//  MyOrderViewController.m
//  eMunching
//
//  Created by Andrew Green on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTableViewCell.h"
#import "Objects.h"
#import "FontLabel.h"
#import "RoundCorneredUIImageView.h"
#import "Reachability.h"

#import"SignInViewController.h"

#import "SavedOrderViewController.h"

@interface MyOrderViewController (PrivateMethods)
    
- (IBAction) loginPage  :(id)sender;
- (IBAction) backButton :(id)sender;
- (IBAction) submitOrder:(id)sender;
- (IBAction) saveOrder  :(id)sender;

- (IBAction) menuSelected:(id) sender;
- (IBAction) savedOrderSelected:(id)sender;

- (void)dismissAlert;

- (void)calculateTotal;

@end

@implementation MyOrderViewController

@synthesize headerSavings     = m_headerSavings;
@synthesize headerGrandTotal  = m_headerGrandTotal;
@synthesize ribbonImage       = m_ribbonImage;
@synthesize savings           = m_savings;
@synthesize grandTotal        = m_grandTotal;
@synthesize messageLabel      = m_messageLabel;
@synthesize orderTable        = m_orderTable;

@synthesize navigationItem    = m_navigationItem;
@synthesize toolBarUp         = m_toolBarUp;
@synthesize toolBarDown       = m_toolBarDown;
@synthesize editButton        = m_editButton;
@synthesize signInButton      = m_signInButton;

@synthesize myOrderString     = m_myOrderString;

@synthesize fetchedResults          = m_fetchedResults;

@synthesize workingPropertyString   = m_workingPropertyString;
@synthesize storingCharacterData    = m_storingCharacterData;
@synthesize orderStatusString       = m_orderStatusString;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    [m_orderGroup release];
    
    [m_menuButton release];
    [m_savedOrderButton release];
    [m_alertMenuButton release];
    [m_alertSavedOrderButton release];
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
    m_menuButton = [[UIButton alloc]init]; 
    m_menuButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_menuButton addTarget:self action:@selector(menuSelected:)forControlEvents:UIControlEventTouchUpInside];
    [m_menuButton setTitle:@"Add from Menu" forState:UIControlStateNormal];
    [m_menuButton setTitleColor:TEXTCOLOR3 forState:UIControlStateNormal];
    m_menuButton.frame = CGRectMake(50.0, 160.0, 220.0, 50.0);
    [m_menuButton setBackgroundImage:[UIImage imageNamed:@"select_from_menu_normal.png"] forState:UIControlStateNormal];
    [m_menuButton setBackgroundImage:[UIImage imageNamed:@"select_from_menu_pressed.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:m_menuButton];
        
    m_savedOrderButton = [[UIButton alloc]init];
    m_savedOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_savedOrderButton addTarget:self action:@selector(savedOrderSelected:)forControlEvents:UIControlEventTouchUpInside];
    [m_savedOrderButton setTitle:@"Add from Saved Orders" forState:UIControlStateNormal];
    [m_savedOrderButton setTitleColor:TEXTCOLOR3 forState:UIControlStateNormal];
    m_savedOrderButton.frame = CGRectMake(50.0, 220.0, 220.0, 50.0);
    [m_savedOrderButton setBackgroundImage:[UIImage imageNamed:@"select_from_menu_normal.png"] forState:UIControlStateNormal];
    [m_savedOrderButton setBackgroundImage:[UIImage imageNamed:@"select_from_menu_pressed.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:m_savedOrderButton];
    
    
    [m_headerGrandTotal setZFont:[[ApplicationManager instance].fontManager zFontWithName:BOLDFONT pointSize:17.0f]];
    [m_grandTotal setZFont:[[ApplicationManager instance].fontManager zFontWithName:BOLDFONT pointSize:17.0f]];
    [m_headerSavings setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:14.0f]];
    [m_savings setZFont:[[ApplicationManager instance].fontManager zFontWithName:BOLDFONT pointSize:14.0f]];
    [m_messageLabel setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:10.0f]];
    
    //Set colors from templates  
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_orderTable setBackgroundColor:BACKGROUNDCOLOR];
    [m_toolBarUp   setTintColor:TINTCOLOR];
    [m_toolBarDown setTintColor:TINTCOLOR];
    
    [m_messageLabel       setTextColor:TEXTCOLOR5];
    [m_headerSavings      setTextColor:TEXTCOLOR1];
    [m_headerGrandTotal   setTextColor:TEXTCOLOR6];
    [m_savings            setTextColor:TEXTCOLOR1];
    [m_grandTotal         setTextColor:TEXTCOLOR6];
}


-(IBAction)menuSelected:(id) sender
{
    if(sender == m_alertMenuButton)
    {
        [m_alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [[[ApplicationManager instance].appDelegate tabBarController] setSelectedIndex:1]; 
}


-(IBAction)savedOrderSelected:(id)sender
{
    if(sender == m_alertSavedOrderButton)
    {
        [m_alert dismissWithClickedButtonIndex:0 animated:YES]; 
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [[[ApplicationManager instance].appDelegate tabBarController] setSelectedIndex:2];
}

-(void)dismissAlert
{
    [m_alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction) addButton:(id)sender
{
    m_alert = [[UIAlertView alloc] initWithTitle:@"" message:@"\n\n\n" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    m_alertMenuButton = [[UIButton alloc]init]; 
    m_alertMenuButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [m_alertMenuButton addTarget:self action:@selector(menuSelected:)forControlEvents:UIControlEventTouchDown];
    [m_alertMenuButton setTitle:@"Add from Menu" forState:UIControlStateNormal];
    m_alertMenuButton.frame = CGRectMake(43.0, 20.0, 200.0, 30.0);
    [m_alertMenuButton setBackgroundImage:[UIImage imageNamed:@"alert_view_button_highlight_normal.png"] forState:UIControlStateNormal];
    [m_alertMenuButton setBackgroundImage:[UIImage imageNamed:@"alert_view_button_highlight_pressed.png"] forState:UIControlStateHighlighted];
    [m_alert addSubview:m_alertMenuButton];   
    
    
    m_alertSavedOrderButton = [[UIButton alloc]init];
    m_alertSavedOrderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [m_alertSavedOrderButton addTarget:self action:@selector(savedOrderSelected:)forControlEvents:UIControlEventTouchDown];
    [m_alertSavedOrderButton setTitle:@"Add from Saved Orders" forState:UIControlStateNormal];
     m_alertSavedOrderButton.frame = CGRectMake(43.0, 60.0, 200.0, 30.0);  
    [m_alertSavedOrderButton setBackgroundImage:[UIImage imageNamed:@"alert_view_button_highlight_normal.png"] forState:UIControlStateNormal];
    [m_alertSavedOrderButton setBackgroundImage:[UIImage imageNamed:@"alert_view_button_highlight_pressed.png"] forState:UIControlStateHighlighted];
    [m_alert addSubview:m_alertSavedOrderButton];
    
    
    UIButton *cancelButton = [[UIButton alloc]init];
    cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton addTarget:self action:@selector(dismissAlert)forControlEvents:UIControlEventTouchDown];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(43.0, 100.0, 200.0, 30.0);  
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"alert_view_button_normal.png"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"alert_view_button_pressed.png"] forState:UIControlStateHighlighted];
    [m_alert addSubview:cancelButton];    
              
    [m_alert show];

    [m_alert release];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated
{    
    [self calculateTotal];
    
    if ([[ApplicationManager instance].dataCacheManager loginStatus] == TRUE)    
        m_signInButton.title = @"Sign Out";
    else
        m_signInButton.title = @"Sign In";
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"MyOrder" withError:&error];
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([[[ApplicationManager instance].dataCacheManager myOrder] count] > 0)
    {
        m_menuButton.hidden       = TRUE;
        m_savedOrderButton.hidden = TRUE;
        
        m_headerSavings.hidden    = FALSE;
        m_headerGrandTotal.hidden = FALSE;
        m_ribbonImage.hidden      = FALSE;
    }
    else
    {
        m_menuButton.hidden       = FALSE;
        m_savedOrderButton.hidden = FALSE;
        
        m_headerSavings.hidden    = TRUE;
        m_headerGrandTotal.hidden = TRUE;
        m_ribbonImage.hidden      = TRUE;
        
        [m_grandTotal setText:@""];
        [m_savings    setText:@""];
    }
 
    return [[[ApplicationManager instance].dataCacheManager myOrder] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%i%i",[indexPath section],[indexPath row]];
    
    // Configure the cell...
    MyOrderTableViewCell *tableCell = [[MyOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyOrderTableViewCell" owner:nil options:nil];
    
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[MyOrderTableViewCell class]])
        {
            tableCell = (MyOrderTableViewCell*)currentObject;
            break;
        }
    }
    
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [tableCell setMenuItem:[[[ApplicationManager instance].dataCacheManager myOrder] objectAtIndex:[indexPath row]]];
    [tableCell setup];
    
    return tableCell; 
}

-(void)calculateTotal
{
    m_total = 0.0f;
    m_total1 = 0.0f;
    
    int myOrderCount = [[[ApplicationManager instance].dataCacheManager myOrder]count];
    for(int i=0;i<myOrderCount;i++)
    {
        MenuItem  *menuItem  = [[[ApplicationManager instance].dataCacheManager myOrder] objectAtIndex:i];
        if([[menuItem dishDiscountPrice]isEqualToString:@"0"])
        {
            float actualTotal = [[menuItem dishPrice] floatValue] * [[menuItem dishQuantity] floatValue];
            m_total += actualTotal;
        }
        else
        {
            float discountTotal = [[menuItem dishDiscountPrice] floatValue] * [[menuItem dishQuantity] floatValue];
            m_total += discountTotal;    
        }
        
        [m_grandTotal setText:[NSString stringWithFormat:CURRENCY "%.2f",m_total]];
        
        float actualTotal = [[menuItem dishPrice] floatValue] * [[menuItem dishQuantity] floatValue];
        m_total1 += actualTotal;
        NSLog(@"%.2f",m_total1);
        [m_savings setText:[NSString stringWithFormat:CURRENCY "%.2f",m_total1-m_total]];
        NSLog(@"%@",m_savings.text);
    }    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (IBAction) setEditing
{
    NSString *buttonTitle = [m_editButton title];
    
    if ([buttonTitle isEqualToString:@"Edit"])
    {
        [super setEditing: TRUE animated: TRUE];
        [self.orderTable setEditing:TRUE animated:TRUE];
        
        [m_editButton setTitle:@"Done"];
    }
    else if ([buttonTitle isEqualToString:@"Done"])
    {
        [super setEditing: FALSE animated: TRUE];
        [self.orderTable setEditing:FALSE animated:TRUE];
        
        [m_editButton setTitle:@"Edit"];
    }    
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        // Delete the row from the data source
        
        [[[ApplicationManager instance].dataCacheManager myOrder] removeObjectAtIndex:[indexPath row]];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSInteger orderCount = [[[ApplicationManager instance].dataCacheManager myOrder] count];
        if (orderCount)
        {
            NSString *badge = [NSString stringWithFormat:@"%i",orderCount];
            [[[[ApplicationManager instance].appDelegate tabBarController].tabBar.items objectAtIndex:2] setBadgeValue:badge];
        }
        else
        {
            [[[[ApplicationManager instance].appDelegate tabBarController].tabBar.items objectAtIndex:2] setBadgeValue:nil];
        }
       
        [m_orderTable reloadData];        
        [self calculateTotal];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) 
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

   
}

#pragma mark -
#pragma mark Button Handlers
//-(IBAction)editMode
//{
//    
//    [m_orderTable setEditing:YES animated:YES];
//}


- (IBAction) backButton:(id)sender
{
    
   [self dismissModalViewControllerAnimated:YES];    
}

- (IBAction) loginPage:(id)sender
{
    NSLog(@"clicked2");
    
    if ([[ApplicationManager instance].dataCacheManager loginStatus] == TRUE)
    {
        
        m_signOutAlertView = [[UIAlertView alloc] initWithTitle:@"Sign Out" message:@"Are you sure?"
                                                       delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"OK", nil];         
        [m_signOutAlertView show];
        [m_signOutAlertView release];
    }
    else
    {
        SignInViewController *signIn =[[SignInViewController alloc]initWithNibName:@"SignInViewController" bundle:nil];
        [self presentModalViewController:signIn animated:YES];
    }
}

-(void)submitOrderToServer
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
    
    
    NSString *locationId = @"1";
    if ([[ApplicationManager instance].dataCacheManager preferredLocation] != nil)
    {
        Location *prefLocation = [[ApplicationManager instance].dataCacheManager preferredLocation];
        locationId = [prefLocation locationId];
    }
    
    NSString *UserId = [[ApplicationManager instance].dataCacheManager emailId];
    
    NSLog(@"%@",m_myOrderString);
    
    NSString *soapMessage = [NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<CreateOrder xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<OrderName>Order</OrderName>\n"
    "<RestaurantID>%i</RestaurantID>\n"
    "<RestaurantLocaID>%@</RestaurantLocaID>\n"
    "<UserId>%@</UserId>\n"
    "<MenuItems>%@</MenuItems>\n"
    "</CreateOrder>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n",RESTAURANT_ID,locationId,UserId,m_myOrderString];
    
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/CreateOrder" forHTTPHeaderField:@"SOAPAction"];
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

-(IBAction)submitOrder:(id)sender
{
    if ([[ApplicationManager instance].dataCacheManager loginStatus] == FALSE)
    {
        SignInViewController *signIn =[[SignInViewController alloc]initWithNibName:@"SignInViewController" bundle:nil];
        [self presentModalViewController:signIn animated:YES];
    }
    else
    {
        NSMutableArray *myOrderArray = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager myOrder]];
        
        NSString *myOrderString = @"";
        
        for(int i=0;i<[myOrderArray count];i++)
        {
            myOrderString = [myOrderString stringByAppendingString:[[myOrderArray objectAtIndex:i] dishId]];
            myOrderString = [myOrderString stringByAppendingString:@","];
            myOrderString = [myOrderString stringByAppendingString:[[myOrderArray objectAtIndex:i] dishQuantity]];
            myOrderString = [myOrderString stringByAppendingString:@";"]; 
        }
        
        self.myOrderString = myOrderString;
            
        NSLog(@"%@",m_myOrderString);
        
        if ([m_myOrderString length])
        {
            //AlertView popup to add the name for the order
            m_submitOrderAlertView = [[UIAlertView alloc] initWithTitle:@"Submit Order" message:@"Are you sure?"
                                                               delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"OK", nil];         
            [m_submitOrderAlertView show];
            [m_submitOrderAlertView release];
        }
        else
        {
            UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:@"No dishes selected to submit" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [saveAlert show];
            [saveAlert release];
        }
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
    
    if ([elementName isEqualToString:@"CreateOrderResult"])
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
        if ([elementName isEqualToString:@"CreateOrderResult"])
        {
            self.orderStatusString = trimmedString;
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
    
    BOOL status = [m_orderStatusString boolValue];
    NSLog(status ? @"Yes" : @"No");
    
    [m_activityIndicator stopAnimating];
    m_activityIndicator.hidden = YES;
    [m_activityIndicator release];
    
    if(status)
    {        
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Thank you!" message:@"Your order has been submitted. You will receive an email as soon as it is processed"
                                                         delegate:self cancelButtonTitle:nil  otherButtonTitles:@"OK", nil];
        [success show];
        [success release];
        
        [self saveOrder:nil];
        
        [[[ApplicationManager instance].dataCacheManager myOrder] removeAllObjects];
        [[[[ApplicationManager instance].appDelegate tabBarController].tabBar.items objectAtIndex:2] setBadgeValue:nil];
        [m_grandTotal setText:@" "];
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"We are unable to submit your order right now. Please call the restaurant for further assistance" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [fail show];
        [fail release];
        
        [self saveOrder:nil];
    }
}

-(void)insertSavedOrder
{
    NSMutableArray *myOrderArray = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager myOrder]]; 
    
    [[[ApplicationManager instance].dataCacheManager savedOrderGroup] insertObject:m_orderGroup atIndex:0 ] ;
    [[[ApplicationManager instance].dataCacheManager savedOrderGroupItems] insertObject:myOrderArray atIndex:0];
    
    [myOrderArray release];
    
    int count =  [[[ApplicationManager instance].dataCacheManager savedOrderGroup] count];  
    if(count == 20)
    {
        [[[ApplicationManager instance].dataCacheManager savedOrderGroup] removeLastObject] ;
        [[[ApplicationManager instance].dataCacheManager savedOrderGroupItems] removeLastObject] ;
    }  
}

-(IBAction)saveOrder:(id)sender
{
    
    NSMutableArray *myOrderArray = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager myOrder]]; 
    
    //check if myOrderList is empty,if not empty then create groups
    if([myOrderArray count] == 0)
    {
        UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:@"No dishes selected to save" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [saveAlert show];
        [saveAlert release];
    }
    else
    {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        NSDateFormatter *placeHolderDateFormatter =[[[NSDateFormatter alloc] init] autorelease];
    
        // Date Format w.r.t Locales
        NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
        NSString *usFormatString = [NSDateFormatter dateFormatFromTemplate:@"YEEEEdMMM" options:0 locale:usLocale];
        
        NSString *placedHolderString = [NSDateFormatter dateFormatFromTemplate:@"dMMMHHmm" options:0 locale:usLocale];

        
        [dateFormatter setDateFormat:usFormatString];
        [placeHolderDateFormatter setDateFormat:placedHolderString];
        NSString *dateStampUS   = [dateFormatter stringFromDate:[NSDate date]];
        m_placeHolderDateTimeStamp = [placeHolderDateFormatter stringFromDate:[NSDate date]];    
        
        m_orderGroup = [[OrderGroup alloc]init];
        [m_orderGroup setOrderDateStamp:dateStampUS];
        
        if ( sender != nil)
        {
            //AlertView popup to add the name for the order
            m_saveOrderAlertView = [[UIAlertView alloc] initWithTitle:@"Save Order" message:@"\n\n"
                                                               delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"OK", nil];
            
            m_groupTitleField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)]; 
            [m_groupTitleField setBackgroundColor:[UIColor whiteColor]];
            [m_groupTitleField setPlaceholder:m_placeHolderDateTimeStamp];
            [m_saveOrderAlertView addSubview:m_groupTitleField];
            
            [m_saveOrderAlertView show];
            [m_saveOrderAlertView release];
        }
        else
        {
            [m_orderGroup setOrderTitle:m_placeHolderDateTimeStamp];
            [self insertSavedOrder];
        }


    }
    
    [myOrderArray release];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == m_saveOrderAlertView && buttonIndex != [alertView cancelButtonIndex])
    {
        NSString *enteredName   = m_groupTitleField.text;
        [m_orderGroup setOrderTitle:enteredName];
        if([enteredName length]== 0)
        {
            [m_orderGroup setOrderTitle:m_placeHolderDateTimeStamp];
        }
        
        [self insertSavedOrder];
    }
    
    if (alertView == m_submitOrderAlertView && buttonIndex != [alertView cancelButtonIndex])
    {
        [self submitOrderToServer];
    }
    
    if (alertView == m_signOutAlertView && buttonIndex != [alertView cancelButtonIndex])
    {
        //self.navigationItem.rightBarButtonItem.title = @"Sign In";
        m_signInButton.title = @"Sign In";
        
        [[ApplicationManager instance].dataCacheManager setEmailId:nil];
        [[ApplicationManager instance].dataCacheManager setPassword:nil];
        [[ApplicationManager instance].dataCacheManager setRegisterStatus:FALSE];
        [[ApplicationManager instance].dataCacheManager setAuthenticationStatus:FALSE];
        [[ApplicationManager instance].dataCacheManager setLoginStatus:FALSE];
    }
}

@end
