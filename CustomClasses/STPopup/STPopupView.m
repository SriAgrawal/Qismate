//
//  STPopupView.m
//  Qismet
//
//  Created by Lalit Kumar on 2/22/16.
//  Copyright © 2016 AppDupe. All rights reserved.
//

#import "STPopupView.h"

@protocol STPopupViewTouchEventDelegate <NSObject>

- (void)popupView:(STPopupView *)navigationBar touchDidMoveWithOffset:(CGFloat)offset;
- (void)popupView:(STPopupView *)navigationBar touchDidEndWithOffset:(CGFloat)offset;

@end
@interface STPopupView ()

@property (nonatomic, weak) id<STPopupViewTouchEventDelegate> touchEventDelegate;

@end

@implementation STPopupView
{
    BOOL _moving;
    CGFloat _movingStartY;
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        // Do something
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.draggable) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    NSLog(@"touch superview%@      %@",touch.view,self);
    
//    if ((touch.view == self || touch.view.superview == self) && !_moving) {
        _moving = YES;
        _movingStartY = [touch locationInView:self.window].y;
//    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.draggable) {
        [super touchesMoved:touches withEvent:event];
        return;
    }
    
    if (_moving) {
        UITouch *touch = [touches anyObject];
        float offset = [touch locationInView:self.window].y - _movingStartY;
        NSLog(@"touchEventDelegate: %@",self.touchEventDelegate);
      //  if ([self.touchEventDelegate respondsToSelector:@selector(popupNavigationBar:touchDidMoveWithOffset:)]) {
            [self.touchEventDelegate popupView:self touchDidMoveWithOffset:offset];
      //  }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.draggable) {
        [super touchesCancelled:touches withEvent:event];
        return;
    }
    
    if (_moving) {
        UITouch *touch = [touches anyObject];
        float offset = [touch locationInView:self.window].y - _movingStartY;
        [self movingDidEndWithOffset:offset];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.draggable) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    
    if (_moving) {
        UITouch *touch = [touches anyObject];
        float offset = [touch locationInView:self.window].y - _movingStartY;
        [self movingDidEndWithOffset:offset];
    }
}

- (void)movingDidEndWithOffset:(float)offset
{
    _moving = NO;
   // if ([self.touchEventDelegate respondsToSelector:@selector(popupNavigationBar:touchDidEndWithOffset:)]) {
        [self.touchEventDelegate popupView:self touchDidEndWithOffset:offset];
   // }
}



@end
