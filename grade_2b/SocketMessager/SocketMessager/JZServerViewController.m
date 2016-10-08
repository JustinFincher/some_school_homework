//
//  JZServerViewController.m
//  SocketMessager
//
//  Created by Fincher Justin on 16/6/12.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZServerViewController.h"
#import "GCDAsyncSocket.h"
#import "JZSocketManager.h"
#import "JZMessageModel.h"
#import "JZMessageModelAllClientArray.h"
#import "JZMessageModelTextMsg.h"

@interface JZServerViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic) int portNumber;
@property (strong,nonatomic) GCDAsyncSocket * socketServer;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@property (strong,nonatomic) NSMutableArray *socketArray;

@end

@implementation JZServerViewController
@synthesize socketServer;
@synthesize portNumber;
@synthesize socketArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    portNumber = 8000;
    
    socketArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    socketServer = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    if (![socketServer acceptOnPort:portNumber error:&error])
    {
        _addressLabel.text = @"Can't Open Socket, Try Again.";
        
    }else
    {
        _addressLabel.text = [NSString stringWithFormat:@"%@:%d",[[JZSocketManager sharedManager] getIPAddress],portNumber];
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(boardAllConnectedDevices)
                                       userInfo:nil
                                        repeats:YES];
        
        [self.socketServer readDataWithTimeout:-1 tag:0];
    }
}

#pragma mark - Delegate
- (void)socket:(GCDAsyncSocket *)sender didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"New Connection");
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    [self updateLogTextView:[NSString stringWithFormat:@"%@\nNew Connection From %@:%hu",dateString,[newSocket connectedHost],[newSocket connectedPort]]];

    [socketArray addObject:newSocket];
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"New Disconnect : %@",[err debugDescription]);
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    [self updateLogTextView:[NSString stringWithFormat:@"%@\nSocket Disconnetted From %@:%hu :%@",dateString,[sock connectedHost],[sock connectedPort],[err debugDescription]]];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    JZMessageModel *msg = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@",msg.msgType);
    switch ([msg.msgType intValue])
    {
        case 0:
        {}
            break;
        case 1:
        {
            JZMessageModelTextMsg * textMsg = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self.socketServer readDataWithTimeout:-1 tag:TAG_MSG];
            
            NSArray *array = textMsg.receiverArray;
            for (NSString *address in array)
            {
                NSArray *addresses = [address componentsSeparatedByString:@":"];
                NSString *ip = [addresses objectAtIndex:0];
                for (GCDAsyncSocket *socket in self.socketArray)
                {
                    if ([[socket connectedHost] isEqualToString:ip]) {
                        [socket writeData:data withTimeout:-1 tag:TAG_MSG];
                    }
                }
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Boardcast

- (void)boardAllConnectedDevices
{
    [self checkSocketArrayAvailability];
    JZMessageModelAllClientArray *msg = [[JZMessageModelAllClientArray alloc] init];
    msg.allClients = [self getInfoArrayFromSocketArray:self.socketArray];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:msg];
    if (data)
    {
        for (GCDAsyncSocket *socket in self.socketArray)
        {
            [socket writeData:data withTimeout:-1 tag:TAG_DEVICEARRAY];
            [socket readDataWithTimeout:-1 tag:TAG_DEVICEARRAY];
        }
    }
}
- (void)checkSocketArrayAvailability
{
    NSMutableArray *discardedItems = [NSMutableArray array];
    for (GCDAsyncSocket *socket in self.socketArray)
    {
        if ([socket connectedHost])
        {}else
        {
            [discardedItems addObject:socket];
        }
    }
    [self.socketArray removeObjectsInArray:discardedItems];
}
- (NSMutableArray *)getInfoArrayFromSocketArray:(NSMutableArray *)allSocketArray
{
    NSMutableArray *infoArray = [NSMutableArray array];
    for (int i = 0; i < [allSocketArray count]; i++)
    {
        GCDAsyncSocket *socket = [allSocketArray objectAtIndex:i];
        NSString *string = [NSString stringWithFormat:@"%@:%hu",[socket connectedHost],[socket connectedPort]];
        [infoArray addObject:string];
    }
    return infoArray;
}

#pragma mark - Stuff
- (void)updateLogTextView:(NSString *)string
{
    _logTextView.text = [_logTextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",string]];
    
    NSRange range = NSMakeRange(_logTextView.text.length - 1, 1);
    [_logTextView scrollRangeToVisible:range];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
