//
//  StudentInfo.h
//  NetBarViewer
//
//  Created by JustZht on 15/5/27.
//  Copyright (c) 2015年 JustZht. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StudentInfo : NSObject

@property (nonatomic, copy) NSString *StudentName;
@property (nonatomic, copy) NSString *StudentIndex;
@property (nonatomic) int ShouldPay;
@property (nonatomic) int DateBeginHour;
@property (nonatomic) int DateBeginMinute;
@property (nonatomic) int DateEndHour;
@property (nonatomic) int DateEndMinute;
@property (nonatomic) int DateLastHour;
@property (nonatomic) int DateLastMinute;

- (instancetype) ReInit;

- (instancetype)initWithName:(NSString *)name;

- (instancetype) initWithName:(NSString *)name
               StudentInIndex:(NSString *)index
            WithBeginTimeHour:(int *)beginhour
          WithBeginTimeMinute:(int *)beginminute
              WithEndTimeHour:(int *)endhour
               WithTimeMinute:(int *)endminute;
@end
