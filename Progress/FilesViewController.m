//
//  FilesViewController.m
//  Progress
//
//  Created by Aaron Connolly on 11/6/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import "FilesViewController.h"
#import "FileTableViewCell.h"
#import "ArrayDataSource.h"

@interface FilesViewController ()

@property (nonatomic, strong) ArrayDataSource *filesDataSource;
@property (strong) NSMutableArray *files;
@property (strong) NSString *documentsPath;
@property (strong) UIBarButtonItem *editButton;

@end

@implementation FilesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                target:self
                                                                action:@selector(editButtonTapped:)];
    
    self.navigationItem.rightBarButtonItem = _editButton;
    
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentsPath = [directories objectAtIndex:0];
    
    [self setUpTableView];
    [self refreshFilesList];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self refreshFilesList];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)editButtonTapped:(id)sender {
    
    if ([self.tableView isEditing] == NO) {
        
        [self.tableView setEditing:YES animated:YES];
        [_editButton setTitle:@"Edit"];
    
    } else {
        
        [self.tableView setEditing:NO animated:YES];
        [_editButton setTitle:@"Done"];
    }
}

- (void)refreshFilesList {
    
    NSError *error = nil;
    
    // List of documents in this path
    _files = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:_documentsPath error:&error]];
    
    // Refresh data source
    [self.filesDataSource refreshItems:_files];
}

- (void)setUpTableView {
    
    // Configure cell block into local variable
    void (^configureCellBlock)(FileTableViewCell* cell, NSString* file, NSIndexPath *indexPath) = ^(FileTableViewCell* cell, NSString* file, NSIndexPath *indexPath)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Avenir Black" size:18.0];
        cell.textLabel.text = [_files objectAtIndex:indexPath.row];
    };
    
    self.filesDataSource = [[ArrayDataSource alloc] initWithItems:_files
                                                       cellIdentifier:@"Cell"
                                                   configureCellBlock:configureCellBlock];
    
    self.tableView.dataSource = self.filesDataSource;
    UINib *nib = [UINib nibWithNibName:@"FileTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSourceDelegate methods

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    // Visual formatting
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Black" size:18.0];
    
    cell.textLabel.text = [_files objectAtIndex:indexPath.row];
    
    NSError *error = nil;
    NSString *filePath = [_documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", [_files objectAtIndex:indexPath.row]]];
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir" size:14.0];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [attributes objectForKey:NSFileSize]];
    
    return cell;
}
*/

#pragma mark - UITableViewDelegate methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


@end
