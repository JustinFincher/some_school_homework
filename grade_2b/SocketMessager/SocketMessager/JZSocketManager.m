//
//  JZSocketManager.m
//  SocketMessager
//
//  Created by Fincher Justin on 16/6/13.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZSocketManager.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "JZMessageModel.h"
#import "JZMessageModelTextMsg.h"
//client side


@interface JZSocketManager ()<GCDAsyncSocketDelegate>

@end

@implementation JZSocketManager
@synthesize socket;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static JZSocketManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init])
    {
        socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)sentMessage:(NSString *)text
            toGroup:(NSArray *)array
{
    JZMessageModelTextMsg *msg =[[JZMessageModelTextMsg alloc] init];
    msg.msg = text;
    msg.receiverArray = array;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:msg];
    [socket writeData:data withTimeout:-1 tag:0];
    
}
- (void)disconnectFromServer
{
    [socket disconnect];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{

}

- (BOOL)connectSocketIP:(NSString *)address
                   port:(NSString *)port
{
    NSError *err = nil;
    if (![socket connectToHost:address onPort:[port intValue] error:&err])
    {
        // If there was an error, it's likely something like "already connected" or "no delegate set"
        NSLog(@"I goofed: %@", err);
        return NO;
    }else
    {
        [socket readDataWithTimeout:-1 tag:0];
        return YES;
    }
}
- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Cool, I'm connected! That was easy.");
    [socket readDataWithTimeout:-1 tag:0];
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketDidDisconnect");
}
- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    id<JZSocketManagerDelegate> strongDelegate = self.delegate;
    [strongDelegate didReadData:data withTag:tag];
    
    [socket readDataWithTimeout:-1 tag:0];
}

// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
@end
