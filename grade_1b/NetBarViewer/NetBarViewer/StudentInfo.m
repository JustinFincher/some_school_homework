//
//  StudentInfo.m
//  NetBarViewer
//
//  Created by JustZht on 15/5/27.
//  Copyright (c) 2015年 JustZht. All rights reserved.
//

#import "StudentInfo.h"


@implementation StudentInfo

- (instancetype)init
{
    return [self initWithName:@"Item"];
}


- (instancetype) initWithName:(NSString *)name
{
    return [self initWithName:name
               StudentInIndex:@""
            WithBeginTimeHour:0
          WithBeginTimeMinute:0
              WithEndTimeHour:0
               WithTimeMinute:0];
}

- (instancetype) initWithName:(NSString *)name
               StudentInIndex:(NSString *)index
            WithBeginTimeHour:(int)beginhour
          WithBeginTimeMinute:(int)beginminute
              WithEndTimeHour:(int)endhour
               WithTimeMinute:(int)endminute
{
    self = [super init];
    if (self) {
        _StudentName = name;
        _StudentIndex = index;
        _DateBeginHour = beginhour;
        _DateBeginMinute = beginminute;
        _DateEndHour = endhour;
        _DateEndMinute = endminute;
        _DateLastMinute = endminute - beginminute;
        _DateLastHour = endhour - beginhour;
        if (_DateLastMinute < 0)
        {
            _DateLastMinute = _DateLastMinute + 60;
            _DateLastHour = _DateLastHour - 1;
        }
        if (_DateLastMinute > 0)
        {
            _ShouldPay = _DateLastHour + 1;
        }else
        {
            _ShouldPay = _DateLastHour;
        }
    }
    return self;
}

- (instancetype) ReInit
{
    if (self) {
        self.DateLastMinute = self.DateEndMinute - self.DateBeginMinute;
        self.DateLastHour = self.DateEndHour - self.DateBeginHour;
        if (self.DateLastMinute < 0)
        {
            self.DateLastMinute = self.DateLastMinute + 60;
            self.DateLastHour = self.DateLastHour - 1;
        }
        if (self.DateLastMinute > 0)
        {
            self.ShouldPay = self.DateLastHour + 1;
        }else
        {
            self.ShouldPay = self.DateLastHour;
        }
    }
    return self;
}


- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"姓名: %@ 学号:%@ 应付: $%d, 时长: %d:%d",
     self.StudentName,
     self.StudentIndex,
     self.ShouldPay,
     self.DateLastHour,
     self.DateLastMinute];
    return descriptionString;
}

@end
