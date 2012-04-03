//
//  SavedOrderItemViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 14/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavedOrderItemViewController.h"
#import "MyOrderTableViewCell.h"
#import "Objects.h"

#import "FontLabel.h"
#import "RoundCorneredUIImageView.h"


@implementation SavedOrderItemViewController

@synthesize savedOrderItemTable = m_savedOrderItemTable;
@synthesize savedOrderItem      = m_savedOrderItem;

@synthesize orderGroupTitle     = m_orderGroupTitle;
@synthesize selectedOrderGroup  = m_selectedorderGroup;

@synthesize seledtedIndexPathArray = m_selectedIndexPathArray;
@synthesize tableEditMode          = m_tableEditMode;
@synthesize orderButtonLabel       = m_orderButtonLabel;

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
    [m_selectedIndexPathArray release];
    [m_savedOrderItem release];
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
    // Do any additional setup after loading the view from its nib.ß
    
    self.title =m_orderGroupTitle; 
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    m_selectedIndexPathArray = [[NSMutableArray alloc] init];   
    
    [m_orderButtonLabel setText:@"Add All to My Order"]; 
    [m_orderButtonLabel setTextColor:TEXTCOLOR3];
    [m_orderButtonLabel setZFont:[[ApplicationManager instance].fontManager zFontWithName:BOLDFONT pointSize:15.0f]];
    
    //Set colors from templates 
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_savedOrderItemTable setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
}

-(void)viewDidAppear:(BOOL)animated
{
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"SavedOrder" withError:&error];
}

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

    [m_savedOrderItem  removeAllObjects];
     m_savedOrderItem = nil;
    m_savedOrderItem = [[NSMutableArray alloc] initWithArray:[[[ApplicationManager instance].dataCacheManager savedOrderGroupItems] objectAtIndex:m_selectedorderGroup]];  
   
    return [m_savedOrderItem count];
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
    
    MenuItem *menuOrderItem = [m_savedOrderItem objectAtIndex:[indexPath row]];
    
    [[tableCell dishThumbnail] setImage:[menuOrderItem dishPicture]];
    [[tableCell dishThumbnail] roundEdgesToRadius:10];
    [[tableCell dishTitle]     setText:[menuOrderItem dishTitle]];
    [[tableCell dishTitle] setTextColor:TEXTCOLOR1];
    [[tableCell dishTitle]     setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:18.0f]];
    [[tableCell dishQuantity]  setText:[[NSString stringWithFormat:@"QUANTITY - "]stringByAppendingString:[menuOrderItem dishQuantity]]];  
    [[tableCell dishQuantity] setTextColor:TEXTCOLOR1];
    [[tableCell dishQuantity]  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]]; 
    
    //Resizing the cell on editmode
    tableCell.dishTitle.autoresizingMask           = UIViewAutoresizingFlexibleWidth;
    tableCell.backgroundImage.autoresizingMask     = UIViewAutoresizingFlexibleWidth;
    
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

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return UITableViewCellEditingStyleDelete;
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
      return 3;
}



//To toggle the Edit button between Done and Edit
- (void) setEditing:(BOOL)editing animated:(BOOL)animated 
{
    m_tableEditMode = editing;
    
    if (!m_tableEditMode)
    {
        [m_orderButtonLabel setText:@"Add All to My Order"];          
    }
    else
    {
        [m_orderButtonLabel setText:@"Add Selected to My Order"]; 
    }
    
    [super setEditing: editing animated: animated];
    [self.savedOrderItemTable setEditing:editing animated:animated];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        // Delete the row from the data source
        //[[[ApplicationManager instance].dataCacheManager savedOrderGroupItems] removeObjectAtIndex:[indexPath row]];
        
        [m_savedOrderItem removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
 
    if(m_tableEditMode)
    {
        [m_selectedIndexPathArray addObject:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(m_tableEditMode)
    {
        [m_selectedIndexPathArray removeObject:indexPath];
    }
}

-(IBAction) addToMyOrder:(id)sender
{
    NSMutableArray *itemsToAdd =[[NSMutableArray alloc]init];
    
    if(m_tableEditMode)
    {
        for (int i=0;i < [m_selectedIndexPathArray count];i++)
        {
            NSIndexPath *indexPath = [m_selectedIndexPathArray objectAtIndex:i];
            int indexOfItem = indexPath.row;
            
            [itemsToAdd addObject:[m_savedOrderItem objectAtIndex:indexOfItem]];
        }            
    }
    else
    {
        [itemsToAdd addObjectsFromArray:m_savedOrderItem];
    }
        
       
    for (int index=0;index < [itemsToAdd count];index++)
    {
        MenuItem *item = [itemsToAdd objectAtIndex:index];
        
        bool addedToMyOrder = false;
        for (int i=0;i < [[[ApplicationManager instance].dataCacheManager myOrder] count];i++)
        {
            MenuItem *m  = [[[ApplicationManager instance].dataCacheManager myOrder] objectAtIndex:i];
            
            if ([[m dishTitle] isEqualToString:[item dishTitle]])
            {
                [[[ApplicationManager instance].dataCacheManager myOrder] replaceObjectAtIndex:i withObject:item];
                addedToMyOrder = true;
            }
        }
        
        if (addedToMyOrder == false)
        {
            [[[ApplicationManager instance].dataCacheManager myOrder] addObject:item];
        }
    }
    
    NSString *message = [NSString stringWithFormat:@"%i items added to your order!",[itemsToAdd count]];
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [success show];
	[success release]; 
    
    NSInteger orderCount = [[[ApplicationManager instance].dataCacheManager myOrder] count];
    NSString *badge = [NSString stringWithFormat:@"%i",orderCount];
    [[[[ApplicationManager instance].appDelegate tabBarController].tabBar.items objectAtIndex:2] setBadgeValue:badge];
    
    [itemsToAdd release];
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
