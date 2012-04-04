//
//  DealsViewController.m
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DealsViewController.h"
#import "MyOrderViewController.h"
#import "SpecialTableViewCell.h"
#import "MenuItemViewController.h"

#import "Objects.h"
#import "PLSegmentView.h"
#import "FontLabel.h"
#import "RoundCorneredUIImageView.h"


@interface DealsViewController (PrivateMethods)

- (void) displayMyOrder;
- (void) getRestaurantMenuItems:(NSString *) dealType;
- (void) startImageDownload:(MenuItem *)menuItem forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation DealsViewController

@synthesize specialSelector         = m_specialSelector;
@synthesize currentSpecialsTable    = m_currentSpecialsTable;

@synthesize currentSpecials         = m_currentSpecials;
@synthesize selectedDealType        = m_selectedDealType;

@synthesize fetchedResults          = m_fetchedResults;
@synthesize parsedCurrentSpecials   = m_parsedCurrentSpecials;
@synthesize menuItem                = m_menuItem;
@synthesize workingPropertyString   = m_workingPropertyString;
@synthesize elementsToParse         = m_elementsToParse;
@synthesize storingCharacterData    = m_storingCharacterData;

@synthesize imageDownloadsInProgress = m_imageDownloadsInProgress;

- (void)dealloc
{
    [m_parsedCurrentSpecials release];
    [m_menuItem release];
    [m_workingPropertyString release];
    [m_elementsToParse release];   
    [m_statuslabel release];
    
    [m_currentSpecials release];
    
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray* imageNormalArray = [@"chef_specials_toggle_inactive.png featured_deals_toggle_inactive.png" componentsSeparatedByString:@" "];
	NSArray* imageSelectedArray = [@"chef_specials_toggle_active.png featured_deals_toggle_active.png" componentsSeparatedByString:@" "];
    
    
	[m_specialSelector setupCellsByImagesName:imageNormalArray selectedImagesName:imageSelectedArray offset:CGSizeMake(160, 0)];
    [m_specialSelector setSelectedIndex:m_selectedDealType];

    [m_specialSelector setDelegate:self];
    
    m_statuslabel = [[FontLabel alloc] initWithFrame:CGRectMake(45, 160, 240, 60)];
    m_statuslabel.backgroundColor = [UIColor clearColor];
    m_statuslabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    m_statuslabel.numberOfLines = 2;
    m_statuslabel.text   = @"Sorry! no menu items found";
    m_statuslabel.hidden = TRUE;
    [m_statuslabel setTextColor:TEXTCOLOR1];
    [m_statuslabel setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:15.0f]];
    [self.view addSubview:m_statuslabel];
    
    if (!m_selectedDealType)
        [self getRestaurantMenuItems:@"1"];
    else
        [self getRestaurantMenuItems:@"2"];;

    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    //Add a My Order button to RightBarButtonItem
    UIBarButtonItem *myOrderButton = [[UIBarButtonItem alloc] 
                                      initWithTitle:@"My Order"                                            
                                      style:UIBarButtonItemStyleBordered 
                                      target:self 
                                      action:@selector(displayMyOrder)];
    
    self.navigationItem.rightBarButtonItem = myOrderButton;
    [myOrderButton release];
    
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
    [m_currentSpecialsTable setBackgroundColor:BACKGROUNDCOLOR];
    [m_specialSelector setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
}

- (void) displayMyOrder
{
    [[[[ApplicationManager instance].uiManager orderController] orderTable] reloadData];
    [self presentModalViewController:(UIViewController*)[[ApplicationManager instance].uiManager orderController] animated:YES];
}

