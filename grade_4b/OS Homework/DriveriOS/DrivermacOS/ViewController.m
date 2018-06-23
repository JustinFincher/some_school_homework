//
//  ViewController.m
//  DrivermacOS
//
//  Created by Justin Fincher on 2018/6/23.
//  Copyright © 2018 Justin Fincher. All rights reserved.
//

#import "ViewController.h"
#import <Peertalk/Peertalk.h>
#import "PTCameraProtocol.h"

@interface ViewController ()<PTChannelDelegate>

@property (weak) IBOutlet NSImageView *cameraImageView;
@property (unsafe_unretained) IBOutlet NSTextView *logTextView;
@property (weak) IBOutlet NSScrollView *logScrollView;

@property (weak,nonatomic)  PTChannel *connectedChannel;
@property dispatch_queue_t notConnectedQueue;

@property (strong) NSNumber *connectingToDeviceID;
@property (strong) NSNumber *connectedDeviceID;
@property (strong) NSDictionary *connectedDeviceProperties;
@property (strong) NSDictionary *remoteDeviceInfo;
@property (nonatomic) BOOL notConnectedQueueSuspended;
@property (strong) NSMutableDictionary *pings;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"摄像头驱动服务端";
    
    self.notConnectedQueue = dispatch_queue_create("PTExample.notConnectedQueue", DISPATCH_QUEUE_SERIAL);
    
    [self startListeningForDevices];
    [self enqueueConnectToLocalIPv4Port];
    [self ping];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)setConnectedChannel:(PTChannel*)connectedChannel {
    _connectedChannel = connectedChannel;
    
    // Toggle the self.notConnectedQueue depending on if we are connected or not
    if (!self.connectedChannel && self.notConnectedQueueSuspended) {
        dispatch_resume(self.notConnectedQueue);
        self.notConnectedQueueSuspended = NO;
    } else if (self.connectedChannel && !self.notConnectedQueueSuspended) {
        dispatch_suspend(self.notConnectedQueue);
        self.notConnectedQueueSuspended = YES;
    }
    
    if (!self.connectedChannel && self.connectingToDeviceID) {
        [self enqueueConnectToUSBDevice];
    }
}


#pragma mark - Ping


- (void)pongWithTag:(uint32_t)tagno error:(NSError*)error {
    NSNumber *tag = [NSNumber numberWithUnsignedInt:tagno];
    NSMutableDictionary *pingInfo = [self.pings objectForKey:tag];
    if (pingInfo) {
        NSDate *now = [NSDate date];
        [pingInfo setObject:now forKey:@"date ended"];
        [self.pings removeObjectForKey:tag];
        NSLog(@"Ping total roundtrip time: %.3f ms", [now timeIntervalSinceDate:[pingInfo objectForKey:@"date created"]]*1000.0);
    }
}


- (void)ping {
    if (self.connectedChannel) {
        if (!self.pings) {
            self.pings = [NSMutableDictionary dictionary];
        }
        uint32_t tagno = [self.connectedChannel.protocol newTag];
        NSNumber *tag = [NSNumber numberWithUnsignedInt:tagno];
        NSMutableDictionary *pingInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"date created", nil];
        [self.pings setObject:pingInfo forKey:tag];
        [self.connectedChannel sendFrameOfType:PTExampleFrameTypePing tag:tagno withPayload:nil callback:^(NSError *error) {
            [self performSelector:@selector(ping) withObject:nil afterDelay:1.0];
            [pingInfo setObject:[NSDate date] forKey:@"date sent"];
            if (error) {
                [self.pings removeObjectForKey:tag];
            }
        }];
    } else {
        [self performSelector:@selector(ping) withObject:nil afterDelay:1.0];
    }
}


#pragma mark - PTChannelDelegate


- (BOOL)ioFrameChannel:(PTChannel*)channel shouldAcceptFrameOfType:(uint32_t)type tag:(uint32_t)tag payloadSize:(uint32_t)payloadSize {
    if (   type != PTExampleFrameTypeDeviceInfo
        && type != PTExampleFrameTypeTextMessage
        && type != PTExampleFrameTypePing
        && type != PTExampleFrameTypePong
        && type != PTFrameTypeEndOfStream) {
        NSLog(@"Unexpected frame of type %u", type);
        [channel close];
        return NO;
    } else {
        return YES;
    }
}

