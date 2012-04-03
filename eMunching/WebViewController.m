//
//  FbTweetViewController.m
//  eMunching
//
//  Created by Ranjit Kadam on 12/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize webView = m_webView;
@synthesize activityIndicator = m_activityIndicator;
@synthesize displayPage       = m_displayPage;
@synthesize contentToDisplay  = m_contentToDisplay; 
@synthesize hotDealTitle      = m_hotDealTitle;
@synthesize eventTitle        = m_eventTitle;


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
    
    if([m_displayPage isEqualToString:@"FacebookPage"])
    {
        self.navigationItem.title = @"";
        
        Location *prefLocation = [[ApplicationManager instance].dataCacheManager preferredLocation];
        
        NSString *urlAddress   = prefLocation.locationFacebookUrl;
        NSLog(@"%@",urlAddress);
        
        //Create a URL object.
        NSURL *url = [NSURL URLWithString:urlAddress];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        //Load the request in the UIWebView.
        [m_webView loadRequest:requestObj]; 
        
        NSError *error;
        [[GANTracker sharedTracker] trackPageview:@"FacebookPage" withError:&error];
    }
    else if([m_displayPage isEqualToString:@"TwitterPage"])
    {
        self.navigationItem.title = @"";
        
        Location *prefLocation = [[ApplicationManager instance].dataCacheManager preferredLocation];
        
        NSString *urlAddress   = prefLocation.locationTwitterUrl;
        NSLog(@"%@",urlAddress);
        
        //Create a URL object.
        NSURL *url = [NSURL URLWithString:urlAddress];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        //Load the request in the UIWebView.
        [m_webView loadRequest:requestObj]; 
        
        NSError *error;
       [[GANTracker sharedTracker] trackPageview:@"TwitterPage" withError:&error];
    }
    else if ([m_displayPage isEqualToString:@"HistoryPage"])
    {
        
        self.navigationItem.title = @"Our History";
        [m_webView loadHTMLString:m_contentToDisplay baseURL:nil];
        
        NSError *error;
        [[GANTracker sharedTracker] trackPageview:@"HistoryPage" withError:&error];
    
    }
    else if ([m_displayPage isEqualToString:@"HotDealsPage"])
    {
        self.navigationItem.title = m_hotDealTitle;
        [m_webView loadHTMLString:m_contentToDisplay baseURL:nil];
        
        NSError *error;
        [[GANTracker sharedTracker] trackPageview:m_hotDealTitle withError:&error];
        
        
    }
    else if ([m_displayPage isEqualToString:@"EventsPage"])
    {
        self.navigationItem.title = m_eventTitle;
        [m_webView loadHTMLString:m_contentToDisplay baseURL:nil];
        
        NSError *error;
        [[GANTracker sharedTracker] trackPageview:m_eventTitle withError:&error];
    }
    
    else if ([m_displayPage isEqualToString:@"WebSitePage"])
    {        
        Location *prefLocation = [[ApplicationManager instance].dataCacheManager preferredLocation];
        
        NSString *urlAddress   = prefLocation.locationWebSite;
        NSLog(@"%@",urlAddress);
      
        //Create a URL object.
        NSURL *url = [NSURL URLWithString:urlAddress];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        //Load the request in the UIWebView.
        [m_webView loadRequest:requestObj];
        
        NSError *error;
        [[GANTracker sharedTracker] trackPageview:prefLocation.locationWebSite withError:&error];
    }        
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    m_activityIndicator.hidden = FALSE;
    [m_activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
	[m_activityIndicator stopAnimating];
    m_activityIndicator.hidden = TRUE;
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
