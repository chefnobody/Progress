//
//  DownloadManager.m
//  Progress
//
//  Created by Aaron Connolly on 4/12/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import "DownloadManager.h"
#import "Download.h"

@interface DownloadManager()

@property (nonatomic, assign) id<DownloadManagerRequestDelegate> delegate;
@property (nonatomic, strong) AFFileDownloadAPIClient *fileDownloadAPIClient;

@end

@implementation DownloadManager

- (id)init {
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id<DownloadManagerRequestDelegate>)delegate_ {
    
    self = [super init];
    
    if (self) {
        
        _delegate = delegate_;
        
        // Create new download API client
        _fileDownloadAPIClient = [[AFFileDownloadAPIClient alloc] init];
        
        // Two different delegates? Is this necessary? Probably not ...
        _fileDownloadAPIClient.requestProgressDelegate = self;
        _fileDownloadAPIClient.downloadFileRequestDelegate = self;
        
        NSMutableArray *newDownloads = [[NSMutableArray alloc] init];
        
        NSString * host = @"http://www.aaronconnolly.com";
        
        // Set up downloads array
        Download *download = [[Download alloc] init];
        download = [[Download alloc] init];
        download.name = @"Coupon PDF";
        download.summary = @"A nicly designed coupon for a spa.";
        download.fileName = @"relache-coupon.pdf";
        download.downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/relache-coupon.pdf", host]];
        download.downloading = NO;
        download.percentageDownloaded = 0.0f;
        [newDownloads addObject:download];
        
        download = [[Download alloc] init];
        download.name = @"Small text file";
        download.summary = @"Random file ~400k in size.";
        download.fileName = @"small-file.txt";
        download.downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/small-file.txt", host]];
        download.downloading = NO;
        download.percentageDownloaded = 0.0f;
        [newDownloads addObject:download];
        
        download = [[Download alloc] init];
        download.name = @"Medium text file";
        download.summary = @"Random file ~100mb in size.";
        download.fileName = @"medium-file.txt";
        download.downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/medium-file.txt", host]];
        download.downloading = NO;
        download.percentageDownloaded = 0.0f;
        [newDownloads addObject:download];
        
        download = [[Download alloc] init];
        download.name = @"Silver Fish Image";
        download.summary = @"Website background.";
        download.fileName = @"fish-wall.png";
        download.downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/images/fish-wall.png", host]];
        download.downloading = NO;
        download.percentageDownloaded = 0.0f;
        [newDownloads addObject:download];

        _downloads = newDownloads;

        [self setUpDownloads];
    }
    
    return self;
}

- (void)setUpDownloads {
    
    int index = 0;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    // Set indexes on downloads
    for(Download *dm in _downloads) {
        
        dm.index = index;
        index++;
        
        NSString *fileInDocumentsPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", dm.fileName]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileInDocumentsPath] && ! dm.downloading)
        {
            dm.downloading = NO;
            dm.completed = YES;
        }
        else
        {
            dm.completed = NO;
        }
    }
}

#pragma mark - DownloadActionDelegate methods

- (void)beginDownloadAtIndex:(int)index {
    
    // Set downloading state in your model
    Download *download = [_downloads objectAtIndex:index];
    download.downloading = YES;
    
    // Start download
    [_fileDownloadAPIClient downloadFileWithIndex:(int)download.index
                                         fileName:download.fileName
                                              url:[download.downloadURL absoluteString]];
}

- (void)cancelDownloadAtIndex:(int)index {
    
    // Reset the data in your data model ...
    Download *download = [_downloads objectAtIndex:index];
    download.downloading = NO;
    download.bytesDownloaded = 0.0f;
    download.totalBytesToDownload = 0.0f;
    download.percentageDownloaded = 0.0f;
    
    [_fileDownloadAPIClient cancelDownloadForIndex:index];
}

- (void)pauseDownloadAtIndex:(int)index {
 
    [_fileDownloadAPIClient pauseDownloadForIndex:index];
}

- (void)resumeDownloadAtIndex:(int)index {
    
    [_fileDownloadAPIClient resumeDownloadForIndex:index];
}

- (void)openFileAtIndex:(int)index {
    
    Download *download = [_downloads objectAtIndex:index];
    
    // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    // Create destination path
    NSString *fileInDocumentsPath = [documentsPath stringByAppendingPathComponent:download.fileName];
    
    NSLog(@"Looking for %@", fileInDocumentsPath);
    
    NSURL *pathURL = [NSURL fileURLWithPath:fileInDocumentsPath];
    
    // Fire up the document interaction controller
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:pathURL];
    interactionController.delegate = self;
    [interactionController presentPreviewAnimated:YES];
    
}

#pragma mark UIDocumentInteractionControllerDelegate methods

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    
    // ?? Bad voo-doo, right here.
    return (UIViewController*)self.delegate;
}

#pragma mark RequestDelegate methods

- (void)requestFinishedWithData:(NSData *)requestData atIndex:(int)index startTime:(NSDate *)startTime {
    
    if ([_delegate respondsToSelector:@selector(downloadFinishedAtIndex:)])
        [_delegate downloadFinishedAtIndex:index];
}

- (void)requestFailedWithError:(NSError *)requestFailed atIndex:(int)index startTime:(NSDate *)startTime {
    
    NSLog(@"Error: %@", requestFailed.localizedDescription);
    
    if ([_delegate respondsToSelector:@selector(downloadFailedAtIndex:)])
        [_delegate downloadFailedAtIndex:index];    
}

#pragma mark DownloadFileRequestDelegate methods

- (void)downloadFileRequestFinishedWithData:(NSData *)requestData fileName:(NSString *)fileName atIndex:(int)index startTime:(NSDate *)startTime {
    
    // Update download with file name
    Download *download = [_downloads objectAtIndex:index];
    download.fileName = fileName;
    
    if ([_delegate respondsToSelector:@selector(downloadFinishedAtIndex:)])
        [_delegate downloadFinishedAtIndex:index];
}

- (void)downloadFileRequestFailedWithError:(NSError *)requestFailed atIndex:(int)index startTime:(NSDate *)startTime {
    
    if ([_delegate respondsToSelector:@selector(downloadFailedAtIndex:)])
        [_delegate downloadFailedAtIndex:index];
}

#pragma mark RequestProgressDelegate methods

- (void)requestDidReceiveBytesForIndex:(int)index bytes:(long long)bytes totalBytes:(long long)totalBytes {
    
    if ([_delegate respondsToSelector:@selector(downloadDidReceiveBytesForIndex:bytes:totalBytes:)])
        [_delegate downloadDidReceiveBytesForIndex:index bytes:bytes totalBytes:totalBytes];
}

@end
