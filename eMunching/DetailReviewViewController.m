//
//  DetailReviewViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 30/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailReviewViewController.h"


@implementation DetailReviewViewController

@synthesize pageToDisplay = m_pageToDisplay;

@synthesize detailReview = m_detailReview;
@synthesize reviewerName = m_reviewerName;

@synthesize star1           = m_star1;
@synthesize star2           = m_star2;
@synthesize star3           = m_star3;
@synthesize star4           = m_star4;
@synthesize star5           = m_star5;

@synthesize reviewDetail = m_reviewDetail;
@synthesize menuItem     = m_menuItem;


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
    
    
    if ([self.pageToDisplay isEqualToString:@"detailedreview"])
    {
        self.navigationItem.title =@"Reviews";
        
        m_detailReview.text = m_reviewDetail.reviewText;
        m_reviewerName.text = m_reviewDetail.reviewName;
        
        NSString *starRating =[m_reviewDetail reviewRating];
        NSLog(@"%@",starRating);
        
        if ([starRating isEqualToString:@"1"])
        {
            [m_star1 setImage:[UIImage imageNamed:@"star_active.png"]];
        }
        else if ([starRating isEqualToString:@"2"])
        {
            [m_star1 setImage:[UIImage imageNamed:@"star_active.png"]];
            [m_star2 setImage:[UIImage imageNamed:@"star_active.png"]];
        }
        else if ([starRating isEqualToString:@"3"])
        {
            [m_star1 setImage:[UIImage imageNamed:@"star_active.png"]];
            [m_star2 setImage:[UIImage imageNamed:@"star_active.png"]];
            [m_star3 setImage:[UIImage imageNamed:@"star_active.png"]];  
        }
        else if ([starRating isEqualToString:@"4"])
        {
            [m_star1 setImage:[UIImage imageNamed:@"star_active.png"]];
            [m_star2 setImage:[UIImage imageNamed:@"star_active.png"]];
            [m_star3 setImage:[UIImage imageNamed:@"star_active.png"]];
            [m_star4 setImage:[UIImage imageNamed:@"star_active.png"]];
        }
        else if ([starRating isEqualToString:@"5"])
        {
            [m_star1 setImage:[UIImage imageNamed:@"star_active.png"]];
            [m_star2 setImage:[UIImage imageNamed:@"star_active.png"]];
            [m_star3 setImage:[UIImage imageNamed:@"star_active.png"]];
            [m_star4 setImage:[UIImage imageNamed:@"star_active.png"]];
            [m_star5 setImage:[UIImage imageNamed:@"star_active.png"]];
        }
    }
    else if ([self.pageToDisplay isEqualToString:@"detailedMenuDescription"])
    {
        m_star1.hidden = true;
        m_star2.hidden = true;
        m_star3.hidden = true;
        m_star4.hidden = true;
        m_star5.hidden = true;
        
        [m_reviewerName setFrame:CGRectMake(25.0, 25.0, 270.0, 21.0)];
        
        m_reviewerName.text = m_menuItem.dishTitle;
        m_detailReview.text = m_menuItem.dishDescription;        
    }
    
    
    //Set colors from templates
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    [self.navigationController.navigationBar setTintColor:TINTCOLOR];   
    
    [m_reviewerName setTextColor:TEXTCOLOR1];
    [m_detailReview setTextColor:TEXTCOLOR1];
    
    [m_reviewerName  setZFont:[[ApplicationManager instance].fontManager zFontWithName:REGULARFONT pointSize:12.0f]];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"DetailedReviews" withError:&error];
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
