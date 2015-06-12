//
//  DetailViewController.m
//  NetBarViewer
//
//  Created by JustZht on 15/5/27.
//  Copyright (c) 2015年 JustZht. All rights reserved.
//

#import "DetailViewController.h"
#import "StudentInfo.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *StudentNameField;
@property (weak, nonatomic) IBOutlet UITextField *StudentIndexField;
@property (weak, nonatomic) IBOutlet UITextField *BeginHourInXIB;
@property (weak, nonatomic) IBOutlet UITextField *EndHourInXIB;
@property (weak, nonatomic) IBOutlet UITextField *BeginMinuteInXIB;
@property (weak, nonatomic) IBOutlet UITextField *EndMinuteInXIB;
@property (weak, nonatomic) IBOutlet UILabel *ShouldPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *LastHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *LastMinuteLabel;

@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    StudentInfo *StudentInfoWhenPushToDetailVC = self.StudentInfoWhenPushToDetailVC;
    //这里是指针 所以修改其实都是在修改self.StudentInfoWhenPushToDetailVC
    
    self.StudentNameField.text = StudentInfoWhenPushToDetailVC.StudentName;
    self.StudentIndexField.text = StudentInfoWhenPushToDetailVC.StudentIndex;
    self.BeginHourInXIB.text = [NSString stringWithFormat:@"%d",StudentInfoWhenPushToDetailVC.DateBeginHour];
    self.BeginMinuteInXIB.text = [NSString stringWithFormat:@"%d",StudentInfoWhenPushToDetailVC.DateBeginMinute];
    self.EndHourInXIB.text = [NSString stringWithFormat:@"%d",StudentInfoWhenPushToDetailVC.DateEndHour];
    self.EndMinuteInXIB.text = [NSString stringWithFormat:@"%d",StudentInfoWhenPushToDetailVC.DateEndMinute];
    self.ShouldPayLabel.text = [NSString stringWithFormat:@"%d",StudentInfoWhenPushToDetailVC.ShouldPay];
    self.LastHourLabel.text = [NSString stringWithFormat:@"%d",StudentInfoWhenPushToDetailVC.DateLastHour];
    self.LastMinuteLabel.text = [NSString stringWithFormat:@"%d",StudentInfoWhenPushToDetailVC.DateLastMinute];
    
    self.title = [NSString stringWithFormat:@"%@的上机信息",StudentInfoWhenPushToDetailVC.StudentName];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    StudentInfo *StudentInfoWhenLeavingDetail = self.StudentInfoWhenPushToDetailVC;
    //这里是指针 所以修改其实都是在修改self.StudentInfoWhenPushToDetailVC

    StudentInfoWhenLeavingDetail.StudentName = self.StudentNameField.text;
    StudentInfoWhenLeavingDetail.StudentIndex = self.StudentIndexField.text;
    StudentInfoWhenLeavingDetail.DateBeginHour = [self.BeginHourInXIB.text intValue];
    StudentInfoWhenLeavingDetail.DateBeginMinute = [self.BeginMinuteInXIB.text intValue];
    StudentInfoWhenLeavingDetail.DateEndHour = [self.EndHourInXIB.text intValue];
    StudentInfoWhenLeavingDetail.DateEndMinute = [self.EndMinuteInXIB.text intValue];
}





@end
