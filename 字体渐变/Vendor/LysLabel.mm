//
//  LysLabel.m
//  ParseLyrics
//
//  Created by admin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LysLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "ParseLyric.h"
//#import "SCListener.h"

#define lysFont     [UIFont boldSystemFontOfSize:18]
#define normalColor [UIColor whiteColor]
#define actColor    [UIColor blueColor]

extern  NSString        *notify_wordFrequency;
static Float32             previousFrequency = 0; 

@implementation LysLabel

+(Float32)getSrcWordFrequency
{
    return previousFrequency;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    CGRect frame = self.frame;
    if(self)
    {
        self.font = lysFont;
        self.textColor = normalColor;
        self.shadowColor = [UIColor grayColor];
        self.shadowOffset = CGSizeMake(0.4f, 0.4f);
        
        shadeView = [[[UIView alloc]initWithFrame:self.bounds]autorelease];        
        [self addSubview:shadeView];
        actionLabel = [[[UILabel alloc]initWithFrame:self.bounds]autorelease];
        actionLabel.backgroundColor = [UIColor clearColor];
        actionLabel.textColor = actColor;
        actionLabel.font = lysFont;
        [shadeView addSubview:actionLabel];
        
        shadeView.layer.masksToBounds = YES;
        frame = shadeView.frame;
        frame.size.width = 1;
        shadeView.frame = frame;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.font = lysFont;
        self.textColor = normalColor;
        self.shadowColor = [UIColor grayColor];
        self.shadowOffset = CGSizeMake(0.4f, 0.4f);
        
        shadeView = [[[UIView alloc]initWithFrame:self.bounds]autorelease];        
        [self addSubview:shadeView];
        actionLabel = [[[UILabel alloc]initWithFrame:self.bounds]autorelease];
        actionLabel.backgroundColor = [UIColor clearColor];
        actionLabel.textColor = actColor;
        actionLabel.font = lysFont;
        [shadeView addSubview:actionLabel];
        
        shadeView.layer.masksToBounds = YES;
        _shadeFrame = shadeView.frame;
        _shadeFrame.size.width = 1;
        shadeView.frame = _shadeFrame;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)showText:(NSString*)text animationTime:(float)time
{
    self.text  = text;
    actionLabel.text = text;
    _shadeFrame = shadeView.frame;
    _shadeFrame.size.width = 1;
    shadeView.frame = _shadeFrame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:time];
    _shadeFrame.size.width = self.frame.size.width;
    shadeView.frame = _shadeFrame;
    [UIView commitAnimations];
}


-(void)doAnimation
{
    if(wordOffset < _line.words.count)
    {        
        LysWord *w = [_line.words objectAtIndex:wordOffset++];
        CGSize  sz = [w.word sizeWithFont:self.font];
        _shadeFrame.size.width += sz.width+0.5;
        NSTimeInterval time = (double)w.timeLenth/1000.0f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:time];
        shadeView.frame = _shadeFrame;
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(doAnimation)];
        [UIView commitAnimations];  
    }
}

-(void)showLine:(LysLine*)line
{
    if(_line != line)
    {
        [_line release];
        _line = [line retain];
    }
    
    
    wordOffset = 0;
    self.text  = line.text;
    actionLabel.text = line.text;
    _shadeFrame = shadeView.frame;
    _shadeFrame.size.width = 1;
    shadeView.frame = _shadeFrame;
    [self doAnimation];   

}

-(void)setText:(NSString *)text
{
    [super setText:text];
    actionLabel.text = @"";
    _shadeFrame = shadeView.frame;
    _shadeFrame.size.width = 1;
    shadeView.frame = _shadeFrame;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    actionLabel.frame = self.bounds;
}

-(void)stop
{
    
    [_line release];
    _line = nil;
    self.text = @"";    
}
@end