- (void)ioFrameChannel:(PTChannel*)channel didReceiveFrameOfType:(uint32_t)type tag:(uint32_t)tag payload:(PTData*)payload {
    NSLog(@"received %@, %u, %u, %@", channel, type, tag, payload);
    if (type == PTExampleFrameTypeDeviceInfo) {
        NSDictionary *deviceInfo = [NSDictionary dictionaryWithContentsOfDispatchData:payload.dispatchData];
        [self appendLog:[NSString stringWithFormat:@"Connected to %@", deviceInfo.description] ];
    } else if (type == PTExampleFrameTypeTextMessage) {
        PTExampleTextFrame *textFrame = (PTExampleTextFrame*)payload.data;
        textFrame->length = ntohl(textFrame->length);
        NSString *message = [[NSString alloc] initWithBytes:textFrame->utf8text length:textFrame->length encoding:NSUTF8StringEncoding];
         NSLog(@"%@",message);
        NSData *data = [[NSData alloc]initWithBase64EncodedString:message options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSImage *img =  [[NSImage alloc] initWithData:data];
        if (img)
        {
            self.cameraImageView.image = img;
        }
        else
        {
            NSLog(@"Image NULL");
        }
//        [self appendLog:[NSString stringWithFormat:@"[%@]: %@", channel.userInfo, message] ];
    } else if (type == PTExampleFrameTypePong) {
        [self pongWithTag:tag error:nil];
    }
}

- (void)ioFrameChannel:(PTChannel*)channel didEndWithError:(NSError*)error {
    if (self.connectedDeviceID && [self.connectedDeviceID isEqualToNumber:channel.userInfo]) {
        [self didDisconnectFromDevice:self.connectedDeviceID];
    }
    
    if (self.connectedChannel == channel) {
        [self appendLog:[NSString stringWithFormat:@"Disconnected from %@", channel.userInfo] ];
        self.connectedChannel = nil;
    }
}


#pragma mark - Wired device connections


- (void)startListeningForDevices {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserverForName:PTUSBDeviceDidAttachNotification object:PTUSBHub.sharedHub queue:nil usingBlock:^(NSNotification *note) {
        NSNumber *deviceID = [note.userInfo objectForKey:@"DeviceID"];
        NSLog(@"PTUSBDeviceDidAttachNotification: %@", note.userInfo);
        NSLog(@"PTUSBDeviceDidAttachNotification: %@", deviceID);
        
        dispatch_async(self.notConnectedQueue, ^{
            if (!self.connectingToDeviceID || ![deviceID isEqualToNumber:self.connectingToDeviceID]) {
                [self disconnectFromCurrentChannel];
                self.connectingToDeviceID = deviceID;
                self.connectedDeviceProperties = [note.userInfo objectForKey:@"Properties"];
                [self enqueueConnectToUSBDevice];
            }
        });
    }];
    
    [nc addObserverForName:PTUSBDeviceDidDetachNotification object:PTUSBHub.sharedHub queue:nil usingBlock:^(NSNotification *note) {
        NSNumber *deviceID = [note.userInfo objectForKey:@"DeviceID"];
        NSLog(@"PTUSBDeviceDidDetachNotification: %@", note.userInfo);
        NSLog(@"PTUSBDeviceDidDetachNotification: %@", deviceID);
        
        if ([self.connectingToDeviceID isEqualToNumber:deviceID]) {
            self.connectedDeviceProperties = nil;
            self.connectingToDeviceID = nil;
            if (self.connectedChannel) {
                [self.connectedChannel close];
            }
        }
    }];
}


- (void)didDisconnectFromDevice:(NSNumber*)deviceID {
    NSLog(@"Disconnected from device");
    if ([self.connectedDeviceID isEqualToNumber:deviceID]) {
        [self willChangeValueForKey:@"connectedDeviceID"];
        self.connectedDeviceID = nil;
        [self didChangeValueForKey:@"connectedDeviceID"];
    }
}


- (void)disconnectFromCurrentChannel {
    if (self.connectedDeviceID && self.connectedChannel) {
        [self.connectedChannel close];
        self.connectedChannel = nil;
    }
}


- (void)enqueueConnectToLocalIPv4Port {
    dispatch_async(self.notConnectedQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self connectToLocalIPv4Port];
        });
    });
}


- (void)connectToLocalIPv4Port {
    PTChannel *channel = [PTChannel channelWithDelegate:self];
    channel.userInfo = [NSString stringWithFormat:@"127.0.0.1:%d", PTExampleProtocolIPv4PortNumber];
    [channel connectToPort:PTExampleProtocolIPv4PortNumber IPv4Address:INADDR_LOOPBACK callback:^(NSError *error, PTAddress *address) {
        if (error) {
            if (error.domain == NSPOSIXErrorDomain && (error.code == ECONNREFUSED || error.code == ETIMEDOUT)) {
                // this is an expected state
            } else {
                NSLog(@"Failed to connect to 127.0.0.1:%d: %@", PTExampleProtocolIPv4PortNumber, error);
            }
        } else {
            [self disconnectFromCurrentChannel];
            self.connectedChannel = channel;
            channel.userInfo = address;
            NSLog(@"Connected to %@", address);
        }
        [self performSelector:@selector(enqueueConnectToLocalIPv4Port) withObject:nil afterDelay:PTAppReconnectDelay];
    }];
}


- (void)enqueueConnectToUSBDevice {
    dispatch_async(self.notConnectedQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self connectToUSBDevice];
        });
    });
}


- (void)connectToUSBDevice {
    PTChannel *channel = [PTChannel channelWithDelegate:self];
    channel.userInfo = self.connectingToDeviceID;
    channel.delegate = self;
    
    [channel connectToPort:PTExampleProtocolIPv4PortNumber overUSBHub:PTUSBHub.sharedHub deviceID:self.connectingToDeviceID callback:^(NSError *error) {
        if (error) {
            if (error.domain == PTUSBHubErrorDomain && error.code == PTUSBHubErrorConnectionRefused) {
                NSLog(@"Failed to connect to device #%@: %@", channel.userInfo, error);
            } else {
                NSLog(@"Failed to connect to device #%@: %@", channel.userInfo, error);
            }
            if (channel.userInfo == self.connectingToDeviceID) {
                [self performSelector:@selector(enqueueConnectToUSBDevice) withObject:nil afterDelay:PTAppReconnectDelay];
            }
        } else {
            self.connectedDeviceID = self.connectingToDeviceID;
            self.connectedChannel = channel;
            NSLog(@"Connected to device #%@\n%@", self.connectingToDeviceID, self.connectedDeviceProperties);
            //infoTextField_.stringValue = [NSString stringWithFormat:@"Connected to device #%@\n%@", deviceID, self.connectedDeviceProperties];
        }
    }];
}

#pragma mark - UI
- (void)appendLog:(NSString *)string
{
    self.logTextView.string = [[self.logTextView.string stringByAppendingString:string] stringByAppendingString:@"\n"];
//    [[self.logScrollView contentView] scrollToPoint: NSMakePoint(0, [self.logTextView frame].size.height - [self.logScrollView frame].size.height)];
    [self.logTextView scrollToEndOfDocument:self];
}

@end
