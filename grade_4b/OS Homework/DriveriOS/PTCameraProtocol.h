//
//  PTCameraProtocol.h
//  DriveriOS
//
//  Created by Justin Fincher on 2018/6/23.
//  Copyright © 2018 Justin Fincher. All rights reserved.
//

#ifndef PTCameraProtocol_h
#define PTCameraProtocol_h

#import <Foundation/Foundation.h>
#include <stdint.h>

static const int PTExampleProtocolIPv4PortNumber = 6666;

enum {
    PTExampleFrameTypeDeviceInfo = 100,
    PTExampleFrameTypeTextMessage = 101,
    PTExampleFrameTypePing = 102,
    PTExampleFrameTypePong = 103,
};

typedef struct _PTExampleTextFrame {
    uint32_t length;
    uint8_t utf8text[0];
} PTExampleTextFrame;

static dispatch_data_t PTExampleTextDispatchDataWithString(NSString *message) {
    
    @autoreleasepool
    {
        // Use a custom struct
        const char *utf8text = [message cStringUsingEncoding:NSUTF8StringEncoding];
        size_t length = strlen(utf8text);
        PTExampleTextFrame *textFrame = CFAllocatorAllocate(nil, sizeof(PTExampleTextFrame) + length, 0);
        memcpy(textFrame->utf8text, utf8text, length); // Copy bytes to utf8text array
        textFrame->length = htonl(length); // Convert integer to network byte order
        // Wrap the textFrame in a dispatch data object
        
        return dispatch_data_create((const void*)textFrame, sizeof(PTExampleTextFrame)+length, nil, ^{
            CFAllocatorDeallocate(nil, textFrame);
        });
    }
}

#endif /* PTCameraProtocol_h */
