//
//  YOSpeechTool.m
//  YOTool
//
//  Created by yollet on 2024/5/10.
//  Copyright © 2024 jhj. All rights reserved.
//

#import "YOSpeechTool.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>

@interface YOSpeechTool () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder; //  音频录音机
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *savePath;

@end

@implementation YOSpeechTool

#pragma mark -- 设置音频会话 --
- (void)setAudioSession
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    // 设置播放和录音状态（如录音完成后播放等）
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    
}

#pragma mark -- 开始录音 --
- (void)start
{
    if ([self.audioRecorder isRecording]) {
        return;
    }
    [self setAudioSession];
    NSURL *url = [self getSavePath];
    NSDictionary *setting = [self getAudioSetting];
    NSError *error = nil;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = NO; // 如果要监控声波则设置为YES
    if (error) {
        NSLog(@"创建录音机对象发生错误，错误信息：%@", error.localizedDescription);
    }
    else if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];
        _speeching = YES;
    }
}

#pragma mark -- 停止录音 --
- (void)stop
{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
}

#pragma mark -- 录音代理方法 --
// 录音完成后调用
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (flag) {
        NSLog(@"录音完成,开始识别");
    }
    else {
        NSLog(@"录音失败");
    }
    
    
    [self speechRecognitionWithUrl:[NSURL fileURLWithPath:self.urlStr]];
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error]; // 将播放设置调为正常播放 不然会在录制模式下 音量过小
}

#pragma mark -- 语音识别 --
- (void)speechRecognitionWithUrl:(NSURL *)url
{
    NSLog(@"识别地址 : %@", url);
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        if (status == 3) {
            NSLog(@"授权成功");
        }
        else {
            NSLog(@"授权失败");
            self->_speeching = NO;
        }
    }];
    
    NSLocale *loc = [NSLocale localeWithLocaleIdentifier:@"zh-CN"]; // zh-CN ja-JP
    // 创建语音识别操作类对象
    SFSpeechRecognizer *rec = [[SFSpeechRecognizer alloc] initWithLocale:loc];
//    rec.defaultTaskHint = SFSpeechRecognitionTaskHintConfirmation;
    // 通过一个音频路劲常见音频识别请求
//    SFSpeechRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"7011" withExtension:@"m4a"]];
    SFSpeechRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
    // 进行请求
    [rec recognitionTaskWithRequest:request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (result.final) {
            NSLog(@"%@", result.bestTranscription.formattedString);
            if (self.resultBlock) {
                self.resultBlock(result.bestTranscription.formattedString ? result.bestTranscription.formattedString : @"无法识别");
            }
            [self.audioRecorder deleteRecording];
            self.audioRecorder = nil;
            self->_speeching = NO;
        }
        if (error) {
            self->_speeching = NO;
        }
    }];
}



#pragma mark -- 路径读取 --
- (NSURL *)getSavePath
{
    NSString *urlStr = self.savePath;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHss"];
    urlStr = [urlStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_voice.caf", [format stringFromDate:[NSDate date]]]];
    self.urlStr = urlStr;
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    NSLog(@"%@", urlStr);
    return url;
}

#pragma mark -- 取得录音文件设置 --
- (NSDictionary *)getAudioSetting
{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    
    // 设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    // 设置录音采样率
    [dicM setObject:@(44100.0) forKey:AVSampleRateKey];
    // 设置通道 1为单声道
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
    // 每个采样点数 分为8 16 24 32
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    // 是否使用浮点采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //录音质量
    [dicM setObject:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    return dicM;
}

- (NSString *)savePath
{
    if (!_savePath) {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *path = [libraryPath stringByAppendingPathComponent:@"YOVoiceTmp"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createDirectoryAtURL:[NSURL fileURLWithPath:path] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        _savePath = path;
    }
    
    
    return _savePath;
}

@end
