//
//  JZClientChatViewController.m
//  SocketMessager
//
//  Created by Fincher Justin on 16/6/13.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZClientChatViewController.h"
#import "JZSocketManager.h"
#import "JZMessageModelTextMsg.h"

@interface JZClientChatViewController ()<JZSocketManagerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property (weak, nonatomic) IBOutlet UITextView *chatHistoryTextView;

@end

@implementation JZClientChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any  setup after loading the view.
    self.chatTextField.delegate = self;
    JZSocketManager *manager = [JZSocketManager sharedManager];
    manager.delegate = self;
}

#pragma mark - JZSocketManagerDelegate
- (void)didReadData:(NSData *)data withTag:(long)tag
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
            JZMessageModelTextMsg *msg = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self updateChatHistory:msg.msg];
        }
            break;
            
        default:
            break;
    }
}

- (void)updateChatHistory:(NSString *)text
{
    self.chatHistoryTextView.text = [self.chatHistoryTextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",text]];
    
    NSRange range = NSMakeRange(self.chatHistoryTextView.text.length - 1, 1);
    [self.chatHistoryTextView scrollRangeToVisible:range];

}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[JZSocketManager sharedManager] sentMessage:textField.text toGroup:self.sendGroup];
    textField.text = @"";
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[JZSocketManager sharedManager] disconnectFromServer];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
