//
//  FMDBAPI.m
//  Passbuster
//
//  Created by Fincher Justin on 15/10/29.
//  Copyright © 2015年 Fincher Justin. All rights reserved.
//

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#import "FMDBAPI.h"
#import "FMDB.h"
#import "IntroAnimator.h"
#import "CocoaSecurity.h"
#import "Password.h"
#import "PasswordClass.h"
#import "PasswordWapper.h"

@implementation FMDBAPI
@synthesize dbPath;

- (void)LaunchCheck
{
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    self.dbPath = path;
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO)
    {
        NSLog(@"WARNING no database at document");
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open])
        {
            NSString * CreateAccountSessionTable = @"CREATE TABLE 'AccountSession' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'Company' VARCHAR(64), 'Username' VARCHAR(64), 'Password' VARCHAR(64) )";
            NSString * CreateAppSettingsTable = @"CREATE TABLE 'AppSettings' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'MainPassword' VARCHAR(64), 'isFirstOpen' INTEGER )";
            BOOL CreateAppSettingsTableResult = [db executeUpdate:CreateAppSettingsTable];
            BOOL CreateAccountSessionTableResult = [db executeUpdate:CreateAccountSessionTable];
            
            if (!CreateAppSettingsTableResult)
            {
                NSLog(@"ERROR CreateAppSettingsTable");
            }
            else
            {
                NSLog(@"SUCCESS CreateAppSettingsTable");
            }
            
            if (!CreateAccountSessionTableResult)
            {
                NSLog(@"ERROR CreateAppSettingsTable");
            }
            else
            {
                NSLog(@"SUCCESS CreateAppSettingsTable");
                
                NSString * InsertSettingsScript = @"insert into AppSettings (MainPassword,isFirstOpen) values(?,?)";
                NSString * DefaultMainPassword = @"";
                NSNumber * isFirstOpen = [NSNumber numberWithInt:1];
                BOOL InsertSettingsScriptResult = [db executeUpdate:InsertSettingsScript,DefaultMainPassword,isFirstOpen];
                if (InsertSettingsScriptResult)
                {
                    NSLog(@"SUUCESS insert settings defaultmainpassword = empty isfirstopen = 1 ");
                }
                else
                {
                    NSLog(@"ERROR insert settings defaultmainpassword = empty isfirstopen = 1 ");
                }

            }

            [db close];
        }
        else
        {
            NSLog(@"ERROR open database when launch check");
        }

    }
    else
    {
        NSLog(@"SUCCESS found database at document");
    }
}


- (BOOL)InsertAccountSessionWithUsername:(NSString *)Username
                           WithPassword:(NSString *)Password
                             WithCompany:(NSString *)Company
{
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    self.dbPath = path;
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == YES)
    {
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open])
        {
            NSString * InsertAccountScript = @"insert into AccountSession (Username, Password, Company) values(?,?,?)";
            
            BOOL InsertAccountScriptResult = [db executeUpdate:InsertAccountScript,Username,Password,Company];
            if (InsertAccountScriptResult)
            {
                NSLog(@"SUCCESS insert account session");
                [db close];
                return YES;
            }
            else
            {
                NSLog(@"ERROR insert account session");
                [db close];
                return NO;
            }
        }
        else
        {
            NSLog(@"ERROR open database when insert account session");
            return NO;
        }
    }
    else
    {
        NSLog(@"ERROR find database when insert account session");
        return NO;
    }
}

- (BOOL)ChangeAccountSessionWithMainPassword:(NSString *)MainPassword
{
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    self.dbPath = path;
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == YES)
    {
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open])
        {
            NSString * ChangeSettingsScript = @"update AppSettings SET MainPassword = ? WHERE ID = 1";
            
            BOOL ChangeSettingsScriptResult = [db executeUpdate:ChangeSettingsScript,MainPassword];
            if (ChangeSettingsScriptResult) {
                NSLog(@"SUUCESS change settings session");
                [db close];
                return YES;
            } else {
                NSLog(@"ERROR change settings session");
                [db close];
                return NO;
            }
        }
        else
        {
            NSLog(@"ERROR open database change settings session");
            return NO;
        }
    }
    else
    {
        NSLog(@"ERROR find database change settings session");
        return NO;
    }
}


