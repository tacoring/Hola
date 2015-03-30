//
//  TableCell.m
//  Hola
//
//  Created by Chang-Che Lu on 3/14/15.
//  Copyright (c) 2015 Chang-Che Lu. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell

@synthesize nameLabel;
@synthesize addressLabel;
@synthesize thumbnailImageView;
@synthesize distanceLabel;
@synthesize ratingCountLabel;
@synthesize ratingImage;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
