//
//  ContactUsViewController.h
//  eMunching
//
//  Created by Andrew Green on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Objects.h"
#import "FontLabel.h"


@interface ContactUsViewController : UIViewController<MFMailComposeViewControllerDelegate> 
{
    UIScrollView *m_scrollView;
    
    FontLabel    *m_phoneNumberHeader;
    FontLabel    *m_emailAddressHeader;
    FontLabel    *m_locationNameHeader;
    FontLabel    *m_facebookUrlHeader;
    FontLabel    *m_twitterUrlHeader;
    
    
    FontLabel    *m_website;
    FontLabel    *m_phoneNumber;
    FontLabel    *m_emailAddress;
    FontLabel    *m_locationName;
    FontLabel    *m_facebookUrl;
    FontLabel    *m_twitterUrl;
    
    UIImageView  *m_locationNameImage;
    UIImageView  *m_facebookImage;
    UIImageView  *m_twitterImage;
    
    UIButton     *m_locationNameButton;
    UIButton     *m_facebookButton;
    UIButton     *m_twitterButton;

}

@property (nonatomic,retain) IBOutlet UIScrollView  *scrollView;

@property (nonatomic,retain) IBOutlet FontLabel *phoneNumberHeader;
@property (nonatomic,retain) IBOutlet FontLabel *emailAddressHeader;
@property (nonatomic,retain) IBOutlet FontLabel *locationNameHeader;
@property (nonatomic,retain) IBOutlet FontLabel *facebookUrlHeader;
@property (nonatomic,retain) IBOutlet FontLabel *twitterUrlHeader;

@property (nonatomic,retain) IBOutlet FontLabel *website;
@property (nonatomic,retain) IBOutlet FontLabel *phoneNumber;
@property (nonatomic,retain) IBOutlet FontLabel *emailAddress;
@property (nonatomic,retain) IBOutlet FontLabel *locationName;
@property (nonatomic,retain) IBOutlet FontLabel *facebookUrl;
@property (nonatomic,retain) IBOutlet FontLabel *twitterUrl;

@property (nonatomic,retain) IBOutlet UIImageView *locationNameImage;
@property (nonatomic,retain) IBOutlet UIImageView *facebookImage;
@property (nonatomic,retain) IBOutlet UIImageView *twitterImage;

@property (nonatomic,retain) IBOutlet UIButton *locationNameButton;
@property (nonatomic,retain) IBOutlet UIButton *facebookButton;
@property (nonatomic,retain) IBOutlet UIButton *twitterButton;

@end
