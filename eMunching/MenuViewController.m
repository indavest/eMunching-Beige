//
//  SecondViewController.m
//  eMunching
//
//  Created by Andrew Green on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"
#import "MyOrderViewController.h"
#import "MenuTableViewCell.h"
#import "MenuItemViewController.h"
#import "MenuTypeViewController.h"
#import "Reachability.h"

#import "Objects.h"
#import "PLSegmentView.h"
#import "FontLabel.h"
#import "RoundCorneredUIImageView.h"
#import "SearchViewController.h"

@interface MenuViewController (PrivateMethods)

- (void) displayMyOrder;
- (void) displaySearch;
- (void) GetRestaurantsMenuItemGroups;
- (void) startImageDownload:(MenuItemGroup *)menuItemGroup forIndexPath:(NSIndexPath *)indexPath;

@end


@implementation MenuViewController

@synthesize menuTypeSelector        = m_menuTypeSelector;
@synthesize brandingImage           = m_brandingImage;
@synthesize menuGroupTable          = m_menuGroupTable;
@synthesize menuGroup               = m_menuGroup;

@synthesize fetchedResults          = m_fetchedResults;
@synthesize parsedMenuGroups        = m_parsedMenuGroups;
@synthesize group                   = m_group;
@synthesize workingPropertyString   = m_workingPropertyString;
@synthesize elementsToParse         = m_elementsToParse;
@synthesize storingCharacterData    = m_storingCharacterData;

@synthesize groupImageDownloadsInProgress = m_groupImageDownloadsInProgress;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    // terminate all pending download connections
    NSArray *allImageDownloads = [self.groupImageDownloadsInProgress allValues];
    [allImageDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray* imageNormalArray = [@"lunch_toggle_inactive.png dinner_toggle_inactive.png" componentsSeparatedByString:@" "];
	NSArray* imageSelectedArray = [@"lunch_toggle_active.png dinner_toggle_active.png" componentsSeparatedByString:@" "];
    
    FontLabel *hiddenLabel;
    hiddenLabel = [[FontLabel alloc] initWithFrame:CGRectMake(0, -75, 320, 60)];
    hiddenLabel.backgroundColor = [UIColor clearColor];
    hiddenLabel.textColor = [UIColor darkGrayColor];
    hiddenLabel.textAlignment = UITextAlignmentCenter;
    hiddenLabel.numberOfLines = 2;
    hiddenLabel.text = RESTAURANTBRANDING;
    [hiddenLabel setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:15.0f]];
    [self.menuGroupTable addSubview:hiddenLabel];
    
	[m_menuTypeSelector setupCellsByImagesName:imageNormalArray selectedImagesName:imageSelectedArray offset:CGSizeMake(160, 0)];
    [m_menuTypeSelector setSelectedIndex:0];
    [m_menuTypeSelector setDelegate:self];
   
    [[[self navigationItem] rightBarButtonItem] setTarget:self];
    [[[self navigationItem] rightBarButtonItem] setAction:@selector(displayMyOrder)];
    [[[self navigationItem] leftBarButtonItem] setTarget:self];
    [[[self navigationItem] leftBarButtonItem] setAction:@selector(displaySearch)];
    
    m_menuGroup = [[NSMutableArray alloc] initWithObjects:nil];
    self.groupImageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    self.parsedMenuGroups = [NSMutableArray array];
    self.workingPropertyString = [NSMutableString string];
    
    self.elementsToParse = [NSMutableArray array];
    [self.elementsToParse addObject:@"ID"];
    [self.elementsToParse addObject:@"GroupName"];
    [self.elementsToParse addObject:@"GroupImage"];
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_menuGroupTable setBackgroundColor:BACKGROUNDCOLOR];
    [m_menuTypeSelector setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR]; 
    
    //[self GetRestaurantsMenuItemGroups];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSInteger menuStatus = [[[ApplicationManager instance].dataCacheManager preferredLocation] multipleMenuStatus].intValue;

    if (menuStatus == 0)
    {
        m_brandingImage.hidden = FALSE;
        m_menuTypeSelector.hidden = TRUE;
    }
    else if (menuStatus == 1)
    {
        m_menuTypeSelector.hidden = FALSE;
        m_brandingImage.hidden = TRUE;
    }
    
    [self GetRestaurantsMenuItemGroups];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"Menu" withError:&error];
}