- (BOOL)ChangeAppSettingsWithIsFirstOpen:(NSNumber *)isFirstOpen
{
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    self.dbPath = path;
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == YES)
    {
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open])
        {
            NSString * ChangeSettingsScript = @"update AppSettings SET isFirstOpen = ? WHERE ID = 1";
            
            BOOL ChangeSettingsScriptResult = [db executeUpdate:ChangeSettingsScript,isFirstOpen];
            if (ChangeSettingsScriptResult) {
                NSLog(@"SUUCESS change isFirstOpen settings");
                [db close];
                return YES;
            } else {
                NSLog(@"ERROR change isFirstOpen settings");
                [db close];
                return NO;
            }
        }
        else
        {
            NSLog(@"ERROR open database when change isFirstOpen settings");
            return NO;
        }
    }
    else
    {
        NSLog(@"ERROR find database when change isFirstOpen settings");
        return NO;
    }
}


- (NSString *)getMainPasswordFromFMDB
{
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    self.dbPath = path;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == YES)
    {
        
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open])
        {
            NSString *MainPassword = [db stringForQuery:@"SELECT MainPassword FROM AppSettings WHERE id = 1"];
            NSLog(@"%@",MainPassword);
            [db close];
            return MainPassword;
        }
        else
        {
            NSLog(@"error when open db");
            return nil;
        }
        
    }else
    {
        return nil;
    }

}

- (BOOL)RemoveAccountSessionWithIndex:(NSNumber *)Index
{
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    self.dbPath = path;
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == YES)
    {
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open])
        {
            NSString * RemoveAccountScript = @"delete from AccountSession WHERE ID = ? ";
            
            BOOL RemoveAccountScriptResult = [db executeUpdate:RemoveAccountScript,(Index)];
            if (RemoveAccountScriptResult)
            {
                NSLog(@"SUCCESS Remove account session");
                [db close];
                return YES;
            }
            else
            {
                NSLog(@"ERROR Remove account session");
                [db close];
                return NO;
            }
        }
        else
        {
            NSLog(@"ERROR open database when Remove account session");
            return NO;
        }
    }
    else
    {
        NSLog(@"ERROR find database when Remove account session");
        return NO;
    }
    
}

- (BOOL)SelfDestroy
{
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path] == YES)
    {
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:path error:&error];
        if (success)
        {
            return YES;
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
            return NO;
        }
    }
    else
    {
        NSLog(@"ERROR find database when self destroy");
        return NO;
    }

}

-(BOOL)DatabaseMigratedWithNewPassword:(NSString *)NewPWD
{
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path] == YES)
    {
        
        FMDatabase *db = [FMDatabase databaseWithPath:path];
        db.logsErrors = YES;
        if ([db open])
        {
            FMResultSet *AllSessions = [db executeQuery:@"SELECT * FROM AccountSession"];
            if (AllSessions)
            {
                
                NSString *MainPassword = NewPWD;
                CocoaSecurityResult *MainPassword_md5 = [CocoaSecurity md5:MainPassword];
                
                
                NSLog(@"SUCCESS get AllSessions");
                
                while ([AllSessions next])
                {
                    NSLog(@"ONE SESSION");
                    NSString *SessionIndex = [AllSessions stringForColumnIndex:0];
                    NSString *PasswordString = [AllSessions stringForColumnIndex:3];
                    NSString *RawOldPassword = [[[PasswordWapper alloc] init] getDecryptedPasswordFromCryptedPassword:PasswordString];
                    NSString *NewPassword = [[[PasswordWapper alloc] init] setCryptedPasswordFromDecryptedPassword:RawOldPassword WithNewMD5MainPWD:MainPassword_md5.hex];
                    
                    NSLog(@"-----------------------------------");
                    NSLog(@"PasswordString ＝ %@",PasswordString);
                    NSLog(@"RawOldPassword ＝ %@",RawOldPassword);
                    NSLog(@"NewPassword ＝ %@",NewPassword);
                    NSLog(@"-----------------------------------");
                    
                    
                    NSString * ChangePasswordScript = @"update AccountSession SET Password = ? WHERE ID = ?";
                    
                    BOOL ChangePasswordScriptResult = [db executeUpdate:ChangePasswordScript,NewPassword,[NSNumber numberWithInt:[SessionIndex intValue]]];
                    if (ChangePasswordScriptResult) {
                        NSLog(@"SUUCESS change password  # %@",SessionIndex);
                        NSLog(@"PasswordString %@ ----> NewPassword %@",PasswordString,NewPassword);
                    } else {
                        NSLog(@"ERROR change password # %@ ",SessionIndex);
                    }
                }

                [AllSessions close];
                return YES;
            }
            
            else
            {
                [db close];
                NSLog(@"ERROR get AllSessions");
                return NO;
            }
            
        }
        else
        {
            NSLog(@"error when open db");
            return NO;
        }
        
    }
    else
    {
        return NO;
    }

}
@end
