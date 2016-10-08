//
//  FirstViewController.m
//  WilsonCalor
//
//  Created by Fincher Justin on 15/9/6.
//  Copyright (c) 2015年 Fincher Justin. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize NumberXField,NumberYField,SResultLabel,NResultLabel,PResultLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)CalButtonPressed:(id)sender
{
    
    double X =0.0;
    double Y =0.0;
    double N =0.0;
    double P =0.0;
    double S =0.0;
    
    X = [NumberXField.text doubleValue];
    Y = [NumberYField.text doubleValue];
    N = X+Y;
    P = Y/N;
    
    double cal1 = P*(1-P) + (1.96*1.96*0.25)/N;
    NSLog(@"cal1 = %f",cal1);
    double cal2 = cal1/N;
    NSLog(@"cal2 = %f ,SQRT CAL2 = %f",cal2,sqrt(cal2));
    double cal3 = P + (1.96*1.96*0.50)/N - (1.96* sqrt(cal2));
    NSLog(@"cal3 = %f",cal3);
    double cal4 = 1 + (1.96*1.96)/N;
    NSLog(@"cal4 = %f",cal4);

    
    S =cal3/cal4;
    
    NSLog(@"X%f Y%f N%f P%f S%f ",X,Y,N,P,S);
    [SResultLabel setText:[NSString stringWithFormat:@"S = %f",S]];
    [NResultLabel setText:[NSString stringWithFormat:@"N = %f",N]];
    [PResultLabel setText:[NSString stringWithFormat:@"P = %f",P]];
    
    
    

}

@end
