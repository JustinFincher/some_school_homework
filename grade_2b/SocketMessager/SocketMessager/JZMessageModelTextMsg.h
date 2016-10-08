//
//  JZMessageModelTextMsg.h
//  SocketMessager
//
//  Created by Fincher Justin on 16/6/13.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZMessageModel.h"

@interface JZMessageModelTextMsg : JZMessageModel

@property (nonatomic,strong) NSArray * receiverArray;
@property (nonatomic,strong) NSString * msg;


@end
