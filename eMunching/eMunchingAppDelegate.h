//
//  eMunchingAppDelegate.h
//  eMunching
//
//  Created by Andrew Green on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eMunchingAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
    NSMutableArray *m_savedOrderGroup;
    NSMutableArray *m_savedOrderGroupItems;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) NSMutableArray *savedOrderGroup;
@property (nonatomic, retain) NSMutableArray *savedOrderGroupItems;

@end
