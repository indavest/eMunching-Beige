//
//  EventTableViewCell.h
//  eMunching
//
//  Created by Ranjit Kadam on 06/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"


@interface EventTableViewCell : UITableViewCell
{
    UIImageView  *m_backgroundImage;
    
    FontLabel * m_eventName;
    FontLabel * m_eventDesc;
    FontLabel * m_eventDate;
    FontLabel * m_eventTime;        
}

@property (nonatomic ,retain) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, retain) IBOutlet FontLabel *eventName;
@property (nonatomic, retain) IBOutlet FontLabel *eventDesc;
@property (nonatomic, retain) IBOutlet FontLabel *eventDate;
@property (nonatomic, retain) IBOutlet FontLabel *eventTime;


@end
