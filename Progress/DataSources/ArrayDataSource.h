//
//  ArrayDataSource.h
//  CrimeMapping
//
//  Created by Aaron Connolly on 10/16/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item, id indexPath);

@interface ArrayDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)anItems cellIdentifier:(NSString*)aCellIdentifer configureCellBlock:(TableViewCellConfigureBlock)aConfigureableCellBlock;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;

- (void)refreshItems:(NSArray *)anItems;

@end
