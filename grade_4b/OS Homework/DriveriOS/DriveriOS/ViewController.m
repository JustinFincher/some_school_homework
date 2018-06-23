//
//  ViewController.m
//  DriveriOS
//
//  Created by Justin Fincher on 2018/6/23.
//  Copyright © 2018 Justin Fincher. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <PeerTalk/Peertalk.h>
#include <stdint.h>
#import "PTCameraProtocol.h"

@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,PTChannelDelegate>
@property (weak, nonatomic) IBOutlet UIView *cameraContainerView;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@property (weak) PTChannel *serverChannel;
@property (weak) PTChannel *peerChannel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = @"网络摄像头驱动 服务端";
    
    [self startCamera];
    [self startDriver];
}
- (void)viewDidUnload {
    if (self.serverChannel) {
        [self.serverChannel close];
    }
    [super viewDidUnload];
}
#pragma mark - Camera
- (void)startCamera
{
    NSError *deviceError;
    AVCaptureDevice *cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *inputDevice = [AVCaptureDeviceInput deviceInputWithDevice:cameraDevice error:&deviceError];
    if (deviceError)
    {
        NSLog(@"%@",[deviceError description]);
    }
    AVCaptureVideoDataOutput *outputDevice = [[AVCaptureVideoDataOutput alloc] init];
    [outputDevice setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    [captureSession addInput:inputDevice];
    [captureSession addOutput:outputDevice];
    if ([captureSession canSetSessionPreset:AVCaptureSessionPreset352x288]){
        [captureSession setSessionPreset:AVCaptureSessionPreset352x288];
        NSLog(@"resolution preset changed");
    }
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer    layerWithSession:captureSession];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.cameraContainerView.bounds;
    [self.cameraContainerView.layer insertSublayer:previewLayer atIndex:0];
    [captureSession startRunning];
}

- (void)startDriver
{
    PTChannel *channel = [PTChannel channelWithDelegate:self];
    [channel listenOnPort:PTExampleProtocolIPv4PortNumber IPv4Address:INADDR_LOOPBACK callback:^(NSError *error) {
        if (error) {
            [self appendLog:[NSString stringWithFormat:@"Failed to listen on 127.0.0.1:%d: %@", PTExampleProtocolIPv4PortNumber, error]];
        } else {
            [self appendLog:[NSString stringWithFormat:@"Listening on 127.0.0.1:%d", PTExampleProtocolIPv4PortNumber]];
            self.serverChannel = channel;
        }
    }];
}

-(void)captureOutput:(AVCaptureOutput*)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection*)connection
{
    @autoreleasepool {
        if (self.peerChannel )
        {
            CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer( sampleBuffer );
            CVPixelBufferLockBaseAddress(imageBuffer,0);
            size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
            size_t width = CVPixelBufferGetWidth(imageBuffer);
            size_t height = CVPixelBufferGetHeight(imageBuffer);
            NSLog(@"%zu %zu",width,height);
            //void *src_buff = CVPixelBufferGetBaseAddress(imageBuffer);
            //NSData *data = [NSData dataWithBytes:src_buff length:bytesPerRow * height];
            
            CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
            CIContext *temporaryContext = [CIContext contextWithOptions:nil];
            CGImageRef videoImage = [temporaryContext
                                     createCGImage:ciImage
                                     fromRect:CGRectMake(0, 0,
                                                         CVPixelBufferGetWidth(imageBuffer),
                                                         CVPixelBufferGetHeight(imageBuffer))];
            
            UIImage *image = [[UIImage alloc] initWithCGImage:videoImage];
            CGImageRelease(videoImage);
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
            
            
            NSString *resString = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//            NSString * resString = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            __block dispatch_data_t payload = PTExampleTextDispatchDataWithString(resString);
            [self.peerChannel sendFrameOfType:PTExampleFrameTypeTextMessage tag:PTFrameNoTag withPayload:payload callback:^(NSError *error)
             {
                 if (error) {
                     NSLog(@"Failed to send message: %@", error);
                 }
                 else
                 {
                     
                     [self appendLog:[NSString stringWithFormat:@"[发送]: 长度 %lu", (unsigned long)[resString length]]];
                 }
                 payload = nil;
             }];
            
        } else {
            [self appendLog:@"Can not send message — not connected"];
        }
    }
}

