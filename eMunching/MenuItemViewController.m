//
//  MenuItemViewController.m
//  eMunching
//
//  Created by Andrew Green on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuItemViewController.h"
#import "FontLabel.h"
#import "RoundCorneredUIImageView.h"
#import "Objects.h"
#import "MyOrderViewController.h"
#import "DetailReviewViewController.h"


@interface MenuItemViewController (PrivateMethods)

- (void) uiPickerPopUpDisplay;
- (void) animatePickerUp;
- (void) animatePickerDown;
- (void) facebookLikeDisplay;
- (void) showDetailedDescription;
- (void) addToOrder;
- (void) displayMyOrder;
- (void) startImageDownload;
- (void) postOnFacebook;

- (IBAction)addQuantity;
- (IBAction)subtractQuantity;

- (void) startImageDownload:(MenuItem *)menuItem forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MenuItemViewController

@synthesize menuItem               = m_menuItem;

@synthesize cacheArrayToUpdate     = m_cacheArrayToUpdate;
@synthesize selectedGroupIndex     = m_selectedGroupIndex; 
@synthesize selectedItemIndex      = m_selectedItemIndex; 

@synthesize itemTitle              = m_itemTitle;
@synthesize itemDescription        = m_itemDescription;
@synthesize itemPrice              = m_itemPrice;
@synthesize strikeThrough          = m_strikeThrough;
@synthesize itemActualPrice        = m_itemActualPrice;
@synthesize addToOrderQuantity     = m_addToOrderQuantity;
@synthesize itemImagesScroll       = m_itemImagesScroll;
@synthesize itemImagesPageControl  = m_itemImagesPageControl;

@synthesize imageViews               = m_imageViews;
@synthesize imageDownloadsInProgress = m_imageDownloadsInProgress;

