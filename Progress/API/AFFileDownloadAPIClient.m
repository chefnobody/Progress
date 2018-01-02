//
//  AFFileDownloadAPIClient.m
//  Progress
//
//  Created by Aaron Connolly on 4/12/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import "AFFileDownloadAPIClient.h"
#import "AFDownloadRequestOperation.h"

static NSString * const kAFFileDownloadAPIBaseURLString = @"";

@interface AFFileDownloadAPIClient()

@property (nonatomic, readonly) AFFileDownloadAPIClient *download;
@property (nonatomic, strong) NSMutableDictionary *downloadOperations;

@end

@implementation AFFileDownloadAPIClient

- (id)init {

    self = [super initWithBaseURL:[NSURL URLWithString:kAFFileDownloadAPIBaseURLString]];

    if (!self) {
        return nil;
    }

    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];

    // Limit max concurrent operations to 2
    self.operationQueue.maxConcurrentOperationCount = 2;

    // Storage for retreiving download operations
    self.downloadOperations = [NSMutableDictionary dictionary];

    return self;
}

- (void)downloadFileWithIndex:(int)index fileName:(NSString *)fileName url:(NSString*)url {

    // Create URL parameters
    //NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index], @"index", nil];

    // Create request
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                      path:url
                                                parameters:nil];

    // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];

    // Create destination path
    NSString *fileInDocumentsPath = [documentsPath stringByAppendingPathComponent:fileName];

    // Using standard request operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    operation.inputStream = [NSInputStream inputStreamWithURL:request.URL];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:fileInDocumentsPath append:YES];

     // BLOCK level variables
     __weak AFHTTPRequestOperation *weakOperation = operation;   // For use in download progress BLOCK
     __weak NSDate *startTime = [NSDate date];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"Done!");

        if ([_downloadFileRequestDelegate respondsToSelector:@selector(downloadFileRequestFinishedWithData:fileName:atIndex:startTime:)]) {
            [_downloadFileRequestDelegate downloadFileRequestFinishedWithData:responseObject
                                                                     fileName:fileName
                                                                      atIndex:index
                                                                    startTime:startTime];
        }
    }

    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([_downloadFileRequestDelegate respondsToSelector:@selector(downloadFileRequestFailedWithError:atIndex:startTime:)]) {
                [_downloadFileRequestDelegate downloadFileRequestFailedWithError:error atIndex:index startTime:startTime];
        }
    }];

    // Check "Content-Disposition" for content-length
    //"Content-Disposition" = "attachment; test.pdf; 67555733";

    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse*)weakOperation.response;
        NSString *contentDisposition = [[response allHeaderFields] objectForKey:@"Content-Disposition"];
        NSArray *dispositionMetadata = [contentDisposition componentsSeparatedByString:@";"];

        // 4th item is length
        if (dispositionMetadata != nil && dispositionMetadata.count == 4) {
            totalBytesExpectedToRead = [[dispositionMetadata objectAtIndex:3] doubleValue];
        }

        NSLog(@"total bytes read: %lld", totalBytesRead);

        // Notify the delegate of the progress
        if ([_requestProgressDelegate respondsToSelector:@selector(requestDidReceiveBytesForIndex:bytes:totalBytes:)]) {
            [_requestProgressDelegate requestDidReceiveBytesForIndex:index bytes:bytesRead totalBytes:totalBytesExpectedToRead];
        }
    }];

    // Check to see if operation is already in our dictionary
    if ([[self.downloadOperations allKeys] containsObject:[NSNumber numberWithInt:index]] == YES) {
        [self.downloadOperations removeObjectForKey:[NSNumber numberWithInt:index]];
    }

    NSLog(@"start new download operation: %i", index);

    // Add operation to storage dictionary
    [self.downloadOperations setObject:operation forKey:[NSNumber numberWithInt:index]];

    // Queue up the download operation. No need to start the operation explicitly
    [self enqueueHTTPRequestOperation:operation];
}

- (void)cancelDownloadForIndex:(int)index {

    AFHTTPRequestOperation *operation = [self.downloadOperations objectForKey:[NSNumber numberWithInt:index]];

    NSLog(@"cancel operation: %i", index);
    NSLog(@"\r\n");

    if (operation != nil) {

        // Remove completion/download blocks to avoid errors if using AFDownloadRequestOperation
        //[operation setCompletionBlockWithSuccess:nil failure:nil];

        [operation cancel];

        NSLog(@"operation output stream: %@", operation.outputStream);

        // Remove object from dictionary
        [self.downloadOperations removeObjectForKey:[NSNumber numberWithInt:index]];
    }
}

- (void)pauseDownloadForIndex:(int)index {

    AFHTTPRequestOperation *operation = [self.downloadOperations objectForKey:[NSNumber numberWithInt:index]];

    NSLog(@"pause: %i", index);
    NSLog(@"\r\n");

    if (operation != nil) {
        [operation pause];
    }
}

- (void)resumeDownloadForIndex:(int)index {

    AFHTTPRequestOperation *operation = [self.downloadOperations objectForKey:[NSNumber numberWithInt:index]];

    NSLog(@"resume: %i", index);
    NSLog(@"\r\n");

    if (operation != nil) {
        [operation resume];
    }
}

@end
