//
//  JZMessageModelTextMsg.m
//  SocketMessager
//
//  Created by Fincher Justin on 16/6/13.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZMessageModelTextMsg.h"

@implementation JZMessageModelTextMsg

- (id)init
{
    self = [super init];
    self.msgType = [NSNumber numberWithInt:TAG_MSG];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.receiverArray forKey:@"receiverArray"];
    [aCoder encodeObject:self.msg forKey:@"msg"];
    [aCoder encodeObject:self.msgType forKey:@"msgType"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.receiverArray = [aDecoder decodeObjectForKey:@"receiverArray"];
        self.msg = [aDecoder decodeObjectForKey:@"msg"];
        self.msgType = [aDecoder decodeObjectForKey:@"msgType"];
    }
    return self;
}

@end
