//
//  YOSoundPlayTool.m
//  YOTool
//
//  Created by yollet on 2024/5/13.
//  Copyright © 2024 jhj. All rights reserved.
//

#import "YOSoundPlayTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation YOSoundPlayTool

+ (void)playSoundWithPath:(NSString *)path
{
    SystemSoundID soundId = 0;
    
    
//        NSLog(@"audioPath : %@", audioPath);
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(url), &soundId);
    AudioServicesPlaySystemSound(soundId);
}

@end
