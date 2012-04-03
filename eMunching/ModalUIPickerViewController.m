//
//  ModalUIPickerViewController.m
//  eMunching
//
//  Created by Andrew Green on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModalUIPickerViewController.h"

@interface ModalUIPickerViewController (PrivateMethods)

- (void) removeModal;

@end

@implementation ModalUIPickerViewController

@synthesize pickerValues = m_pickerValues;
@synthesize pickerNavigationBar = m_pickerNavigationBar;
@synthesize delegate = m_delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }

    m_pickerValues = [[NSMutableArray alloc] initWithObjects:nil];
    
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
    
    [m_pickerNavigationBar setTintColor:TINTCOLOR];
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
#pragma mark Button Handler
- (IBAction) handleButtonTouch:(id)sender
{
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    int tag = [button tag];
    
    switch (tag)
    {
        case 0:
            [self removeModal];
            break;
        default:
            break;
    }
}

- (void) removeModal
{
    [m_delegate cancelSelected];
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [m_pickerValues count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSLog(@"%@",[m_pickerValues objectAtIndex:row]);
    return [m_pickerValues objectAtIndex:row];
} 

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    [m_delegate stringResultSelected:[m_pickerValues objectAtIndex:row]];
}

@end
