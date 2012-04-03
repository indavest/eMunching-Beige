//
//  ModalUIPickerViewController.h
//  eMunching
//
//  Created by Andrew Green on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalUIPickerViewControllerDelegate <NSObject>

- (void) cancelSelected;
- (void) stringResultSelected:(NSString*)selected;

@end

@interface ModalUIPickerViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>
{    
    NSMutableArray *m_pickerValues;
    
    UINavigationBar *m_pickerNavigationBar;
    
    id<ModalUIPickerViewControllerDelegate> m_delegate;
}

@property (nonatomic, retain) NSMutableArray *pickerValues;

@property (nonatomic, retain) IBOutlet UINavigationBar *pickerNavigationBar;
@property (nonatomic, retain) id<ModalUIPickerViewControllerDelegate> delegate;

- (IBAction) handleButtonTouch:(id)sender;

@end
