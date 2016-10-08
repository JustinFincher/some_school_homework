//
//  JZClientChatGroupSelectionTableViewCell.h
//  SocketMessager
//
//  Created by Fincher Justin on 16/6/13.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZClientChatGroupSelectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (void)setLabelText:(NSString *)textToSet;
@end
