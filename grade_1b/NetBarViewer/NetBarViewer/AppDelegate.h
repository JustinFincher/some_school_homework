//
//  AppDelegate.h
//  NetBarViewer
//
//  Created by JustZht on 15/5/27.
//  Copyright (c) 2015年 JustZht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentInfoStore.h"

NSString *docPath(void);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)SaveStudentInfoStore:(NSMutableArray *)StudentReadyToSave;
- (StudentInfoStore *)RestoreInfoStoreToDevice;

@end

