//
//  StudentInfoStore.h
//  NetBarViewer
//
//  Created by JustZht on 15/5/27.
//  Copyright (c) 2015年 JustZht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentInfo.h"

@interface StudentInfoStore : NSObject

@property (nonatomic) NSArray *AllStudent;

+ (instancetype)MakeAllStudent;
- (StudentInfo *)CreateStudent;
- (void)removeStudent:(StudentInfo *)studenttoberemoved;
- (void)moveStudentAtIndex:(NSUInteger)fromIndex
                   toIndex:(NSUInteger)toIndex;
- (instancetype)SetInfoStoreArray:(NSMutableArray *)ArrayToBeStored;

@end
