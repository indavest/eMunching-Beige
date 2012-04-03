//
//  ImageDownloader.h
//  eMunching
//
//  Created by Ranjit Kadam on 08/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@class HomeViewController;
@class MenuViewController;
@class MenuTypeViewController;

@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSObject
{
   
    NSString        *m_imageURLString;
    int             m_imageHeight;
    int             m_imageWidth;
    
    UIImage         *m_returnedImage;
    
    NSIndexPath     *m_indexPathInTableView;
    id <ImageDownloaderDelegate> m_delegate;
    
    NSMutableData   *m_activeDownload;
    
    NSURLConnection *imageConnection;
}


@property (nonatomic, retain) NSString          *imageURLString;
@property (nonatomic, retain) UIImage           *returnedImage;

@property (nonatomic, retain) NSIndexPath   *indexPathInTableView;
@property (nonatomic, assign) id <ImageDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData   *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

@property (nonatomic) int imageHeight;
@property (nonatomic) int imageWidth;
 

- (void) startDownload;
- (void) cancelDownload;

@end

@protocol ImageDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end