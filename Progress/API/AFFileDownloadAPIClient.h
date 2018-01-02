//
//  AFFileDownloadAPIClient.h
//  Progress
//
//  Created by Aaron Connolly on 4/12/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@protocol RequestDelegate <NSObject>

- (void)requestFinishedWithData:(NSData*)requestData atIndex:(int)index startTime:(NSDate*)startTime;
- (void)requestFailedWithError:(NSError*)requestFailed atIndex:(int)index startTime:(NSDate*)startTime; 

@end

@protocol DownloadFileRequestDelegate <NSObject>

- (void)downloadFileRequestFinishedWithData:(NSData*)requestData fileName:(NSString*)fileName atIndex:(int)index startTime:(NSDate*)startTime;
- (void)downloadFileRequestFailedWithError:(NSError*)requestFailed atIndex:(int)index startTime:(NSDate*)startTime;

@end

@protocol RequestProgressDelegate <NSObject>

- (void)requestDidReceiveBytesForIndex:(int)index bytes:(long long)bytes totalBytes:(long long)totalBytes;

@end

@interface AFFileDownloadAPIClient : AFHTTPClient

@property (nonatomic, assign) id<RequestDelegate> requestDelegate;
@property (nonatomic, assign) id<DownloadFileRequestDelegate> downloadFileRequestDelegate;
@property (nonatomic, assign) id<RequestProgressDelegate> requestProgressDelegate;

- (void)downloadFileWithIndex:(int)index fileName:(NSString*)fileName url:(NSString*)url;
- (void)cancelDownloadForIndex:(int)index;
- (void)pauseDownloadForIndex:(int)index;
- (void)resumeDownloadForIndex:(int)index;

@end
