//
//  CKVideoViewController.m
//  downloadFile
//
//  Created by user on 16/2/1.
//  Copyright © 2016年 user. All rights reserved.
//

#import "CKVideoViewController.h"
#import "CKPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CKVideoViewController ()

@property (nonatomic,strong) CKPlayerView *playerView;

@property (nonatomic,strong) AVPlayer *player;

@end

@implementation CKVideoViewController

- (void)viewDidLoad
{
    [self player];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.playerView];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didClickDoneBarButtonItem)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)didClickDoneBarButtonItem
{
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://7xi66y.com1.z0.glb.clouddn.com/winnovator_home%2Fwinnovator_media.mp4"]];
    
    [player presentViewController:self animated:YES completion:nil];
}

- (CKPlayerView *)playerView
{
    if (_playerView == nil) {
        
        _playerView = [[CKPlayerView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)];
        [_playerView.layer setBackgroundColor:[UIColor blackColor].CGColor];
    }
    return _playerView;
}

- (AVPlayer *)player
{
    if (_player == nil) {
        
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"http://7xi66y.com1.z0.glb.clouddn.com/winnovator_home%2Fwinnovator_media.mp4"]];
        
        _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        
        [_playerView setPlayer:_player];
        
    }
    return _player;
}

@end
