//
//  ImageDownloader.m
//  eMunching
//
//  Created by Ranjit Kadam on 08/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageDownloader.h"

#define kAppIconHeight 48 //sample hieght still not confirmed


@implementation ImageDownloader

@synthesize imageURLString       = m_imageURLString;
@synthesize returnedImage        = m_returnedImage;  

@synthesize indexPathInTableView = m_indexPathInTableView;
@synthesize delegate             = m_delegate;

@synthesize activeDownload       = m_activeDownload;
@synthesize imageConnection      = m_imageConnection;

@synthesize imageHeight          = m_imageHeight;
@synthesize imageWidth           = m_imageWidth;

- (void)dealloc
{

    [m_indexPathInTableView release];
    
    [m_activeDownload release];
    
    [m_imageConnection release];
    
    [super dealloc];
}

-(void) startDownload
{
    
    self.activeDownload = [NSMutableData data];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:[m_imageURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] delegate:self];
    
    self.imageConnection = conn;
    
    NSLog(@"%@",[m_imageURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    [conn release];
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   
    [self.activeDownload appendData:data];
      
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload  = nil;
    
    NSLog(@"Connection failed");
    
    // Release the connection now that it's finished
    self.imageConnection  =  nil;
    
//    [delegate appImageDidLoad:self.indexPathInTableView];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"DONE. Received image: %d", [m_activeDownload length]);
    
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];

    if(image != nil && image.size.width != m_imageWidth && image.size.height != m_imageHeight)                                                       
	{
        CGSize itemSize = CGSizeMake(m_imageWidth, m_imageHeight);
		
        UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.returnedImage = UIGraphicsGetImageFromCurrentImageContext();

		UIGraphicsEndImageContext();
    }
    else
    {
        self.returnedImage = image;
    }
    
    self.activeDownload  = nil;
    [image release];
       
    // Release the connection now that it's finished
    self.imageConnection  = nil;
    
    // call our delegate and tell it that our icon is ready for display
    [m_delegate appImageDidLoad:self.indexPathInTableView];
}

@end

