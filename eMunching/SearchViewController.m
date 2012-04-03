//
//  SearchViewController.m
//  eMunching
//
//  Created by John Paul on 04/10/11.
//  Copyright 2011 Plackal Techno Systems Pvt. Ltd. All rights reserved.
//

#import "SearchViewController.h"
#import "SpecialTableViewCell.h"
#import "Objects.h"
#import "FontLabel.h"
#import "RoundCorneredUIImageView.h"
#import "MenuItemViewController.h"


@implementation SearchViewController

@synthesize searchController   = m_searchController;
@synthesize searchResultsTable = m_searchResultsTable;

@synthesize menuItems          = m_menuItems;


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
    
    [m_menuItems release];
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
    [m_searchResultsTable setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"Search" withError:&error];
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
    [m_menuItems removeAllObjects];
    m_menuItems = nil;
    
    m_menuItems = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager searchResults]];            

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
    
    MenuItem *menuItemByGroup = [m_menuItems objectAtIndex:[indexPath row]];
    
    [[tableCell specialImage] setImage:[menuItemByGroup dishPicture]];
    [[tableCell specialImage] roundEdgesToRadius:10];
    [[tableCell specialTitle] setText:[menuItemByGroup dishTitle]];
    [[tableCell specialTitle] setZFont:[[ApplicationManager instance].fontManager zFontWithName:BOLDFONT pointSize:18.0f]];
    [[tableCell specialDescription] setText:[menuItemByGroup dishDescription]];
    [[tableCell specialDescription] setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];
    
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (!(([indexPath row] % 2) == 0))
    {
        [tableCell reverseLocations];
    }
    
    
    if (!menuItemByGroup.dishPicture)
    {
        [[tableCell specialImage] setImage:[UIImage imageNamed:@"blank_loading.png"]];
    }
    else
    {
        [[tableCell specialImage] setImage:menuItemByGroup.dishPicture];
    }
    
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuItem *selectedMenuItem = [m_menuItems objectAtIndex:[indexPath row]];
    
    // Navigation logic may go here. Create and push another view controller.
    MenuItemViewController *menuItemView = [[MenuItemViewController alloc] initWithNibName:@"MenuItemView" bundle:nil];
    
    [menuItemView setMenuItem:selectedMenuItem];
    

    [menuItemView setCacheArrayToUpdate:@"SearchResults"];
    
    [menuItemView setSelectedItemIndex:[indexPath row]];
    
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:menuItemView animated:YES]; 
    
    [selectedMenuItem release];
}

//UISearchBarDelegate Methods

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    UIButton *cancelButton = nil;
    for(UIView *subView in controller.searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            cancelButton = (UIButton*)subView;
        }
    }
    
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    controller.searchResultsTableView.backgroundColor = BACKGROUNDCOLOR;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText; 
{
    
    if ([searchText length] == 0)
        return;
    
    NSMutableArray *foundItems = [[NSMutableArray alloc] init];
    
    for (int i=0;i < [[[ApplicationManager instance].dataCacheManager chefSpecials] count];i++)
    {
        MenuItem *item  = [[[ApplicationManager instance].dataCacheManager chefSpecials] objectAtIndex:i];
        
        NSRange match;
        match = [[item dishTitle] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (match.location == NSNotFound)
        {
        }
        else
        {
            NSLog (@"Match found");
            [foundItems addObject:item];
        }
    }
    
    for (int i=0;i < [[[ApplicationManager instance].dataCacheManager featuredDeals] count];i++)
    {
        MenuItem *item  = [[[ApplicationManager instance].dataCacheManager featuredDeals] objectAtIndex:i];
        
        NSRange match;
        match = [[item dishTitle] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (match.location == NSNotFound)
        {
        }
        else
        {
            NSLog (@"Match found");
            [foundItems addObject:item];
        }       
    }
    
    for (int i=0;i < [[[ApplicationManager instance].dataCacheManager menuItemsByGroup1] count];i++)
    {
        
        NSMutableArray *menuItems = [[NSMutableArray alloc] initWithArray:[[[ApplicationManager instance].dataCacheManager menuItemsByGroup1]objectAtIndex:i]];
        
        for (int i=0;i < [menuItems count];i++)
        {
            MenuItem *item  = [menuItems objectAtIndex:i];
            
            NSLog(@"%@",[item dishTitle]);
            NSLog(@"%@",searchBar.text);
            
            NSRange match;
            match = [[item dishTitle] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (match.location == NSNotFound)
            {
            }
            else
            {
                NSLog (@"Match found");
                [foundItems addObject:item];
            }
        }
        
        [menuItems release];
    }
    
    for (int i=0;i < [[[ApplicationManager instance].dataCacheManager menuItemsByGroup2] count];i++)
    {
        
        NSMutableArray *menuItems = [[NSMutableArray alloc] initWithArray:[[[ApplicationManager instance].dataCacheManager menuItemsByGroup2]objectAtIndex:i]];
        
        for (int i=0;i < [menuItems count];i++)
        {
            MenuItem *item  = [menuItems objectAtIndex:i];
            
            NSRange match;
            match = [[item dishTitle] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (match.location == NSNotFound)
            {
            }
            else
            {
                NSLog (@"Match found");
                [foundItems addObject:item];
            }
        }
        
        [menuItems release];
    }
    
    
    [[ApplicationManager instance].dataCacheManager setSearchResults:foundItems];
    
    [m_searchResultsTable reloadData];
    
    [foundItems release];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar 
{
    [m_searchResultsTable reloadData];
    
    [m_searchController setActive:NO];
}

@end
