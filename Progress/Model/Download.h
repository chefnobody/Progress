//
//  Download.h
//  Progress
//
//  Created by Aaron Connolly on 4/12/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Download : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString * summary;

@property (nonatomic, strong) NSURL *downloadURL;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, assign, getter=isCompressedDownload) BOOL compressedDownload;
@property (nonatomic, assign, getter=isDownloading) BOOL downloading;
@property (nonatomic, assign, getter=isCompleted) BOOL completed;

@property (nonatomic, assign) CGFloat bytesDownloaded;
@property (nonatomic, assign) CGFloat totalBytesToDownload;
@property (nonatomic, assign) CGFloat percentageDownloaded;

@end
