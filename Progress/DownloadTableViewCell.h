//
//  DownloadTableViewCell.h
//  Progress
//
//  Created by Aaron Connolly on 4/16/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DownloadActionDelegate <NSObject>

- (void)beginDownloadAtIndex:(int)index;
- (void)cancelDownloadAtIndex:(int)index;
- (void)pauseDownloadAtIndex:(int)index;
- (void)resumeDownloadAtIndex:(int)index;
- (void)openFileAtIndex:(int)index;

@end

@interface DownloadTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<DownloadActionDelegate> delegate;

@property (nonatomic, assign) int downloadIndex;

@property (weak, nonatomic) IBOutlet UIView *readyView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@property (weak, nonatomic) IBOutlet UIView *downloadingView;
@property (weak, nonatomic) IBOutlet UILabel *downloadProgressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressView;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@property (weak, nonatomic) IBOutlet UIView *completedView;
@property (weak, nonatomic) IBOutlet UILabel *completedFileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedStatusLabel;

@property (nonatomic, assign) BOOL downloading;
@property (nonatomic, assign) BOOL completed;

- (void)initState;

- (IBAction)downloadButtonTapped:(id)sender;
- (IBAction)pauseButtonTapped:(id)sender;
- (IBAction)cancelDowloadButtonTapped:(id)sender;
- (IBAction)openFileButtonTapped:(id)sender;

@end
