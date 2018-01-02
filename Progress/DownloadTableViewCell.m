//
//  DownloadTableViewCell.m
//  Progress
//
//  Created by Aaron Connolly on 4/16/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import "DownloadTableViewCell.h"

@interface DownloadTableViewCell()

@property (nonatomic, assign) BOOL isPaused;

@end

@implementation DownloadTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // Initialization code
        [self initState];
    }
    
    return self;
}

- (void)initState {
    
    _isPaused = NO;
    
    self.readyView.hidden = NO;
    self.downloadingView.hidden = YES;
    self.completedView.hidden = YES;
}

#pragma mark - Custom setters

- (void)setDownloading:(BOOL)downloading_ {
    
    if (_downloading == downloading_) return;
    
    _downloading = downloading_;
    
    if (_downloading) {
        
        self.readyView.hidden = YES;
        self.downloadingView.hidden = NO;
        self.completedView.hidden = YES;

        self.downloadProgressView.progress = 0.0;
    }
    else
    {
        self.readyView.hidden = NO;
        self.downloadingView.hidden = YES;
        self.completedView.hidden = YES;
        
        self.downloadProgressView.progress = 0.0;
    }
}

- (void)setCompleted:(BOOL)completed_ {
    
    if (_completed == completed_) return;
    
    _completed = completed_;
    
    if (_completed) {
        
        self.readyView.hidden = YES;
        self.downloadingView.hidden = YES;
        self.completedView.hidden = NO;
    }
}

#pragma mark - IBActions

- (IBAction)downloadButtonTapped:(id)sender {
    
    [self setDownloading:YES];
    
    if ([self.delegate respondsToSelector:@selector(beginDownloadAtIndex:)])
        [self.delegate beginDownloadAtIndex:self.downloadIndex];
}

- (IBAction)cancelDowloadButtonTapped:(id)sender {
    
    [self setDownloading:NO];
    
    if ([self.delegate respondsToSelector:@selector(cancelDownloadAtIndex:)])
        [self.delegate cancelDownloadAtIndex:self.downloadIndex];
}

- (IBAction)openFileButtonTapped:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(openFileAtIndex:)])
        [self.delegate openFileAtIndex:self.downloadIndex];
}

- (IBAction)pauseButtonTapped:(id)sender {

    // Flip the pause switch
    _isPaused = !_isPaused;
    
    if (_isPaused == YES) {
    
        [self.pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        
        if ([self.delegate respondsToSelector:@selector(pauseDownloadAtIndex:)])
            [self.delegate pauseDownloadAtIndex:self.downloadIndex];
    }
    else
    {
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        if ([self.delegate respondsToSelector:@selector(resumeDownloadAtIndex:)])
            [self.delegate resumeDownloadAtIndex:self.downloadIndex];
    }
}



@end
