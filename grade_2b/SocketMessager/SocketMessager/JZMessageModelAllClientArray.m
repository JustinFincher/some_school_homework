//
//  JZMessageModelAllClientArray.m
//  SocketMessager
//
//  Created by Fincher Justin on 16/6/13.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZMessageModelAllClientArray.h"

@implementation JZMessageModelAllClientArray

- (id)init
{
    self = [super init];
    self.msgType = [NSNumber numberWithInt:TAG_DEVICEARRAY];

    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.allClients forKey:@"allClients"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.allClients = [aDecoder decodeObjectForKey:@"allClients"];
    }
    return self;
}

@end