@synthesize facebook                 = m_facebook;


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
    // terminate all pending download connections
    NSArray *allImageDownloads = [self.imageDownloadsInProgress allValues];
    [allImageDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [m_imageViews release];
    [m_imageDownloadsInProgress release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    // terminate all pending download connections
    NSArray *allImageDownloads = [self.imageDownloadsInProgress allValues];
    [allImageDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_itemCount = 1;
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    // Do any additional setup after loading the view from its nib.
     [m_itemTitle setZFont:[[ApplicationManager instance].fontManager zFontWithName:BOLDFONT pointSize:18.0f]];
     [m_itemDescription setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];
     [m_itemPrice setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
     [m_itemActualPrice setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];

     [m_addToOrderQuantity setText:@"1"];
     [m_addToOrderQuantity setZFont:[[ApplicationManager instance].fontManager zFontWithName:BOLDFONT pointSize:17.0f]];
    
     [m_itemImagesScroll setDelegate:self];
     [m_itemImagesScroll setScrollEnabled:YES];
     [m_itemImagesScroll setPagingEnabled:YES];
     [m_itemImagesScroll setBounces:YES];
     [m_itemImagesScroll setContentSize:CGSizeMake(320*2, 160)];
    
    self.imageViews = [NSMutableArray array];
    for (int i=0; i<2; i++)
    {
        CGRect frame = m_itemImagesScroll.frame;
        frame.origin.x = (frame.size.width * i)+ 10;
        frame.origin.y = 10;
        frame.size.height = frame.size.height - 10;
        frame.size.width = frame.size.width - 20;
        
        RoundCorneredUIImageView *picture;
        if (m_menuItem.dishPictures && i<[m_menuItem.dishPictures count])
        {
            picture = [[RoundCorneredUIImageView alloc] initWithImage:[m_menuItem.dishPictures objectAtIndex:i]];
        }
        else
        {
            picture = [[RoundCorneredUIImageView alloc] initWithImage:[UIImage imageNamed:@"blank_loading.png"]];
        }
        
        [picture setFrame:frame];
        [picture roundEdgesToRadius:10];
        [m_itemImagesScroll addSubview:picture];
        
        [self.imageViews addObject:picture]; 
    }
    
    // If no images downloaded yet, start download of first image
    if ([m_menuItem.dishPictures count] == 0)
    {
        NSIndexPath *myIP = [NSIndexPath indexPathForRow:0 inSection:0];
        [self startImageDownload:m_menuItem  forIndexPath:myIP];
    }
    
    
    [m_itemImagesPageControl setNumberOfPages:2];
    [m_itemImagesPageControl setUserInteractionEnabled:NO];
    
    [self setTitle:[m_menuItem dishTitle]];
    [m_itemTitle setText:[m_menuItem dishTitle]];
    [m_itemDescription setText:[m_menuItem dishDescription]];
       
    //Check if the Discount Price is zero
    if([[m_menuItem dishDiscountPrice] isEqualToString:@"0"])
    {
        [m_itemPrice setText:[NSString stringWithFormat:CURRENCY "%@",[m_menuItem dishPrice]]];
        [m_itemPrice setFrame:CGRectMake(250.0, 20.0, 42.0, 21.0)];
    }
    else
    {
        [m_itemPrice setText:[NSString stringWithFormat:CURRENCY "%@",[m_menuItem dishDiscountPrice]]];
        [m_itemActualPrice setText:[NSString stringWithFormat:CURRENCY "%@",[m_menuItem dishPrice]]];
        m_strikeThrough.hidden = false;
    }
    
    //Add a My Order button to RightBarButtonItem
    UIBarButtonItem *myOrderButton = [[UIBarButtonItem alloc] 
                                      initWithTitle:@"My Order"                                            
                                      style:UIBarButtonItemStyleBordered 
                                      target:self 
                                      action:@selector(displayMyOrder)];
    
    self.navigationItem.rightBarButtonItem = myOrderButton;
    [myOrderButton release];
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
    
    [m_itemTitle setTextColor:TEXTCOLOR1];
    [m_itemDescription setTextColor:TEXTCOLOR1];
    [m_itemActualPrice setTextColor:TEXTCOLOR1];
    [m_itemPrice setTextColor:TEXTCOLOR3];
    [m_addToOrderQuantity setTextColor:TEXTCOLOR1];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:m_itemTitle.text withError:&error];    
}

//BarButton Function
- (void) displayMyOrder
{
    [[[[ApplicationManager instance].uiManager orderController] orderTable] reloadData];
    [self presentModalViewController:(UIViewController*)[[ApplicationManager instance].uiManager orderController] animated:YES];
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

#pragma mark -
#pragma mark Scroll View Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = floor((m_itemImagesScroll.contentOffset.x - 320 / 2) / 320) + 1;
    [m_itemImagesPageControl setCurrentPage:page];
    
    if (m_menuItem.dishPictures==nil || (m_menuItem.dishPictures && page==[m_menuItem.dishPictures count]))
    {
        NSIndexPath *myIP = [NSIndexPath indexPathForRow:page inSection:0];
        [self startImageDownload:m_menuItem  forIndexPath:myIP];
    }
}

#pragma mark -
#pragma mark Button Handlers
- (IBAction) handleButton:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int tag = [button tag];
    
    switch (tag)
    {
        case MENU_LIKEIT:
            [self facebookLikeDisplay];
            break;
        case MENU_ADDTOORDER:
            [self addToOrder];
            break;
        case MENU_UIPICKER:
            [self uiPickerPopUpDisplay];
            break;
        case MENU_DESCRIPTION:
            [self showDetailedDescription];
            break;
        default:
            break;
    }
}

- (void) showDetailedDescription
{
    DetailReviewViewController *detailReview = [[DetailReviewViewController alloc] initWithNibName:@"DetailReviewViewController" bundle:nil];
    
    [detailReview setPageToDisplay:@"detailedMenuDescription"];
    [detailReview setMenuItem:m_menuItem];
    
    [self.navigationController pushViewController:detailReview animated:YES]; 
    [detailReview release];    
}

-(IBAction) addQuantity
{
    if(m_itemCount == 10)
        return;
    
    [m_addToOrderQuantity setText:[NSString stringWithFormat:@"%d", ++m_itemCount]];    
}

-(IBAction) subtractQuantity
{
    if(m_itemCount == 1)
        return;
    
    [m_addToOrderQuantity setText:[NSString stringWithFormat:@"%d", --m_itemCount]];
}

- (void) facebookLikeDisplay
{
    
    m_facebook = [[Facebook alloc] initWithAppId:FACEBOOKAPID andDelegate:self];
    [[ApplicationManager instance].dataCacheManager setFacebookInstance:m_facebook];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        m_facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        m_facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }

    if ([m_facebook isSessionValid]) 
    {
        [self postOnFacebook];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opening Safari" message:@"Click Ok to log into Facebook using Safari"
                                                           delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"OK", nil];         
        [alert show];
        [alert release];
    }
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        NSArray *permissions = [[NSArray arrayWithObjects:@"read_stream", @"offline_access",nil] retain];
        [m_facebook authorize:permissions];
    }
}

- (void) addToOrder
{
    
    [m_menuItem setDishQuantity:[m_addToOrderQuantity text]];
    
    bool addedToMyOrder = false;
    for (int i=0;i < [[[ApplicationManager instance].dataCacheManager myOrder] count];i++)
    {
        MenuItem *m  = [[[ApplicationManager instance].dataCacheManager myOrder] objectAtIndex:i];
        
        if ([[m dishTitle] isEqualToString:[m_menuItem dishTitle]])
        {
            [[[ApplicationManager instance].dataCacheManager myOrder] replaceObjectAtIndex:i withObject:m_menuItem];
            addedToMyOrder = true;
        }
    }
    
    if (addedToMyOrder == false)
    {
        [[[ApplicationManager instance].dataCacheManager myOrder] addObject:m_menuItem];
    }
    
    NSString *message = [NSString stringWithFormat:@"%@ %@'s added to your order!",[m_menuItem dishQuantity],[m_menuItem dishTitle]];
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  
    NSInteger orderCount = [[[ApplicationManager instance].dataCacheManager myOrder] count];
    NSString *badge = [NSString stringWithFormat:@"%i",orderCount];
    [[[[ApplicationManager instance].appDelegate tabBarController].tabBar.items objectAtIndex:2] setBadgeValue:badge];
    
    [success show];
}

