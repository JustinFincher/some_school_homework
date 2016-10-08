//
//  JZSocketManager.h
//  SocketMessager
//
//  Created by Fincher Justin on 16/6/13.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#define TAG_DEVICEARRAY 0
#define TAG_MSG 1

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
@protocol JZSocketManagerDelegate;

@interface JZSocketManager : NSObject

+ (id)sharedManager;

@property (nonatomic, weak) id<JZSocketManagerDelegate> delegate;
@property (nonatomic, strong) GCDAsyncSocket * socket;

- (BOOL)connectSocketIP:(NSString *)address
                   port:(NSString *)port;
- (void)disconnectFromServer;
- (void)sentMessage:(NSString *)text
            toGroup:(NSArray *)array;

- (NSString *)getIPAddress;

@end

@protocol JZSocketManagerDelegate <NSObject>
@required
- (void)didReadData:(NSData *)data withTag:(long)tag;
@optional

@end