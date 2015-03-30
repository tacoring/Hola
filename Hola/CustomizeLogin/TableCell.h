//
//  TableCell.h
//  Hola
//
//  Created by Chang-Che Lu on 3/14/15.
//  Copyright (c) 2015 Chang-Che Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImage;
@property (strong, nonatomic) IBOutlet UILabel *ratingCountLabel;


@end
