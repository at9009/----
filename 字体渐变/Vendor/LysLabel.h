//
//  LysLabel.h
//  ParseLyrics
//
//  Created by admin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LysLine;
@interface LysLabel : UILabel
{
    UILabel         *actionLabel;
    UIView          *shadeView;
    LysLine*        _line;
    CGRect          _shadeFrame;
    int             wordOffset;
}
-(void)showText:(NSString*)text animationTime:(float)time;
-(void)showLine:(LysLine*)line;
+(Float32)getSrcWordFrequency;
-(void)stop;
@end
