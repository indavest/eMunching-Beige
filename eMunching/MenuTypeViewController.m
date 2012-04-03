//
//  MenuTypeViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 29/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuTypeViewController.h"
#import "MyOrderViewController.h"
#import "SpecialTableViewCell.h"
#import "Objects.h"
#import "MenuItemViewController.h"
#import "Reachability.h"

#import "FontLabel.h"
#import "RoundCorneredUIImageView.h"


@interface MenuTypeViewController (PrivateMethods)

- (void) displayMyOrder;
- (void) GetRestaurantsMenuItemGroups;
- (void) startImageDownload:(MenuItem *)menuItem forIndexPath:(NSIndexPath *)indexPath;

@end


@implementation MenuTypeViewController

@synthesize menuGroup               = m_menuGroup;
@synthesize menuTable               = m_menuTable;
@synthesize menuItems               = m_menuItems;

@synthesize selectedType            = m_selectedType;
@synthesize selectedGroup           = m_selectedGroup;
@synthesize selectedGroupId         = m_selectedGroupId;

@synthesize fetchedResults          = m_fetchedResults;
@synthesize parsedMenuGroupItems    = m_parsedMenuGroupItems;
@synthesize menuItem                = m_menuItem;
@synthesize workingPropertyString   = m_workingPropertyString;
@synthesize elementsToParse         = m_elementsToParse;
@synthesize storingCharacterData    = m_storingCharacterData;

@synthesize menuImageDownloadsInProgress = m_menuImageDownloadsInProgress;



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
    NSArray *allImageDownloads = [self.menuImageDownloadsInProgress allValues];
    [allImageDownloads makeObjectsPerformSelector:@selector(cancelDownload)];    
    
    [m_parsedMenuGroupItems release];
    [m_menuItems release];
    [m_workingPropertyString release];
    [m_elementsToParse release];   
    [m_statuslabel release];
    
    [m_menuItem release];
    
    [m_menuImageDownloadsInProgress release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    // terminate all pending download connections
    NSArray *allImageDownloads = [self.menuImageDownloadsInProgress allValues];
    [allImageDownloads makeObjectsPerformSelector:@selector(cancelDownload)]; 
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.ß

    self.title = m_menuGroup;
    
    m_statuslabel = [[FontLabel alloc] initWithFrame:CGRectMake(45, 160, 240, 60)];
    m_statuslabel.backgroundColor = [UIColor clearColor];
    m_statuslabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    m_statuslabel.numberOfLines = 2;
    m_statuslabel.text   = @"Sorry! no menu items found";
    m_statuslabel.hidden = TRUE;
    [m_statuslabel setTextColor:TEXTCOLOR1];
    [m_statuslabel setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:15.0f]];
    [self.view addSubview:m_statuslabel];

    
    [self GetRestaurantsMenuItemGroups];
    
    self.menuImageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    //Add a My Order button to RightBarButtonItem
    UIBarButtonItem *myOrderButton = [[UIBarButtonItem alloc] 
                                      initWithTitle:@"My Order"                                            
                                      style:UIBarButtonItemStyleBordered 
                                      target:self 
                                      action:@selector(displayMyOrder)];
    
    self.navigationItem.rightBarButtonItem = myOrderButton;
    [myOrderButton release];
    
    self.parsedMenuGroupItems = [NSMutableArray array];
    self.workingPropertyString = [NSMutableString string];
    
    self.elementsToParse = [NSMutableArray array];
    [self.elementsToParse addObject:@"ID"];
    [self.elementsToParse addObject:@"Item"];
    [self.elementsToParse addObject:@"ItemDesc"];
    [self.elementsToParse addObject:@"ItemPrice"];
    [self.elementsToParse addObject:@"DiscountPrice"];    
    [self.elementsToParse addObject:@"ItemImage1"];
    [self.elementsToParse addObject:@"ItemImage2"];
    [self.elementsToParse addObject:@"ItemImage3"];
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_menuTable setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:m_menuGroup withError:&error];   
}

- (void) displayMyOrder
{
    [[[[ApplicationManager instance].uiManager orderController] orderTable] reloadData];
    [self presentModalViewController:(UIViewController*)[[ApplicationManager instance].uiManager orderController] animated:YES];
}

