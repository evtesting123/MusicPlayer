//
//  DetailViewController.m
//  MusicPlayer
//
//  Created by ev_mac5 on 20/02/16.
//  Copyright © 2016 eventurers. All rights reserved.
//

#import "DetailViewController.h"
#import <AVFoundation/AVFoundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface DetailViewController ()
{
    AVAudioPlayer *audioPlayer;
    BOOL isPlaying,isStopped;
    IBOutlet UIProgressView *progressView;
    IBOutlet UILabel *currentTimeLbl,*totalTimeLbl;
    NSTimer *playbackTimer;
    IBOutlet UIButton *playBtn,*stopBtn,*previousBtn,*nextBtn;
    int currentIndex;
}


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Play Audio";
    
    currentIndex = _index;
    
    if (_audioAry.count == 1)
    {
        previousBtn.hidden = YES;
        nextBtn.hidden = YES;
    }
    
    [self setAudio];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Defined Methods

- (void) checkPlaybackTime:(NSTimer *)theTimer
{
    NSTimeInterval theTimeInterval = audioPlayer.currentTime;
    NSCalendar *_sysCalendar = [NSCalendar currentCalendar];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *breakdownInfo = [_sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    NSString * totalTimeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)[breakdownInfo minute], (long)[breakdownInfo second]];
    
    currentTimeLbl.text = totalTimeStr;
    
    [progressView setProgress:(audioPlayer.currentTime/audioPlayer.duration)];
    
    date1 = nil;
    date2 = nil;
}


-(void)setTotalTime
{
    NSError *error;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:&error];

    //_fileURL
    
    NSTimeInterval theTimeInterval = audioPlayer.duration;
    NSCalendar *_sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1                   = [[NSDate alloc] init];
    NSDate *date2                   = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    unsigned int unitFlags          = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *breakdownInfo = [_sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    NSString * totalTimeStr         = [NSString stringWithFormat:@"%02ld:%02ld",(long)[breakdownInfo minute], (long)[breakdownInfo second]];
    
    totalTimeLbl.text          = totalTimeStr;
    
    if (error)
    {
        return;
    }
    else
    {
        if (playbackTimer == nil)
        {
            playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                             target:self
                                                           selector:@selector(checkPlaybackTime:)
                                                           userInfo:nil
                                                            repeats:YES];
        }
    }
}

-(void)setAudio
{
    previousBtn.enabled = (currentIndex != 0);
    nextBtn.enabled = (currentIndex != _audioAry.count - 1);
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_audioAry[currentIndex] error:nil];
    
    isPlaying = NO;
    [progressView setProgress:0.0];
    currentTimeLbl.text = @"00:00";
    totalTimeLbl.text = @"00:00";
    [self setTotalTime];
}

-(IBAction)playOrPause:(UIButton*)sender
{
    if (isPlaying )
    {
        [audioPlayer pause];
        [sender setTitle:@"Play" forState:UIControlStateNormal];
        
    } else
    {
        [audioPlayer play];
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
        if (isStopped)
        {
            [self setTotalTime];
            isStopped = YES;
        }
    }
    
    sender.backgroundColor = UIColorFromRGB(0X007AFF);
    stopBtn.backgroundColor = [UIColor whiteColor];
    sender.selected = true;
    stopBtn.selected = false;
    
    isPlaying = !isPlaying;
}

-(IBAction)stop:(UIButton*)sender
{
    [audioPlayer stop];
    [playbackTimer invalidate];
    playbackTimer = nil;
    isPlaying = NO;
    [progressView setProgress:0.0];
    currentTimeLbl.text = @"00:00";
    audioPlayer.currentTime = 0;
    [playBtn setTitle:@"Play" forState:UIControlStateNormal];
    isStopped = YES;
    sender.backgroundColor = UIColorFromRGB(0X007AFF);
    sender.selected = true;

    playBtn.backgroundColor = [UIColor whiteColor];
    playBtn.selected = false;
}

-(IBAction)previousAudio:(UIButton*)sender
{
    [self stop:nil];
    currentIndex = currentIndex - 1;

    [self setAudio];
}

-(IBAction)nextAudio:(UIButton*)sender
{

    [self stop:nil];
    currentIndex = currentIndex + 1;
    
    [self setAudio];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