- (void) GetRestaurantsMenuItemGroups
{
    // Control the number of synch calls made to server for each menu item group
    // Get data from server only after an interval of x(refer DataCacheManager) calls to the cache manager
    
    if ([[ApplicationManager instance].dataCacheManager getMenuItemGroupSynchStatus] == FALSE)
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
    
    
    //Making a Soap Request to Server
    NSString *soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<GetRestaurantsMenuItemGroups_XML xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<RestID>%i</RestID>\n"
    "</GetRestaurantsMenuItemGroups_XML>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n", RESTAURANT_ID];    
    
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/GetRestaurantsMenuItemGroups_XML" forHTTPHeaderField:@"SOAPAction"];
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
    
    [m_parsedMenuGroups removeAllObjects];
    [m_groupImageDownloadsInProgress removeAllObjects];
    
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:m_fetchedResults]autorelease];
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
    if ([elementName isEqualToString:@"Group"])
	{
        self.group = [[[MenuItemGroup alloc] init] autorelease];
    }
    
    m_storingCharacterData = [m_elementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if (self.group)
	{
        if (m_storingCharacterData)
        {
            NSString *trimmedString = [m_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [m_workingPropertyString setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:@"ID"])
            {
                self.group.groupId = trimmedString;
            }
            else if ([elementName isEqualToString:@"GroupName"])
            {
                self.group.groupTitle = trimmedString;
            }
            else if ([elementName isEqualToString:@"GroupImage"])
            {
                self.group.groupImageURLString = trimmedString;
            }
        }
        
        if ([elementName isEqualToString:@"Group"])
        {
            [self.parsedMenuGroups addObject:self.group];  
            self.group = nil;
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

    [[ApplicationManager instance].dataCacheManager setMenuItemGroup:m_parsedMenuGroups];
    [[ApplicationManager instance].dataCacheManager initMenuItemsByGroup];
    
    [[self menuGroupTable] reloadData];
    
    if ([m_parsedMenuGroups count])
        m_statuslabel.hidden = TRUE;
    else
        m_statuslabel.hidden = FALSE;
    
    [m_activityIndicator stopAnimating];
    m_activityIndicator.hidden = YES;
    [m_activityIndicator release];
}

- (void) displayMyOrder
{
    [[[[ApplicationManager instance].uiManager orderController] orderTable] reloadData];
    [self presentModalViewController:(UIViewController*)[[ApplicationManager instance].uiManager orderController] animated:YES];
}

- (void) displaySearch
{
     SearchViewController *searchView =[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchView animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [m_menuGroup release];
    
    m_menuGroup = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager menuItemGroup]];
    
    return [m_menuGroup count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%i%i",[indexPath section],[indexPath row]];
    
    // Configure the cell...
    MenuTableViewCell *tableCell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:nil options:nil];
    
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[MenuTableViewCell class]])
        {
            tableCell = (MenuTableViewCell*)currentObject;
            break;
        }
    }
    
    m_groupImageHeight = tableCell.menuImage .frame.size.height;
    m_groupImageWidth  = tableCell.menuImage.frame.size.width;
    
    tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([indexPath row]%2 != 0)
    {
        [[tableCell menuTitle] setTextColor:TEXTCOLOR3];
        [[tableCell titleBackground] setImage:[UIImage imageNamed:@"shelf_grey.png"]];
    }else
    {
        [[tableCell menuTitle] setTextColor:TEXTCOLOR1];
    }
    
    MenuItemGroup *group = [m_menuGroup objectAtIndex:[indexPath row]];
    
    [[tableCell menuImage] setImage:[group groupPicture]];
    [[tableCell menuImage] roundEdgesToRadius:10];
    [[tableCell menuTitle] setText:[group groupTitle]];
    
    [[tableCell menuTitle] setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:18.0f]];  

    
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (!group.groupPicture)
    {
        if (self.menuGroupTable.dragging == NO && self.menuGroupTable.decelerating == NO)
        {
            [self startImageDownload:group forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        [[tableCell menuImage] setImage:[UIImage imageNamed:@"blank_loading.png"]];
             
    }
    else
    {
        [[tableCell menuImage] setImage:group.groupPicture];
    }
       
    return tableCell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    MenuTypeViewController *selectedMenuType = [[MenuTypeViewController alloc] initWithNibName:@"MenuTypeViewController" bundle:nil];
    
    [selectedMenuType setMenuGroup:[[m_menuGroup objectAtIndex:[indexPath row]] groupTitle]];
    
    [selectedMenuType setSelectedType:[m_menuTypeSelector selectedIndex]];
    
    [selectedMenuType setSelectedGroup:[indexPath row]];
    
    MenuItemGroup *group = [m_menuGroup objectAtIndex:[indexPath row]];
    [selectedMenuType setSelectedGroupId:[group groupId]];
    
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:selectedMenuType animated:YES]; 
    
    [selectedMenuType release];
    
    
}

- (void)segmentClickedAtIndex:(int)index onCurrentCell:(BOOL)isCurrent
{
    [[self menuGroupTable] reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)startImageDownload:(MenuItemGroup *)menuItemGroup forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [m_groupImageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil) 
    {
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.delegate = self;
        [m_groupImageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        
        MenuItemGroup *group = [m_menuGroup objectAtIndex:[indexPath row]];
        [imageDownloader setImageURLString:group.groupImageURLString];
        [imageDownloader setImageHeight:m_groupImageHeight];
        [imageDownloader setImageWidth :m_groupImageWidth];
        
        [imageDownloader startDownload];
        [imageDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.menuGroup count] > 0)
    {
        NSArray *visiblePaths = [self.menuGroupTable indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            MenuItemGroup *menuItem = [self.menuGroup objectAtIndex:indexPath.row];
            
            if (!menuItem.groupPicture) // avoid the app icon download if the app already has an icon
            {
                [self startImageDownload:menuItem forIndexPath:indexPath];
            }
        }
    }
}

// called by ImageDownloader when an image is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [m_groupImageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader != nil && imageDownloader.returnedImage != nil)
    {
        
        MenuTableViewCell *tableCell = (MenuTableViewCell *)[self.menuGroupTable cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        [[tableCell menuImage] setImage :imageDownloader.returnedImage];
        
        [[m_menuGroup objectAtIndex:indexPath.row] setGroupPicture:imageDownloader.returnedImage];
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



- (void)dealloc
{
    [m_menuGroup release];
    [m_groupImageDownloadsInProgress release];
    
    [super dealloc];
}

@end
