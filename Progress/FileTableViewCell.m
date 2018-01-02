//
//  FileTableViewCell.m
//  Progress
//
//  Created by Aaron Connolly on 11/7/13.
//  Copyright (c) 2013 Top Turn Software. All rights reserved.
//

#import "FileTableViewCell.h"

@implementation FileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
