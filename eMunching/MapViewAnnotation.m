//
//  MapViewAnnotation.m
//  eMunching
//
//  Created by Ranjit Kadam on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewAnnotation.h"


@implementation MapViewAnnotation

@synthesize coordinate;
@synthesize title    = m_title;
@synthesize subtitle = m_subtitle;


-(void) dealloc
{
    [m_title release];
    [m_subtitle release];
       
    [super dealloc];
}

@end