- (void) GetRestaurantsMenuItemGroups
{
    // Control the number of synch calls made to server for each menu item group
    // Get data from server only after an interval of x(refer DataCacheManager) calls to the cache manager

    if ([[ApplicationManager instance].dataCacheManager getGroupsSynchStatus:m_selectedType:m_selectedGroup] == FALSE)
    {
        return;
    }
    
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
    
    int mealType;
    NSInteger menuStatus = [[[ApplicationManager instance].dataCacheManager preferredLocation] multipleMenuStatus].intValue;
    
    if (menuStatus == 0)
    {
        mealType = MEALTYPE_ALL;
    }
    else
    {
        // To be changed based on type of menu selected on the server
        if (m_selectedType == 0)
        {
            mealType = MEALTYPE1;
        }
        else
        {
            mealType = MEALTYPE2;
        }
    }
    
        
    //Making a Soap Request to Server
    NSString *soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<GetRestaurantMenuItemsAll_XML xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<RestaurantID>%i</RestaurantID>\n"
    "<MealType>%i</MealType>\n"
    "<DealType>0</DealType>\n"
    "<MenuItemType>0</MenuItemType>\n"
    "<MealCategory>%@</MealCategory>\n"   
    "</GetRestaurantMenuItemsAll_XML>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n", RESTAURANT_ID, mealType, m_selectedGroupId];
    
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/GetRestaurantMenuItemsAll_XML"  forHTTPHeaderField:@"SOAPAction"];
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
    
    [m_parsedMenuGroupItems removeAllObjects];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:m_fetchedResults];
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
    if ([elementName isEqualToString:@"MenuItem"])
	{
        self.menuItem = [[[MenuItem alloc] init] autorelease];
    }
    
    m_storingCharacterData = [m_elementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if (self.menuItem)
	{
        if (m_storingCharacterData)
        {
            NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [m_workingPropertyString setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:@"ID"])
            {
                self.menuItem.dishId = trimmedString;
            }                
            else if ([elementName isEqualToString:@"Item"])
            {
                self.menuItem.dishTitle = trimmedString;
            }
            else if([elementName isEqualToString:@"ItemDesc"])
            {
                self.menuItem.dishDescription =trimmedString;
            }
            else if([elementName isEqualToString:@"ItemPrice"])
            {
                self.menuItem.dishPrice = trimmedString;
            }
            else if([elementName isEqualToString:@"DiscountPrice"])
            {
                self.menuItem.dishDiscountPrice = trimmedString;
            }
            else if([elementName isEqualToString:@"ItemImage1"])
            {
                self.menuItem.dishPictureURLString   = trimmedString;
            }
            else if ([elementName isEqualToString:@"ItemImage2"])
            {
                [self.menuItem.dishPictureURLStrings addObject:trimmedString];
            }
            else if ([elementName isEqualToString:@"ItemImage3"])
            {
                [self.menuItem.dishPictureURLStrings addObject:trimmedString];
            }
        }
        
        if ([elementName isEqualToString:@"MenuItem"])
        {
            [self.parsedMenuGroupItems addObject:self.menuItem];  
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
    
    m_statuslabel.hidden = FALSE;
}


-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    switch (m_selectedType)
    {
        case 0:
            [[[ApplicationManager instance].dataCacheManager menuItemsByGroup1] replaceObjectAtIndex:m_selectedGroup withObject:m_parsedMenuGroupItems];
            break;
            
        case 1:
            [[[ApplicationManager instance].dataCacheManager menuItemsByGroup2] replaceObjectAtIndex:m_selectedGroup withObject:m_parsedMenuGroupItems];
            break;
            
        default:
            break;
    }
    
    [[self menuTable] reloadData];
    
    if ([m_parsedMenuGroupItems count])
        m_statuslabel.hidden = TRUE;
    else
        m_statuslabel.hidden = FALSE;
    
    [m_activityIndicator stopAnimating];
    m_activityIndicator.hidden = YES;
    [m_activityIndicator release];
    [parser release];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [m_menuItems release];
    
    switch (m_selectedType)
    {
        case 0:
            m_menuItems = [[NSMutableArray alloc] initWithArray:[[[ApplicationManager instance].dataCacheManager menuItemsByGroup1] objectAtIndex:m_selectedGroup]];            
            break;
            
        case 1:
            m_menuItems = [[NSMutableArray alloc] initWithArray:[[[ApplicationManager instance].dataCacheManager menuItemsByGroup2] objectAtIndex:m_selectedGroup]];
            break;
            
        default:
            break;
    }  
    
    return [m_menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%i%i",[indexPath section],[indexPath row]];
    
    // Configure the cell...
    SpecialTableViewCell *tableCell = [[SpecialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SpecialTableViewCell" owner:nil options:nil];
    
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[SpecialTableViewCell class]])
        {
            tableCell = (SpecialTableViewCell*)currentObject;
            break;
        }
    }
    
    m_menuImageHeight = tableCell.specialImage.frame.size.height;
    m_menuImageWidth  = tableCell.specialImage.frame.size.width;
    
    MenuItem *menuItemByGroup = [m_menuItems objectAtIndex:[indexPath row]];
    
    [[tableCell specialImage] setImage:[menuItemByGroup dishPicture]];
    [[tableCell specialImage] roundEdgesToRadius:10];
    [[tableCell specialTitle] setText:[menuItemByGroup dishTitle]];
    [[tableCell specialTitle] setTextColor:TEXTCOLOR1];
    [[tableCell specialTitle] setZFont:[[ApplicationManager instance].fontManager zFontWithName:BOLDFONT pointSize:18.0f]];
    [[tableCell specialDescription] setText:[menuItemByGroup dishDescription]];
    [[tableCell specialDescription] setTextColor:TEXTCOLOR1];
    [[tableCell specialDescription] setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];
    
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (!(([indexPath row] % 2) == 0))
    {
        [tableCell reverseLocations];
    }
    
    
    if (!menuItemByGroup.dishPicture)
    {
        if (self.menuTable.dragging == NO && self.menuTable.decelerating == NO)
        {
            [self startImageDownload:menuItemByGroup forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        [[tableCell specialImage] setImage:[UIImage imageNamed:@"blank_loading.png"]];
    }
    else
    {
        [[tableCell specialImage] setImage:menuItemByGroup.dishPicture];
    }
    

    return tableCell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

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
    
    MenuItem *selectedMenuItem = [m_menuItems objectAtIndex:[indexPath row]];
    
    // Navigation logic may go here. Create and push another view controller.
    MenuItemViewController *menuItemView = [[MenuItemViewController alloc] initWithNibName:@"MenuItemView" bundle:nil];
    
    [menuItemView setMenuItem:selectedMenuItem];
    
    if (m_selectedType == 0)
        [menuItemView setCacheArrayToUpdate:@"MenuItemsByGroup1"];
    else
        [menuItemView setCacheArrayToUpdate:@"MenuItemsByGroup2"];
    
    [menuItemView setSelectedGroupIndex:m_selectedGroup];
    [menuItemView setSelectedItemIndex:[indexPath row]];
    
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:menuItemView animated:YES]; 
    
    [selectedMenuItem release];
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

- (void)startImageDownload:(MenuItem *)menuItem forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [m_menuImageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil) 
    {
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.delegate = self;
        [m_menuImageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        
        MenuItem *menuItemByGroup = [m_menuItems objectAtIndex:[indexPath row]];
        [imageDownloader setImageURLString:menuItemByGroup.dishPictureURLString];
        [imageDownloader setImageHeight:m_menuImageHeight];
        [imageDownloader setImageWidth :m_menuImageWidth];

        [imageDownloader startDownload];
        [imageDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    
    int n =[self.menuItems count];
    NSLog(@"%i",n);

    if ([self.menuItems count] > 0)
    {
        NSArray *visiblePaths = [self.menuTable indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            MenuItem *menuItem = [self.menuItems objectAtIndex:indexPath.row];
            
            if (!menuItem.dishPicture) // avoid the app icon download if the app already has an icon
            {
                [self startImageDownload:menuItem forIndexPath:indexPath];
            }
        }
    }
}

// called by ImageDownloader when an image is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [m_menuImageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader != nil && imageDownloader.returnedImage != nil)
    {
        
        SpecialTableViewCell *tableCell = (SpecialTableViewCell *)[self.menuTable cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        [[tableCell specialImage] setImage :imageDownloader.returnedImage];
        
        [[m_menuItems objectAtIndex:indexPath.row] setDishPicture:imageDownloader.returnedImage];
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
  
}




@end
