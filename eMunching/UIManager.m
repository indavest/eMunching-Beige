//
//  UIManager.m
//  eMunching
//
//  Created by Andrew Green on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIManager.h"
#import "MyOrderViewController.h"

@implementation UIManager

@synthesize orderController = m_orderController;

- (id) init
{
    if (self == [super init])
    {
        // Custom Initialization
    }    
    
    return self;
}

- (MyOrderViewController*) orderController
{
    if (m_orderController == nil)
        m_orderController = [[MyOrderViewController alloc] initWithNibName:@"MyOrderView" bundle:nil];
    
    return m_orderController;
}

- (void) dealloc
{
    [super dealloc];
}

@end
