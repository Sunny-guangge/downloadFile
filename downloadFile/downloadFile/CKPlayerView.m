//
//  CKPlayerView.m
//  downloadFile
//
//  Created by user on 16/2/1.
//  Copyright © 2016年 user. All rights reserved.
//

#import "CKPlayerView.h"

@interface CKPlayerView ()

@property (nonatomic,strong) UILabel *label;

@end

@implementation CKPlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.label];
        self.backgroundColor = [UIColor greenColor];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label.frame = CGRectMake(0, 0, 80, 20);
}

- (UILabel *)label
{
    if (_label == nil) {
        
        _label = [[UILabel alloc] init];
        _label.text = @"success";
        _label.textColor = [UIColor redColor];
        
    }
    return _label;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (void)dealloc
{
    self.player = nil;
}

@end
