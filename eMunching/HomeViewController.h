//
//  HomePageViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeViewController : UIViewController  <NSXMLParserDelegate>
{
    UIScrollView *m_scrollView;
    UIImage  *m_logoImage;
    UIButton *m_specialsButton;
    UIButton *m_dealsButton;
    
    NSMutableArray          *m_parsedLocations;
    NSMutableData           *m_locationResults;
    Location                *m_locationData;
    NSMutableArray          *m_elementsToParse;
    NSMutableString         *m_workingPropertyString;
    BOOL                    m_storingCharacterData;
    
    UIActivityIndicatorView *m_activityIndicator;

}

@property (nonatomic,retain) IBOutlet UIScrollView  *scrollView;
@property (nonatomic,retain) IBOutlet UIImage       *logoImage;
@property (nonatomic,retain) IBOutlet UIButton      *specialsButton;
@property (nonatomic,retain) IBOutlet UIButton      *dealsButton;

@property (nonatomic ,retain) NSMutableArray  *parsedLocations;
@property (nonatomic, retain) NSMutableData   *locationResults;
@property (nonatomic, retain) Location        *locationData;
@property (nonatomic, retain) NSMutableArray  *elementsToParse;
@property (nonatomic, retain) NSMutableString *workingPropertyString;
@property (nonatomic, assign) BOOL            storingCharacterData;



@end
