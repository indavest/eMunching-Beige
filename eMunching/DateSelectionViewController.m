//
//  DateSelectionViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSelectionViewController.h"

@implementation DateSelectionViewController

@synthesize pickerTable   = m_pickerTable;
@synthesize pickerView    = m_pickerView; 
@synthesize dataArray     = m_dataArray;

@synthesize dateFormatter = m_dateFormatter;
@synthesize timeFormatter = m_timeFormatter;

@synthesize doneButton    = m_doneButton;

@synthesize mindate       = m_mindate;
@synthesize maxDate       = m_maxDate;
@synthesize interval      = m_interval;

@synthesize messageLabel  = m_messageLabel;

- (void)dealloc
{
    [m_dataArray release];
	[m_pickerView release];
	[m_dateFormatter release];
    [m_timeFormatter release];
    [m_doneButton release];

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
    
    self.dataArray = [NSArray arrayWithObjects:@"Date", @"Time", nil];
    
	m_dateFormatter = [[NSDateFormatter alloc] init];
	[m_dateFormatter setDateFormat:@"EEE MMM d, YYYY"];

    m_timeFormatter =[[NSDateFormatter alloc] init];
    [m_timeFormatter setDateFormat:@"h:mm a"];
    
    NSLog(@"%@",m_mindate);
    NSLog(@"%@",m_maxDate); 
    
    NSString *startDate = [m_dateFormatter stringFromDate:m_mindate];
    NSString *stopDate  = [m_dateFormatter stringFromDate:m_maxDate];
    NSString *startTime = [m_timeFormatter stringFromDate:m_mindate];
    NSString *stopTime = [m_timeFormatter stringFromDate:m_maxDate];
   
    NSString *messageString =[[[[[[[[[[[[[[@"Reservation accepted from:"stringByAppendingString:@"\n\n"]stringByAppendingString:startDate]stringByAppendingString:@"  "]stringByAppendingString:@"to"]stringByAppendingString:@"  "]stringByAppendingString:stopDate]stringByAppendingString:@"\n\n"]stringByAppendingString:@"between"]stringByAppendingString:@"\n\n"]stringByAppendingString:startTime]stringByAppendingString:@" "]stringByAppendingString:@"to"]stringByAppendingString:@" "]stringByAppendingString:stopTime];
    
    [m_messageLabel setTextColor:TEXTCOLOR1];
    [m_messageLabel  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
    [m_messageLabel setText:messageString];
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [m_pickerTable setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.dataArray = nil;
	self.dateFormatter = nil;
   
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
    
    [m_pickerView setMinimumDate:m_mindate];
    [m_pickerView setMaximumDate:m_maxDate];
    [m_pickerView setMinuteInterval:m_interval];
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"ReservationDate" withError:&error];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"CustomCellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCustomCellID] autorelease];
	}
	
	cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
	if(indexPath.row == 0)
    {
        cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[[ApplicationManager instance].dataCacheManager selectedDate]];
    }
    else if(indexPath.row == 1)
    {
        cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
        cell.detailTextLabel.text =[self.timeFormatter stringFromDate:[[ApplicationManager instance].dataCacheManager selectedDate]];
        
    }
	
	return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    self.pickerView.date = [[ApplicationManager instance].dataCacheManager selectedDate];
    
    if(indexPath.row ==0)
    {
        self.pickerView.datePickerMode = UIDatePickerModeDate;
    }
    else if(indexPath.row == 1)
    {
        self.pickerView.datePickerMode = UIDatePickerModeTime;
    }
    
    if (self.pickerView.superview == nil)
    {
        self.view.window.backgroundColor = [UIColor darkGrayColor];
        [self.view.window addSubview: self.pickerView];
        
        // size up the picker view to our screen and compute the start/end frame origin for our slide up animation
        //
        // compute the start frame
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        CGSize pickerSize = [self.pickerView sizeThatFits:CGSizeZero];
        CGRect startRect = CGRectMake(0.0,
                                      screenRect.origin.y + screenRect.size.height,
                                      pickerSize.width, pickerSize.height);
        self.pickerView.frame = startRect;
        
        // compute the end frame
        CGRect pickerRect = CGRectMake(0.0,
                                       screenRect.origin.y + screenRect.size.height - 265,
                                       pickerSize.width,
                                       pickerSize.height);
        // start the slide up animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        // we need to perform some post operations after the animation is complete
        [UIView setAnimationDelegate:self];
        
        self.pickerView.frame = pickerRect;
        
        // shrink the table vertical size to make room for the date picker
        CGRect newFrame = self.pickerTable.frame;
        newFrame.size.height -= self.pickerView.frame.size.height;
        self.pickerTable.frame = newFrame;
        [UIView commitAnimations];
        
        // add the "Done" button to the nav bar
        self.navigationItem.rightBarButtonItem = self.doneButton;
    }

}

- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it
	[self.pickerView removeFromSuperview];
}

- (IBAction)dateAction:(id)sender
{
    [[ApplicationManager instance].dataCacheManager setSelectedDate:self.pickerView.date];
    
    //NSIndexPath *indexPath = [self.pickerTable indexPathForSelectedRow];
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.pickerTable cellForRowAtIndexPath:myIP];
    
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.pickerView.date]; 
    
    myIP = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.pickerTable cellForRowAtIndexPath:myIP];
    
    cell.detailTextLabel.text = [self.timeFormatter stringFromDate:self.pickerView.date];   
}


- (IBAction)doneAction:(id)sender
{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect endFrame = self.pickerView.frame;
	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
	
	// start the slide down animation
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
    // we need to perform some post operations after the animation is complete
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
	
    self.pickerView.frame = endFrame;
	[UIView commitAnimations];
	
	// grow the table back again in vertical size to make room for the date picker
	CGRect newFrame = self.pickerTable.frame;
	newFrame.size.height += self.pickerView.frame.size.height;
	self.pickerTable.frame = newFrame;
	
	// remove the "Done" button in the nav bar
	self.navigationItem.rightBarButtonItem = nil;
	
	// deselect the current table row
	NSIndexPath *indexPath = [self.pickerTable indexPathForSelectedRow];
	[self.pickerTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self doneAction:nil];
    
}


@end
