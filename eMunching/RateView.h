//
//  RateView.h
//  eMunching
//
//  Created by Ranjit Kadam on 03/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RateView;
@protocol RateViewDelegate
- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating;
@end

@interface RateView : UIView 
{
    UIImage *_notSelectedImage;
    UIImage *_halfSelectedImage;
    UIImage *_fullSelectedImage;
    float _rating;
    BOOL _editable;
    NSMutableArray *_imageViews;
    int _maxRating;
    int _midMargin;
    int _leftMargin;
    CGSize _minImageSize;
    id <RateViewDelegate> _delegate;
}

@property (nonatomic, retain) UIImage *notSelectedImage;
@property (nonatomic, retain) UIImage *halfSelectedImage;
@property (nonatomic, retain) UIImage *fullSelectedImage;
@property (nonatomic, assign) float rating;
@property  BOOL editable;
@property  (nonatomic, assign) int maxRating;
@property (assign) id <RateViewDelegate> delegate;
@property  int leftMargin;

@end


