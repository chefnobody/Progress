//
//  ArrayDataSource.m
//  CrimeMapping
//
//  Created by Aaron Connolly on 10/16/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import "ArrayDataSource.h"

@interface ArrayDataSource ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end

@implementation ArrayDataSource

- (id)init
{
    return nil;
}

- (id)initWithItems:(NSMutableArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureableCellBlock
{    
    self = [super init];
    
    if (self) {
        
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureableCellBlock copy];
    }
    
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.items objectAtIndex:indexPath.row];
}

- (void)refreshItems:(NSMutableArray *)anItems {
    
    self.items = anItems;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];

    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item, indexPath);
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Delete the data at the specified index path
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [directories objectAtIndex:0];
    
    NSError *error = nil;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsPath, [self itemAtIndexPath:indexPath]];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    
    [self.items removeObjectAtIndex:indexPath.row];
    
    // Delete the rows from the table
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


@end
