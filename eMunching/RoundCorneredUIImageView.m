//
//  RoundCorneredUIImageView.m
//  eMunching
//
//  Created by Andrew Green on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RoundCorneredUIImageView.h"


@implementation RoundCorneredUIImageView

- (void) roundEdgesToRadius:(NSInteger)radius
{
    CALayer *currentLayer = [self layer];
    
    [currentLayer setMasksToBounds:YES];
    [currentLayer setCornerRadius:radius];
}

@end