#pragma mark - UI
- (void)appendLog:(NSString *)string
{
    self.logTextView.text = [[self.logTextView.text stringByAppendingString:string] stringByAppendingString:@"\n"];
    [self.logTextView scrollRangeToVisible:NSMakeRange(self.logTextView.text.length - 1, 1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Driver
- (void)sendDeviceInfo {
    if (!self.peerChannel)
    {
        return;
    }
    
    NSLog(@"Sending device info over %@", self.peerChannel);
    
    UIScreen *screen = [UIScreen mainScreen];
    CGSize screenSize = screen.bounds.size;
    NSDictionary *screenSizeDict = (__bridge_transfer NSDictionary*)CGSizeCreateDictionaryRepresentation(screenSize);
    UIDevice *device = [UIDevice currentDevice];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          device.localizedModel, @"localizedModel",
                          [NSNumber numberWithBool:device.multitaskingSupported], @"multitaskingSupported",
                          device.name, @"name",
                          (UIDeviceOrientationIsLandscape(device.orientation) ? @"landscape" : @"portrait"), @"orientation",
                          device.systemName, @"systemName",
                          device.systemVersion, @"systemVersion",
                          screenSizeDict, @"screenSize",
                          [NSNumber numberWithDouble:screen.scale], @"screenScale",
                          nil];
    dispatch_data_t payload = [info createReferencingDispatchData];
    [self.peerChannel sendFrameOfType:PTExampleFrameTypeDeviceInfo tag:PTFrameNoTag withPayload:payload callback:^(NSError *error) {
        if (error) {
            NSLog(@"Failed to send PTExampleFrameTypeDeviceInfo: %@", error);
        }
    }];
}
#pragma mark - PTChannelDelegate


- (BOOL)ioFrameChannel:(PTChannel*)channel shouldAcceptFrameOfType:(uint32_t)type tag:(uint32_t)tag payloadSize:(uint32_t)payloadSize {
    if (channel != self.peerChannel) {
        // A previous channel that has been canceled but not yet ended. Ignore.
        return NO;
    } else if (type != PTExampleFrameTypeTextMessage && type != PTExampleFrameTypePing) {
        NSLog(@"Unexpected frame of type %u", type);
        [channel close];
        return NO;
    } else {
        return YES;
    }
}

- (void)ioFrameChannel:(PTChannel*)channel didReceiveFrameOfType:(uint32_t)type tag:(uint32_t)tag payload:(PTData*)payload {
    //NSLog(@"didReceiveFrameOfType: %u, %u, %@", type, tag, payload);
    if (type == PTExampleFrameTypeTextMessage) {
        PTExampleTextFrame *textFrame = (PTExampleTextFrame*)payload.data;
        textFrame->length = ntohl(textFrame->length);
        NSString *message = [[NSString alloc] initWithBytes:textFrame->utf8text length:textFrame->length encoding:NSUTF8StringEncoding];
        [self appendLog:[NSString stringWithFormat:@"[%@]: %@", channel.userInfo, message]];
    } else if (type == PTExampleFrameTypePing && self.peerChannel) {
        [self.peerChannel sendFrameOfType:PTExampleFrameTypePong tag:tag withPayload:nil callback:nil];
    }
}

- (void)ioFrameChannel:(PTChannel*)channel didEndWithError:(NSError*)error {
    if (error) {
        [self appendLog:[NSString stringWithFormat:@"%@ ended with error: %@", channel, error]];
    } else {
        [self appendLog:[NSString stringWithFormat:@"Disconnected from %@", channel.userInfo]];
    }
}

- (void)ioFrameChannel:(PTChannel*)channel didAcceptConnection:(PTChannel*)otherChannel fromAddress:(PTAddress*)address {
    if (self.peerChannel) {
        [self.peerChannel cancel];
    }
    
    self.peerChannel = otherChannel;
    self.peerChannel.userInfo = address;
    [self appendLog:[NSString stringWithFormat:@"Connected to %@", address]];
    
    [self sendDeviceInfo];
}

@end
