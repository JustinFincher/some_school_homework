//
//  FirstViewController.h
//  WilsonCalor
//
//  Created by Fincher Justin on 15/9/6.
//  Copyright (c) 2015年 Fincher Justin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *NumberXField;
@property (weak, nonatomic) IBOutlet UITextField *NumberYField;
- (IBAction)CalButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *SResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *NResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *PResultLabel;



@end

