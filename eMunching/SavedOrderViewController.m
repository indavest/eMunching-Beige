//
//  SavedOrderViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 26/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavedOrderViewController.h"
#import "MyOrderViewController.h"
#import "SavedOrderTableViewCell.h"
#import "Objects.h"
#import "SavedOrderItemViewController.h"

#import "FontLabel.h"
#import "RoundCorneredUIImageView.h"


@interface SavedOrderViewController (PrivateMethods)

    - (void) displayMyOrder;

@end


@implementation SavedOrderViewController

@synthesize orderGroup      = m_orderGroup;
@synthesize savedOrderTable = m_savedOrderTable;

@synthesize statusLabel     = m_statusLabel;

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
    [m_orderGroup release];
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
    
    [[[self navigationItem] rightBarButtonItem] setTarget:self];
    [[[self navigationItem] rightBarButtonItem] setAction:@selector(displayMyOrder)];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;    
    
    [m_statusLabel setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:15.0f]];
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_savedOrderTable setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.savedOrderTable reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"SavedOrders" withError:&error];
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
    [m_orderGroup release];
    
    m_orderGroup = [[NSMutableArray alloc] initWithArray:[[ApplicationManager instance].dataCacheManager savedOrderGroup ]];    
    
    if([m_orderGroup count]>0)
    {
        m_statusLabel.hidden = TRUE;
    }
    else
    {
        m_statusLabel.hidden = FALSE;
    }
    
    return [m_orderGroup count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%i%i",[indexPath section],[indexPath row]];
    
    // Configure the cell...
    SavedOrderTableViewCell *tableCell = [[SavedOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SavedOrderTableViewCell" owner:nil options:nil];
    
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[SavedOrderTableViewCell class]])
        {
            tableCell = (SavedOrderTableViewCell*)currentObject;
            break;
        }
    }
    
    
     OrderGroup *orderGroups = [m_orderGroup objectAtIndex:[indexPath row]];
    
    [[tableCell orderGroupTitle] setText:[orderGroups orderTitle]];
    [[tableCell orderGroupTitle] setTextColor:TEXTCOLOR1];
    [[tableCell orderGroupTitle] setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:18.0f]];
    [[tableCell orderGroupDateStamp] setText:[orderGroups orderDateStamp]];
    [[tableCell orderGroupDateStamp] setTextColor:TEXTCOLOR1];
    [[tableCell orderGroupDateStamp] setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:13.0f]];
    
    //Resizing the cell on editmode
    tableCell.backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [tableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
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


//To toggle the Edit button between Done and Edit
- (void) setEditing:(BOOL)editing animated:(BOOL)animated 
{
    [super setEditing: editing animated: animated];
    [self.savedOrderTable setEditing:editing animated:animated];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [[[ApplicationManager instance].dataCacheManager savedOrderGroup] removeObjectAtIndex:[indexPath row]];
        [[[ApplicationManager instance].dataCacheManager savedOrderGroupItems] removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
    SavedOrderItemViewController *savedOrderItem = [[SavedOrderItemViewController alloc] initWithNibName:@"SavedOrderItemViewController" bundle:nil];
    
    [savedOrderItem setOrderGroupTitle:[[m_orderGroup objectAtIndex:[indexPath row]] orderTitle]];
    [savedOrderItem setSelectedOrderGroup:[indexPath row]];
    
    [self.navigationController pushViewController:savedOrderItem animated:YES]; 
    
    [savedOrderItem release];

}

-(void)displayMyOrder
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

@end
