//
//  SavedOrderItemViewController.h
//  eMunching
//
//  Created by Ranjit Kadam on 14/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"


@interface SavedOrderItemViewController : UIViewController<UITabBarDelegate,UITableViewDataSource>
{
    UITableView    *m_savedOrderItemTable;
    NSMutableArray *m_savedOrderItem;
    
    NSString       *m_orderGroupTitle;
    NSInteger      m_selectedorderGroup;
    
    
    NSMutableArray *m_selectedIndexPathArray;
    BOOL           m_tableEditMode;
    FontLabel      *m_orderButtonLabel;
    
}

@property (nonatomic,retain) IBOutlet UITableView *savedOrderItemTable;
@property (nonatomic,retain) NSMutableArray       *savedOrderItem;

@property (nonatomic,retain) NSString             *orderGroupTitle;
@property (nonatomic)        NSInteger            selectedOrderGroup;

@property (nonatomic ,retain) NSMutableArray      *seledtedIndexPathArray;
@property (nonatomic, assign) BOOL                tableEditMode;
@property (nonatomic ,retain) IBOutlet FontLabel  *orderButtonLabel;

-(IBAction) addToMyOrder:(id)sender;

@end
