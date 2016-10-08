//
//  JZClientJoinServerViewController.m
//  SocketMessager
//
//  Created by Fincher Justin on 16/6/12.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZClientJoinServerViewController.h"
#import "JZSocketManager.h"

@interface JZClientJoinServerViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;

@end

@implementation JZClientJoinServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _ipTextField.delegate = self;
    _portTextField.delegate = self;
}
- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)nextButtonPressed:(id)sender
{
    
    if ([[JZSocketManager sharedManager] connectSocketIP:_ipTextField.text port:_portTextField.text])
    {
        [self performSegueWithIdentifier:@"addressToChatSelectionSegue" sender:self];
    }else
    {
        [UIView animateWithDuration:1.0f animations:^(void){
            self.view.backgroundColor = [UIColor redColor];
        }];
    }
}

- (IBAction)screenTapped:(UITapGestureRecognizer *)sender
{
    if (sender.view
== self.view)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
