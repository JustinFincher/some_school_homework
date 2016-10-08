//
//  JZClientChatGroupSelectionTableViewCell.m
//  SocketMessager
//
//  Created by Fincher Justin on 16/6/13.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZClientChatGroupSelectionTableViewCell.h"

@implementation JZClientChatGroupSelectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if(!selected) {
        self.contentView.backgroundColor = [UIColor clearColor];
    } else {
        self.contentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    }
}

- (void)setLabelText:(NSString *)textToSet
{
    self.addressLabel.text = textToSet;
}

@end
