//
//  UIView+STPopupPreview.h
//  STPopupPreview
//
//  Created by Kevin Lin on 22/5/16.
//  Copyright © 2016 Sth4Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPopupPreviewRecognizer.h"
//#import <STPopupPreview/STPopupPreviewRecognizer.h>

@interface UIView (STPopupPreview)

/**
 The attached preview recognizer.
 */
@property (nonatomic, strong) STPopupPreviewRecognizer *popupPreviewRecognizer;

@end
