//
//  UIManager.h
//  eMunching
//
//  Created by Andrew Green on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyOrderViewController;

@interface UIManager : NSObject 
{
    MyOrderViewController *m_orderController;
}

@property (nonatomic, retain) MyOrderViewController *orderController;

@end
