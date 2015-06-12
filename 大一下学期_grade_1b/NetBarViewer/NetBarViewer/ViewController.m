//
//  ViewController.m
//  NetBarViewer
//
//  Created by JustZht on 15/5/27.
//  Copyright (c) 2015年 JustZht. All rights reserved.
//

#import "ViewController.h"
#import "StudentInfoStore.h"
#import "StudentInfo.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic , strong) IBOutlet UIView *HeaderView;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {}
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[StudentInfoStore MakeAllStudent] AllStudent]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSArray *Persons = [[StudentInfoStore MakeAllStudent] AllStudent];
    StudentInfo *OnePerson = Persons[indexPath.row];
    
    
    cell.textLabel.text = [OnePerson description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *allstudentsineditmode = [[StudentInfoStore MakeAllStudent]AllStudent];
        StudentInfo *onestudentineditmode = allstudentsineditmode[indexPath.row];
        [[StudentInfoStore MakeAllStudent] removeStudent:onestudentineditmode];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        SaveStudentInfoStore:(NSMutableArray *)allstudentsineditmode;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[StudentInfoStore MakeAllStudent]moveStudentAtIndex:sourceIndexPath.row   toIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *StudentDetailVC = [[DetailViewController alloc]init];
    
    NSArray *Students = [[StudentInfoStore MakeAllStudent] AllStudent];
    StudentInfo *SelectedStudentInfoInListView = Students[indexPath.row];
    StudentDetailVC.StudentInfoWhenPushToDetailVC = SelectedStudentInfoInListView;
    
    [self.navigationController pushViewController:StudentDetailVC animated:YES];
    SaveStudentInfoStore:(NSMutableArray *)Students;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *HeaderViewinViewDidLoad = self.HeaderView;
    [self.tableView setTableHeaderView:HeaderViewinViewDidLoad];
    
    self.title = @"课程设计 上机管理系统 by 1402 郑昊天";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)HeaderView
{
    if (!_HeaderView)
    {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return _HeaderView;
}

- (IBAction)AddStudent:(id)sender
{
    StudentInfo *NewStudentWhenPressAdded = [[StudentInfoStore MakeAllStudent]CreateStudent];
    NSInteger lastRow = [[[StudentInfoStore MakeAllStudent]AllStudent]indexOfObject:NewStudentWhenPressAdded];
    NSIndexPath *NewCellFuckPath =[NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[NewCellFuckPath] withRowAnimation:UITableViewRowAnimationTop];
}

- (IBAction)ToggleEditMode:(id)sender
{
    if (self.isEditing) {
        [sender setTitle:@"编辑内容" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    }else {
        [sender setTitle:@"完成编辑" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    NSArray *Students = [[StudentInfoStore MakeAllStudent] AllStudent];
    SaveStudentInfoStore:(NSMutableArray *)Students;
}


@end
