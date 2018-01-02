//
//  DownloadManager.h
//  Progress
//
//  Created by Aaron Connolly on 4/12/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFFileDownloadAPIClient.h"
#import "Download.h"

@protocol DownloadManagerRequestDelegate <NSObject>

- (void)downloadFinishedAtIndex:(int)index;
- (void)downloadFailedAtIndex:(int)index;
- (void)downloadDidReceiveBytesForIndex:(int)downloadIndex bytes:(long long)bytes totalBytes:(double)totalBytes;

@end

@interface DownloadManager : NSObject <RequestDelegate, DownloadFileRequestDelegate, RequestProgressDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic) NSArray *downloads;

- (id)init;
- (id)initWithDelegate:(id<DownloadManagerRequestDelegate>)delegate;

- (void)setUpDownloads;

- (void)beginDownloadAtIndex:(int)index;
- (void)cancelDownloadAtIndex:(int)index;
- (void)pauseDownloadAtIndex:(int)index;
- (void)resumeDownloadAtIndex:(int)index;

- (void)openFileAtIndex:(int)index;

@end