#pragma mark -
#pragma mark Table cell image support

- (void) startImageDownload:(MenuItem *)menuItem forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [m_imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil) 
    {
        imageDownloader = [[ImageDownloader alloc] init];
        [m_imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.delegate = self;
        
        [imageDownloader setImageURLString:[m_menuItem.dishPictureURLStrings objectAtIndex:[indexPath row]]];
        [imageDownloader setImageHeight:m_itemImagesScroll.frame.size.height];
        [imageDownloader setImageWidth:m_itemImagesScroll.frame.size.width];
        
        [imageDownloader startDownload];
        [imageDownloader release];   
    }
}

// called by ImageDownloader when an image is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [m_imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader != nil && imageDownloader.returnedImage != nil)
    {
        [m_menuItem.dishPictures addObject:imageDownloader.returnedImage];
        
        // Cache downloaded image
        NSMutableArray *menuItems;
        if ([m_cacheArrayToUpdate isEqualToString:@"ChefSpecials"])
        {
            menuItems = [[[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager chefSpecials]] autorelease];
            [menuItems replaceObjectAtIndex:m_selectedItemIndex withObject:m_menuItem];
        }
        else if ([m_cacheArrayToUpdate isEqualToString:@"FeaturedDeals"])
        {
            menuItems = [[[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager featuredDeals]] autorelease];
            [menuItems replaceObjectAtIndex:m_selectedItemIndex withObject:m_menuItem];
        }
        else if([m_cacheArrayToUpdate isEqualToString:@"MenuItemsByGroup1"])
        {
            menuItems = [[[NSMutableArray alloc] initWithArray:[[[ApplicationManager instance].dataCacheManager menuItemsByGroup1] objectAtIndex:m_selectedGroupIndex]] autorelease];
            [menuItems replaceObjectAtIndex:m_selectedItemIndex withObject:m_menuItem];
        }
        else if([m_cacheArrayToUpdate isEqualToString:@"MenuItemsByGroup2"])
        {
            menuItems = [[[NSMutableArray alloc] initWithArray:[[[ApplicationManager instance].dataCacheManager menuItemsByGroup2] objectAtIndex:m_selectedGroupIndex]] autorelease];
            [menuItems replaceObjectAtIndex:m_selectedItemIndex withObject:m_menuItem];
        }
        if ([m_cacheArrayToUpdate isEqualToString:@"SearchResults"])
        {
            menuItems = [[[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager searchResults]] autorelease];
            [menuItems replaceObjectAtIndex:m_selectedItemIndex withObject:m_menuItem];
        }
        
        CGRect frame = m_itemImagesScroll.frame;
        frame.origin.x = (frame.size.width * indexPath.row)+ 10;
        frame.origin.y = 10;
        frame.size.height = frame.size.height - 10;
        frame.size.width = frame.size.width - 20;
       
        RoundCorneredUIImageView *picture = [[RoundCorneredUIImageView alloc] initWithImage:imageDownloader.returnedImage];
        [picture setFrame:frame];
        [picture roundEdgesToRadius:10];
        
        [[self.imageViews objectAtIndex:indexPath.row] removeFromSuperview];
        [self.imageViews replaceObjectAtIndex:indexPath.row withObject:picture];
        [m_itemImagesScroll addSubview:picture];
    }
    
}

- (void) postOnFacebook
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   FACEBOOKAPID, @"app_id",
                                   FACEBOOKSHARELINK, @"link",
                                   m_menuItem.dishPictureURLString, @"picture",
                                   FACEBOOKSHARENAME, @"name",
                                   m_menuItem.dishTitle, @"caption",
                                   m_menuItem.dishDescription, @"description",
                                   FACEBOOKSHAREMESSAGE,@"message",
                                   nil];
    
    [m_facebook dialog:@"feed" andParams:params andDelegate:self];
}


////////////////////////////////////////////////////////////////////////////////
// FBLoginDelegate

/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[m_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[m_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self postOnFacebook];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled 
{
    NSLog(@"did not login");
    
    UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Facebook Login Failed!" message:@"We are unable to authenticate your ID on Facebook. Please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [fail show];
    [fail release];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout 
{

}


////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response 
{
    NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result 
{
   NSLog(@"didLoad");
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error 
{
   NSLog(@"didFailWithError");
};


////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog 
{
   NSLog(@"dialogDidComplete");
}


@end
