//
//  DownloadItemsViewController.m
//  Progress
//
//  Created by Aaron Connolly on 4/12/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import "DownloadItemsViewController.h"
#import "Download.h"
#import "DownloadManager.h"
#import "DownloadTableViewCell.h"
#import "FilesViewController.h"

@interface DownloadItemsViewController ()

@property (nonatomic) DownloadManager *downloadManager;

@end

@implementation DownloadItemsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Download Items", nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Files" style:UIBarButtonItemStylePlain target:self action:@selector(filesButtonTapped:)];
    
    _downloadManager = [[DownloadManager alloc] initWithDelegate:self];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.downloadManager setUpDownloads];
    [self.tableView reloadData];
}

- (void)filesButtonTapped:(id)sender {
    
    FilesViewController *filesViewController = [[FilesViewController alloc] initWithNibName:@"FilesViewController" bundle:nil];
    
    [self.navigationController pushViewController:filesViewController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return _downloadManager.downloads.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    DownloadTableViewCell *cell = (DownloadTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        UIViewController *temporaryController = [[UIViewController alloc] initWithNibName:@"DownloadTableViewCell" bundle:nil];
        
        // Grab a pointer to the custom cell.
        cell = (DownloadTableViewCell *)temporaryController.view;
        
        [cell initState];
        
        // Listens for method calls on cell
        cell.delegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Set index for this cell (it could be wrong if cell is re-used)
    cell.downloadIndex = (int)indexPath.row;
    
    Download *download = [_downloadManager.downloads objectAtIndex:indexPath.row];
    cell.downloading = download.downloading;
    cell.completed = download.completed;
    
    cell.nameLabel.text = download.name;
    cell.descriptionLabel.text = download.summary;
    cell.downloadProgressView.progress = download.percentageDownloaded;
    
    // Check for completed status
    cell.completed = download.completed;
    cell.completedFileNameLabel.text = download.fileName;
    
    return cell;
}


#pragma mark - DownloadActionDelegate methods

- (void)beginDownloadAtIndex:(int)index
{        
    [_downloadManager beginDownloadAtIndex:index];
}

- (void)cancelDownloadAtIndex:(int)index {
    
    [_downloadManager cancelDownloadAtIndex:index];
}

- (void)pauseDownloadAtIndex:(int)index {
 
    [_downloadManager pauseDownloadAtIndex:index];
}

- (void)resumeDownloadAtIndex:(int)index {
    
    [_downloadManager resumeDownloadAtIndex:index];
}

- (void)openFileAtIndex:(int)index {
    
    [_downloadManager openFileAtIndex:index];
}



#pragma mark - DownloadManagerRequestDelegate methods

- (void)downloadFinishedAtIndex:(int)index {
    
    Download *download = [_downloadManager.downloads objectAtIndex:index];
    download.downloading = NO;
    download.completed = YES;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)downloadFailedAtIndex:(int)index {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                    message:[NSString stringWithFormat:@"The download at %i, failed.", index]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}

- (void)downloadDidReceiveBytesForIndex:(int)downloadIndex bytes:(long long)bytes totalBytes:(double)totalBytes {
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:downloadIndex inSection:0];
    
    DownloadTableViewCell *cell = (DownloadTableViewCell*)[self.tableView cellForRowAtIndexPath:path];
    
    Download *download = [_downloadManager.downloads objectAtIndex:path.row];
    download.bytesDownloaded += bytes;
    download.percentageDownloaded = download.bytesDownloaded / totalBytes;
    
    // as a factor of 0.0 to 1.0 not 100.
    cell.downloadProgressView.progress = download.percentageDownloaded;
    
    float MB_CONVERSION_FACTOR = 0.000000953674;
    
    NSString *bytesText = [NSString stringWithFormat:@"Loading %.2f of %.2f MB", roundf((download.bytesDownloaded * MB_CONVERSION_FACTOR)*100)/100.0, roundf((totalBytes * MB_CONVERSION_FACTOR)*100)/100.0];
    
    cell.downloadProgressLabel.text = bytesText;
}

@end
