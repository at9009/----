//
//  ParseLyric.h
//  ParseLyrics
//
//  Created by admin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LysLine : NSObject
{
    NSString        *text;
    NSString        *nextText;
    NSArray         *words;
    short           direction; //方向标记 ：左边还是右边显示
    uint            currentTime; //当前时间
    uint            timeLenth; //时长
}
@property (nonatomic,retain)NSString        *text;
@property (nonatomic,retain)NSString        *nextText;
@property (nonatomic,retain)NSArray         *words;
@property (nonatomic)       short           direction; //方向标记 ：左边还是右边显示
@property (nonatomic)       uint            currentTime; //当前时间
@property (nonatomic)       uint            timeLenth; //时长
@end


@interface LysWord : NSObject
{
    NSString        *word;
    uint            currentTime; //当前时间
    uint            timeLenth; //时长
     uint            index;
    float           matching;
}
@property (nonatomic,retain)NSString        *word;
@property (nonatomic)       uint            currentTime; //当前时间
@property (nonatomic)       uint            timeLenth; //时长  
@property (nonatomic)       float           voiceHight;//音高 百分比
@property (nonatomic)       uint            index;      //
@property (assign)       float           matching;  //匹配度
@property (nonatomic)       BOOL            isPositive; //唱的音高是否大于原音高

@end


@interface ParseLyric : NSObject
{
    
}
+(NSArray*)parseLyric:(NSString*)lyric;
+(NSArray*)parseQrc:(NSString*)qrc;
+(NSArray*)parsePitchInfo:(NSString*)qrc;
@end