- (void) getRestaurantMenuItems:(NSString *) dealType
{
    m_statuslabel.hidden = TRUE;
    
    // Control the number of synch calls made to server for chef specials and featured deals
    // Get data from server only after an interval of x(refer DataCacheManager) calls to the cache manager

    if ([[ApplicationManager instance].dataCacheManager getDealsSynchStatus:m_selectedDealType] == FALSE)
    {
        return;
    }
    
    //Start an activity indicator before the data is loaded from server
    m_activityIndicator =[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 40.0f, 40.0f)];
    [m_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    m_activityIndicator.center = self.view.center;
    [self.view addSubview:m_activityIndicator];
    [m_activityIndicator startAnimating];
    
    [m_specialSelector setUserInteractionEnabled:FALSE];

    
    self.parsedCurrentSpecials = [NSMutableArray array];
    self.workingPropertyString = [NSMutableString string];
    
    NSString *soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<GetRestaurantMenuItemsAll_XML xmlns=\"http://emunching.org/\">\n"
    "<UserName>eMunch</UserName>\n"
    "<PassWord>idnlgeah11</PassWord>\n"
    "<RestaurantID>%i</RestaurantID>\n"
    "<MealType>0</MealType>\n"
    "<DealType>%@</DealType>\n"
    "<MenuItemType>0</MenuItemType>\n"
    "<MealCategory>0</MealCategory>\n"   
    "</GetRestaurantMenuItemsAll_XML>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n", RESTAURANT_ID, dealType];
    
