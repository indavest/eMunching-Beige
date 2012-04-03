//
//  SearchViewController.h
//  eMunching
//
//  Created by John Paul on 04/10/11.
//  Copyright 2011 Plackal Techno Systems Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UIViewController 
{
    UISearchDisplayController *m_searchController;
    UITableView               *m_searchResultsTable;
    
    NSMutableArray *m_menuItems;
}

@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchController;
@property (nonatomic, retain) IBOutlet UITableView               *searchResultsTable;

@property (nonatomic, retain) NSMutableArray       *menuItems;

@end
