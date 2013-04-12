//
//  ParseLyric.m
//  ParseLyrics
//
//  Created by admin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParseLyric.h"

@implementation LysLine
@synthesize text;
@synthesize nextText;
@synthesize words;
@synthesize direction;
@synthesize currentTime;
@synthesize timeLenth;


-(void)dealloc
{
    self.words = nil;
    [text release];
    [super dealloc];
}

+(id)lysLine
{
    return [[[LysLine alloc]init]autorelease];
}

-(NSString*)text
{
    if(!text)
    {
        NSMutableString *t = [[NSMutableString alloc]init];
        for(LysWord *w in words)
        {
            [t appendString:w.word];
        }
        text = t;
    }
    return text;
}
@end


@implementation LysWord
@synthesize word;
@synthesize currentTime;
@synthesize timeLenth;
@synthesize voiceHight;
@synthesize index;
@synthesize matching;
@synthesize isPositive;

-(void)dealloc
{
    self.word = nil;
    [super dealloc];
}

+(id)lysWord
{
    return [[[LysWord alloc]init]autorelease];
}
@end




@implementation ParseLyric

+(float)parseTime:(NSString*)strTime
{
    NSArray *t = [strTime componentsSeparatedByString:@":"];
    if([t count] >= 2)
    {
        return [[t objectAtIndex:0]floatValue] *60.0 + [[t objectAtIndex:1] floatValue];
    }
    return 0;
}



+(NSArray*)parseLyric:(NSString*)lyric
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *lines = [lyric componentsSeparatedByString:@"\n"];
    

    for(int i = 0; i < lines.count-1; ++i)
    {
        NSString *line = [lines objectAtIndex:i];
        int lac = [line rangeOfString:@"]"].location;
        if(lac <=0 || lac > 1000)
            continue;
        
        NSString *time = [line substringWithRange:NSMakeRange(1, lac-1)];
        
        NSString *num = @"L";
        if(i%2)
        {
            num = @"R";
        }
        
        if([time hasPrefix:@"0"])
        {
            float nTime = [self parseTime:time];
            NSString *words = [line substringFromIndex:lac+1];
            
            NSString *nextLine = [lines objectAtIndex:i+1];
            int nLac = [nextLine rangeOfString:@"]"].location;
            if(nLac <=0 || nLac > 1000)
                continue;
            NSString *nT = [nextLine substringWithRange:NSMakeRange(1, nLac-1)];
            NSString *nWords = [nextLine substringFromIndex:nLac+1];
            
            NSNumber *lTime = [NSNumber numberWithFloat:[self parseTime:nT]-nTime];
            NSDictionary *lDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:nTime],@"timing",lTime,@"time",words,@"word",nWords,@"nextWord",num,@"num", nil];
            [array addObject:lDic];
        }
    }    
    return array;
}


+(NSArray*)parseLine:(NSString*)line
{
    NSArray *words = [line componentsSeparatedByString:@")"];
    NSMutableArray *ws = [NSMutableArray array];
    for(int i = 0; i<words.count; ++i)
    {
        NSString *word = [words objectAtIndex:i];
        int lac = [word rangeOfString:@"("].location;
        
        if(lac <=0 || lac > 1000)
            continue;
        
        NSString *w = [word substringToIndex:lac];
        
        NSString *tim = [word substringFromIndex:lac+1];
        NSArray *tms = [tim componentsSeparatedByString:@","];
        
        int n1 = 0;
        int n2 = 0;
//        float n3 = 0;
        if(tms.count >= 2)
        {
            n1 = [[tms objectAtIndex:0]intValue];
            n2 = [[tms objectAtIndex:1]intValue]; 
//            n3 = [[tms objectAtIndex:2]floatValue]; 
            
        }
        LysWord *lysW = [LysWord lysWord];
        lysW.word = w;
        lysW.currentTime = n1;
        lysW.timeLenth = n2;
//        lysW.voiceHight = n3;
        [ws addObject:lysW];
    }
    return ws;
}

+(NSArray*)parseQrc:(NSString*)qrc
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *lines = [qrc componentsSeparatedByString:@"\n"];
    
    int numLine = 0;
    for(int i = 0; i < lines.count; ++i)
    {
        NSString *line = [lines objectAtIndex:i];
        int lac = [line rangeOfString:@"]"].location;
        if(lac <=0 || lac > 1000)
            continue;
        
        NSString *time = [line substringWithRange:NSMakeRange(1, lac-1)];
        
        
        
        NSArray *t = [time componentsSeparatedByString:@","];
        int n1 = 0;
        int n2 = 0;
        
        if([t count] >= 2)
        {
            n1 = [[t objectAtIndex:0] intValue];
            n2 = [[t objectAtIndex:1] intValue];
        }
        
        if(!n2)
            continue;
        
        NSString *words = [line substringFromIndex:lac+1];
        if(!words)
            continue;
        
        
        ++numLine;
        short num = 1; //是左边1  还是右边0 显示        
        if(numLine%2)
        {
            num = 0;
        }
        
        
        NSArray *arrayLine = [self parseLine:words];
        
        LysLine *lln = [LysLine lysLine];
        lln.words = arrayLine;
        lln.direction = num;
        lln.currentTime = n1;
        lln.timeLenth = n2;
        
        [array addObject:lln];
    }
    
    return array;
}


+(NSArray*)parsePitchInfo:(NSString*)qrc
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *lines = [qrc componentsSeparatedByString:@"\n"];
    
    for(int i = 0; i < lines.count; ++i)
    {
        NSString *line = [lines objectAtIndex:i];
        int lac = [line rangeOfString:@"]"].location;
        if(lac <=0 || lac > 1000)
            continue;
        
        NSString *time = [line substringWithRange:NSMakeRange(1, lac-1)];
        
        
        
        NSArray *t = [time componentsSeparatedByString:@","];
        int n1 = 0;
        int n2 = 0;
        
        if([t count] >= 2)
        {
            n1 = [[t objectAtIndex:0] intValue];
            n2 = [[t objectAtIndex:1] intValue];
        }
        
        if(!n2)
            continue;
        
        NSString *words = [line substringFromIndex:lac+1];
        if(!words)
            continue;
          
        
        NSArray *arrayLine = [words componentsSeparatedByString:@"'"];
        NSMutableArray *ls = [NSMutableArray array];
        for(NSString *w in arrayLine)
        {
            NSArray *tm = [w componentsSeparatedByString:@","];
            
            if([tm count] >= 2)
            {
                LysWord *lw = [LysWord lysWord];
                lw.voiceHight = [[tm objectAtIndex:0]floatValue];
                lw.timeLenth = [[tm objectAtIndex:1]floatValue];
                [ls addObject:lw];
            }
        }
        
        
        LysLine *lln = [LysLine lysLine];       
        
        lln.words = ls;
        lln.currentTime = n1;
        lln.timeLenth = n2;
        
        [array addObject:lln];
    }
    
    return array;
}
@end