//    NSString *soapMessage = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
//                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//                            "<soap:Body>\n"
//                            "<GetRestaurantMenuItemsAll_XML xmlns=\"http://emunching.org/\">\n"
//                            "<UserName>eMunch</UserName>\n"
//                            "<PassWord>idnlgeah11</PassWord>\n"
//                            "<RestaurantID>5</RestaurantID>\n"
//                            "<DealType>0</DealType>\n"
//                            "<MenuItemType>0</MenuItemType>\n"
//                            "<MealCategory>0</MealCategory>\n"   
//                            "</GetRestaurantMenuItemsAll_XML>\n"
//                            "</soap:Body>\n"
//                            "</soap:Envelope>\n";
    
    NSURL *url = [NSURL URLWithString:@"http://www.emunching.com/eMunchingServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://emunching.org/GetRestaurantMenuItemsAll_XML" forHTTPHeaderField:@"SOAPAction"];
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
            else if ([elementName isEqualToString:@"ItemDesc"])
            {        
                self.menuItem.dishDescription = trimmedString;
            }
            else if ([elementName isEqualToString:@"ItemPrice"])
            {
                self.menuItem.dishPrice = trimmedString;
            }
            else if ([elementName isEqualToString:@"DiscountPrice"])
            {
                self.menuItem.dishDiscountPrice = trimmedString;
            }
            else if ([elementName isEqualToString:@"ItemImage1"])
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
            if ([self.menuItem isMenuItemOk])
            {
                [self.parsedCurrentSpecials addObject:self.menuItem];  
            }
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
    if ([m_parsedCurrentSpecials count])
    {
        if (!m_selectedDealType)
            [[ApplicationManager instance].dataCacheManager setChefSpecials:m_parsedCurrentSpecials];
        else
            [[ApplicationManager instance].dataCacheManager setFeaturedDeals:m_parsedCurrentSpecials];
    }
    
    [[self currentSpecialsTable] reloadData];

    if ([m_parsedCurrentSpecials count])
        m_statuslabel.hidden = TRUE;
    else
        m_statuslabel.hidden = FALSE;
    
    [m_activityIndicator stopAnimating];
    m_activityIndicator.hidden = YES;
    [m_activityIndicator release];
    
    [m_specialSelector setUserInteractionEnabled:TRUE];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"Deals" withError:&error];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
    return 115.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [m_currentSpecials release];
    
    // Return the number of rows in the section.
    switch ([m_specialSelector selectedIndex])
    {
        case CHEFSPECIALS:
            m_currentSpecials = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager chefSpecials]];
            break;
       
        case DAILYDEALS:
            m_currentSpecials = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager featuredDeals]];
            break;
        
        default:
            break;
    }
    
    return [m_currentSpecials count];
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
   
       
    MenuItem *currentSpecial = [m_currentSpecials objectAtIndex:[indexPath row]];
    
    [[tableCell specialImage] roundEdgesToRadius:10];
    [[tableCell specialTitle] setText:[currentSpecial dishTitle]];
    [[tableCell specialTitle] setTextColor:TEXTCOLOR1];
    [[tableCell specialTitle] setZFont:[[ApplicationManager instance].fontManager zFontWithName:BOLDFONT pointSize:18.0f]];
    [[tableCell specialDescription] setText:[currentSpecial dishDescription]];
    [[tableCell specialDescription] setTextColor:TEXTCOLOR1];
    [[tableCell specialDescription] setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];
    
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (!(([indexPath row] % 2) == 0))
    {
        [tableCell reverseLocations];
    }
    
    if (!currentSpecial.dishPicture)
    {
        if (self.currentSpecialsTable.dragging == NO && self.currentSpecialsTable.decelerating == NO)
        {
            [self startImageDownload:currentSpecial  forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        [[tableCell specialImage] setImage:[UIImage imageNamed:@"blank_loading.png"]];
    }
    else
    {
         [[tableCell specialImage] setImage:currentSpecial.dishPicture];
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
    
    MenuItem *selectedSpecial = [m_currentSpecials objectAtIndex:[indexPath row]];
    
    // Navigation logic may go here. Create and push another view controller.
    MenuItemViewController *selectedMenuItem = [[MenuItemViewController alloc] initWithNibName:@"MenuItemView" bundle:nil];
    
    [selectedMenuItem setMenuItem:selectedSpecial];	
    
    if (m_selectedDealType == 0)
        [selectedMenuItem setCacheArrayToUpdate:@"ChefSpecials"];
    else
        [selectedMenuItem setCacheArrayToUpdate:@"FeaturedDeals"];
    
    [selectedMenuItem setSelectedItemIndex:[indexPath row]];
    
    
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:selectedMenuItem animated:YES]; 
    
    [selectedMenuItem release];
}

#pragma mark -
#pragma mark Selector

- (void)segmentClickedAtIndex:(int)index onCurrentCell:(BOOL)isCurrent
{
    m_statuslabel.hidden = TRUE;
    
    NSArray *allImageDownloads = [self.imageDownloadsInProgress allValues];
    [allImageDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
    
    m_selectedDealType = index;
    if (index)
        [self getRestaurantMenuItems:@"2"];
    else
        [self getRestaurantMenuItems:@"1"];
        
    [[self currentSpecialsTable] reloadData];
    
}

#pragma mark -
#pragma mark Button Handlers


- (void) displaySearch
{
    
}

#pragma mark -
#pragma mark Table cell image support

- (void)startImageDownload:(MenuItem *)menuItem forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [m_imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil) 
    {
        imageDownloader = [[ImageDownloader alloc] init];
        [m_imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.delegate = self;
        
        MenuItem *currentSpecial = [m_currentSpecials objectAtIndex:[indexPath row]];
        [imageDownloader setImageURLString:currentSpecial.dishPictureURLString];
        [imageDownloader setImageHeight:m_menuImageHeight];
        [imageDownloader setImageWidth:m_menuImageWidth];
        
        [imageDownloader startDownload];
        [imageDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.currentSpecials count] > 0)
    {
        NSArray *visiblePaths = [self.currentSpecialsTable indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            MenuItem *menuItem = [self.currentSpecials objectAtIndex:indexPath.row];
            
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
    ImageDownloader *imageDownloader = [m_imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader != nil && imageDownloader.returnedImage != nil)
    {
       
        SpecialTableViewCell *tableCell = (SpecialTableViewCell *)[self.currentSpecialsTable cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        [[tableCell specialImage] setImage :imageDownloader.returnedImage];
        
        [[m_currentSpecials objectAtIndex:indexPath.row] setDishPicture:imageDownloader.returnedImage];
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

