//
//  SavedOrderViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 26/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Objects.h"
#import "FontLabel.h"

@interface SavedOrderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> 
{
    
    NSMutableArray *m_orderGroup;
    UITableView    *m_savedOrderTable;
    
    FontLabel      *m_statusLabel;
   
}
@property (nonatomic ,retain) IBOutlet UITableView *savedOrderTable;
@property (nonatomic ,retain) NSMutableArray       *orderGroup;

@property (nonatomic ,retain) IBOutlet FontLabel   *statusLabel;

@end
