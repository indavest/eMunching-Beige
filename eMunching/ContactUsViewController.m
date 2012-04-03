//
//  ContactUsViewController.m
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactUsViewController.h"
#import "MapViewController.h"
#import "WebViewController.h"


@interface ContactUsViewController (PrivateMethods)

- (void) displayRecommendUs;

-(void)  displayContactUs;
-(void)  displayMailUs;
-(void)  displayFindUs;
-(void)  displayReachUs;
-(void)  displayFollowUs;
-(void)  displayWebSite;

@end


@implementation ContactUsViewController

@synthesize scrollView = m_scrollView;

@synthesize phoneNumberHeader  = m_phoneNumberHeader;
@synthesize emailAddressHeader = m_emailAddressHeader;
@synthesize locationNameHeader = m_locationNameHeader;
@synthesize facebookUrlHeader  = m_facebookUrlHeader;
@synthesize twitterUrlHeader   = m_twitterUrlHeader;

@synthesize website        = m_website;
@synthesize phoneNumber    = m_phoneNumber;
@synthesize emailAddress   = m_emailAddress;
@synthesize locationName   = m_locationName;
@synthesize facebookUrl    = m_facebookUrl;
@synthesize twitterUrl     = m_twitterUrl;

@synthesize locationNameImage = m_locationNameImage;
@synthesize facebookImage     = m_facebookImage;
@synthesize twitterImage      = m_twitterImage;

@synthesize locationNameButton = m_locationNameButton;
@synthesize facebookButton     = m_facebookButton;
@synthesize twitterButton      = m_twitterButton;

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
    
    self.navigationItem.title =@"Contact Us";
    
    [[[self navigationItem] leftBarButtonItem] setTarget:self];
    [[[self navigationItem] leftBarButtonItem] setAction:@selector(displayRecommendUs)];
    
    [m_scrollView setScrollEnabled:YES];
    [m_scrollView setContentSize:CGSizeMake(320,620)];
    
    Location *prefLocation = [[ApplicationManager instance].dataCacheManager preferredLocation];
    
    m_phoneNumber.text   = prefLocation.locationPhoneNumber;
    m_emailAddress.text  = prefLocation.locationEmailAddress;
    m_website.text       = [prefLocation.locationWebSite substringFromIndex:7];;
    m_facebookUrl.text   = prefLocation.locationFacebookUrl;
    m_twitterUrl.text    = prefLocation.locationTwitterUrl;
    m_locationName.text  = prefLocation.locationName;
    
    if ([m_locationName.text isEqualToString:@""])
    {
        m_locationNameImage.hidden = true;
        m_locationNameHeader.hidden = true;
        m_locationName.hidden = true;
        m_locationNameButton.hidden = true;
    }
    
    if ([m_facebookUrl.text isEqualToString:@""])
    {
        m_facebookImage.hidden = true;
        m_facebookUrlHeader.hidden = true;
        m_facebookUrl.hidden = true;
        m_facebookButton.hidden = true;
        
    }
    
    if ([m_twitterUrl.text isEqualToString:@""])
    {
        m_twitterImage.hidden = true;
        m_twitterUrlHeader.hidden = true;
        m_twitterUrl.hidden = true;
        m_twitterButton.hidden = true;
    }
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR]; 
    [self.navigationController.navigationBar setTintColor:TINTCOLOR]; 
    
    [m_website            setTextColor:TEXTCOLOR1];
    [m_phoneNumberHeader  setTextColor:TEXTCOLOR5];
    [m_phoneNumber        setTextColor:TEXTCOLOR5];
    [m_emailAddressHeader setTextColor:TEXTCOLOR5];
    [m_emailAddress       setTextColor:TEXTCOLOR5];
    [m_locationNameHeader setTextColor:TEXTCOLOR5];
    [m_locationName       setTextColor:TEXTCOLOR5];
    [m_facebookUrlHeader  setTextColor:TEXTCOLOR5];
    [m_facebookUrl        setTextColor:TEXTCOLOR5];
    [m_twitterUrlHeader   setTextColor:TEXTCOLOR5];
    [m_twitterUrl         setTextColor:TEXTCOLOR5];
    
    [m_website              setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
    [m_phoneNumberHeader    setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:15.0f]];
    [m_emailAddressHeader   setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:15.0f]];
    [m_locationNameHeader   setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:15.0f]];
    [m_facebookUrlHeader    setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:15.0f]];
    [m_twitterUrlHeader     setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:15.0f]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"ContactUs" withError:&error];
}

- (void) displayRecommendUs
{
    
}

- (IBAction) handleButton:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int tag = [button tag];
    
    switch (tag)
    {
        case BUTTON_CONTACTUS:
            [self displayContactUs];
            break;
        
        case BUTTON_MAILUS:
            [self displayMailUs];
            break;
        
        case BUTTON_FINDUS:
            [self displayFindUs];
            break;
            
        case BUTTON_REACHUS:
            [self displayReachUs];
            break;
            
        case BUTTON_FOLLOWUS:
            [self displayFollowUs];
            break;
        case BUTTON_WEBSITE:
            [self displayWebSite];
            break;
            
        default:
            break;
    }
}


-(void) displayContactUs
{
    NSLog(@"Clicked");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Call Besito?" message:@"\n" delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"OK", nil];
    
    [alert show];
    [alert release];    
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        NSString *phone_number = @"+918065703027";
        NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",phone_number];
        NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
        [[UIApplication sharedApplication] openURL:phoneURL];
        [phoneURL release];
        [phoneStr release];
    }
}

-(void) displayMailUs
{
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    if ([MFMailComposeViewController canSendMail]) 
    {
        [composer setToRecipients:[NSArray arrayWithObjects:@"support@besitorestaurant.com", nil]];
        [composer setSubject:@"subject here"];
        [composer setMessageBody:@"message here" isHTML:NO];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentModalViewController:composer animated:YES];
        [composer release];
        
    }
    else
        [composer release];
}


//function to handle errors while sending an email
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error"
                                                        message:[NSString stringWithFormat:@"error %@", [error description]]
                                                       delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}


-(void) displayFindUs
{
    MapViewController *mapView =[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    [mapView setAllLocations:FALSE];
    [self.navigationController pushViewController:mapView animated:YES];         
}

-(void) displayReachUs
{
    WebViewController *webView =[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    [webView setDisplayPage:@"FacebookPage"];
    [self.navigationController pushViewController:webView animated:YES];     
}

-(void) displayFollowUs
{
    WebViewController *webView =[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
   [webView setDisplayPage:@"TwitterPage"];
    [self.navigationController pushViewController:webView animated:YES];     
}

-(void) displayWebSite
{
    WebViewController *webView =[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    [webView setDisplayPage:@"WebSitePage"];
    [self.navigationController pushViewController:webView animated:YES];    
    
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
