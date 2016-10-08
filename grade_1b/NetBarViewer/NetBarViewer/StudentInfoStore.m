//
//  StudentInfoStore.m
//  NetBarViewer
//
//  Created by JustZht on 15/5/27.
//  Copyright (c) 2015年 JustZht. All rights reserved.
//

#import "StudentInfoStore.h"
#import "StudentInfo.h"

@interface StudentInfoStore ()

@property (nonatomic) NSMutableArray *PrivateAllStudent;

@end

@implementation StudentInfoStore

+ (instancetype)MakeAllStudent
{
    static StudentInfoStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (NSArray*)AllStudent
{
    for (int i = 0; i < self.PrivateAllStudent.count; i++)
    {
        [[self.PrivateAllStudent objectAtIndex:i] ReInit];
    }
    return self.PrivateAllStudent;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"USE +[StudentInfoStore AllStudent]" userInfo:nil];
    return nil;
}

- (instancetype) initPrivate
{
    self = [super init];
    if (self) {
        _PrivateAllStudent = [[NSMutableArray alloc]init];
    }
    return self;
}

- (StudentInfo *)CreateStudent
{
    StudentInfo *OnePerson = [[StudentInfo alloc] initWithName:@"请详细编辑"];
    [self.PrivateAllStudent addObject:OnePerson];
    return OnePerson;
}

- (void)removeStudent:(StudentInfo *)studenttoberemoved
{
    [self.PrivateAllStudent removeObjectIdenticalTo:studenttoberemoved];
}

- (void)moveStudentAtIndex:(NSUInteger)fromIndex
                   toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    StudentInfo *StudentToBeMoved = self.PrivateAllStudent[fromIndex];
    [self.PrivateAllStudent removeObjectIdenticalTo:StudentToBeMoved];
    [self.PrivateAllStudent insertObject:StudentToBeMoved atIndex:toIndex];
}

- (instancetype)SetInfoStoreArray:(NSMutableArray *)ArrayToBeStored
{
    StudentInfoStore *ToBeStoredStore = [[StudentInfoStore alloc]initPrivate];
    ToBeStoredStore.PrivateAllStudent = ArrayToBeStored;
    return ToBeStoredStore;
}

@end
