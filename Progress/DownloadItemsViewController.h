//
//  DownloadItemsViewController.h
//  Progress
//
//  Created by Aaron Connolly on 4/12/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadTableViewCell.h"
#import "DownloadManager.h"

@interface DownloadItemsViewController : UITableViewController <DownloadActionDelegate, DownloadManagerRequestDelegate>

@end
