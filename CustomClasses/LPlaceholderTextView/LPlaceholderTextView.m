//
//  Created by Luka Gabrić.
//  Copyright (c) 2013 Luka Gabrić. All rights reserved.
//


#import "LPlaceholderTextView.h"


@implementation LPlaceholderTextView


#pragma mark - init & dealloc


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
        
    }
    
    return self;
}


- (void)initialize
{
    [[UITextView appearance] setTintColor:[UIColor whiteColor]];
    _placeholderColor = [UIColor whiteColor];
    [self layoutGUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Notification center


- (void)textChanged:(NSNotification *)notification
{
    if (notification.object == self)
        [self layoutGUI];
}


#pragma mark - layoutGUI


- (void)layoutGUI
{
    _placeholderLabel.alpha = [self.text length] > 0 || [_placeholderText length] == 0 ? 0 : 1;
}


#pragma mark - Setters


- (void)setText:(NSString *)text
{
    [super setText:text];
    [self layoutGUI];
}


- (void)setPlaceholderText:(NSString*)placeholderText
{
	_placeholderText = placeholderText;
	[self setNeedsDisplay];
}


- (void)setPlaceholderColor:(UIColor*)color
{
	_placeholderColor = color;
	[self setNeedsDisplay];
}


#pragma mark - drawRect


- (void)drawRect:(CGRect)rect
{
    if ([_placeholderText length] > 0)
    {
        if (!_placeholderLabel)
        {
            _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 8, self.bounds.size.width - 8, 0)];
            _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeholderLabel.numberOfLines = 0;
            _placeholderLabel.font = self.font;
            _placeholderLabel.backgroundColor = [UIColor clearColor];
            _placeholderLabel.alpha = 0;
            [self addSubview:_placeholderLabel];
        }
        
        _placeholderLabel.text = _placeholderText;
        _placeholderLabel.textColor = _placeholderColor;
        [_placeholderLabel sizeToFit];
      // [_placeholderLabel setFrame:CGRectMake((windowWidth - _placeholderLabel.frame.size.width)/2, 8, _placeholderLabel.frame.size.width, _placeholderLabel.frame.size.height)];
        [_placeholderLabel setFrame:CGRectMake(5, 5, _placeholderLabel.frame.size.width+5, _placeholderLabel.frame.size.height)];
        [self sendSubviewToBack:_placeholderLabel];
    }
    
    [self layoutGUI];
    
    [super drawRect:rect];
}


#pragma mark -


@end
