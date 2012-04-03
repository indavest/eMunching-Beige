//
//  MenuItemViewController.h
//  eMunching
//
//  Created by Andrew Green on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalUIPickerViewController.h"
#import "ImageDownloader.h"
#import "FBConnect.h"

@class FontLabel;
@class MenuItem;

@interface MenuItemViewController : UIViewController <UIScrollViewDelegate,ImageDownloaderDelegate,FBRequestDelegate,FBDialogDelegate,FBSessionDelegate>
{
    MenuItem      *m_menuItem;
    
    NSString      *m_cacheArrayToUpdate;
    NSInteger     m_selectedGroupIndex;
    NSInteger     m_selectedItemIndex;
    
    FontLabel     *m_itemTitle;
    FontLabel     *m_itemDescription;
    FontLabel     *m_itemPrice;
    UIImageView   *m_strikeThrough;
    FontLabel     *m_itemActualPrice;
    FontLabel     *m_addToOrderQuantity;
    UIScrollView  *m_itemImagesScroll;
    UIPageControl *m_itemImagesPageControl;
    
    NSInteger     m_itemCount;
    
    NSMutableArray              *m_imageViews;
    NSMutableDictionary         *m_imageDownloadsInProgress;
    
    UIView  *containerView;
    
    Facebook      *m_facebook;
}

@property (nonatomic, retain) MenuItem               *menuItem;

@property (nonatomic, retain) NSString               *cacheArrayToUpdate;
@property (nonatomic, assign) NSInteger              selectedGroupIndex;
@property (nonatomic, assign) NSInteger              selectedItemIndex;

@property (nonatomic, retain) IBOutlet FontLabel     *itemTitle;
@property (nonatomic, retain) IBOutlet FontLabel     *itemDescription;
@property (nonatomic, retain) IBOutlet FontLabel     *itemPrice;
@property (nonatomic, retain) IBOutlet UIImageView   *strikeThrough;
@property (nonatomic, retain) IBOutlet FontLabel     *itemActualPrice;
@property (nonatomic, retain) IBOutlet FontLabel     *addToOrderQuantity;
@property (nonatomic, retain) IBOutlet UIScrollView  *itemImagesScroll;
@property (nonatomic, retain) IBOutlet UIPageControl *itemImagesPageControl;

@property (nonatomic, retain) NSMutableArray         *imageViews;
@property (nonatomic, retain) NSMutableDictionary    *imageDownloadsInProgress;

@property (nonatomic, retain) Facebook               *facebook;

// Button Handlers
- (IBAction) handleButton:(id)sender;

// ImageDownloaderDelegate

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
