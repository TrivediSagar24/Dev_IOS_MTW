//
//  DBOperation.m
//  Puzzle
//
//  Created by hbmac1 on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DBOperation.h"

static sqlite3 *database = nil;
static int conn;
@implementation DBOperation


+(void)checkCreateDB{
    @try {
        NSString *dbPath,*databaseName;
        
        databaseName=@"MeeTwo.sqlite";
        
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *docDir = [docPaths objectAtIndex:0];
        dbPath = [docDir stringByAppendingPathComponent:databaseName];
        BOOL success;
        NSFileManager *fm = [NSFileManager defaultManager];
        success=[fm fileExistsAtPath:dbPath];
        NSLog(@"DataBasePath %@",dbPath);

        
        if(success)
        {
            [self OpenDatabase:dbPath];
            return;
        }
        NSString *dbPathFromApp=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        [fm copyItemAtPath:dbPathFromApp toPath:dbPath error:nil];
        [self OpenDatabase:dbPath];

    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception reason]);
    }
}

//Open database
+ (void) OpenDatabase:(NSString*)path
{
	@try
	{
		conn = sqlite3_open([path UTF8String], &database);
		if (conn == SQLITE_OK) {
		}
		else
			sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
	}	
	@catch (NSException *e) {
		NSLog(@"%@",e); 
	}	
}



+(NSMutableArray*) selectData:(NSString *)sql
{
    @try 
    {
        if (conn == SQLITE_OK) 
        {
            sqlite3_stmt *stmt = nil;
            if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
                [NSException raise:@"DatabaseException" format:@"Error while creating statement. '%s'", sqlite3_errmsg(database)];
            }
            NSMutableArray *obj = [[NSMutableArray alloc]init];
            int numResultColumns = 0;
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                numResultColumns = sqlite3_column_count(stmt);
                @autoreleasepool {
                    NSMutableDictionary *tmpObj = [[NSMutableDictionary alloc]init];
                    for(int i = 0; i < numResultColumns; i++){
                        if(sqlite3_column_type(stmt, i) == SQLITE_INTEGER){
                            
                            const char *name = sqlite3_column_name(stmt, i);
                            NSString *columnName = [[NSString alloc]initWithCString:name encoding:NSUTF8StringEncoding];
                            [tmpObj setObject:[NSString stringWithFormat:@"%i",sqlite3_column_int(stmt, i)] forKey:columnName];
                            
                        } else if (sqlite3_column_type(stmt, i) == SQLITE_FLOAT) {
                            
                            const char *name = sqlite3_column_name(stmt, i);
                            NSString *columnName = [[NSString alloc]initWithCString:name encoding:NSUTF8StringEncoding];

                            [tmpObj setObject:[NSString stringWithFormat:@"%f",sqlite3_column_double(stmt, i)] forKey:columnName];
                        } else if (sqlite3_column_type(stmt, i) == SQLITE_TEXT) {
                            const char *name = sqlite3_column_name(stmt, i);
                            NSString *tmpStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, i)];
                            if ( tmpStr == nil) {
                                tmpStr = @"";
                            }
                            NSString *columnName = [[NSString alloc]initWithCString:name encoding:NSUTF8StringEncoding];
                            [tmpObj setObject:tmpStr forKey:columnName];
                            
                        } else if (sqlite3_column_type(stmt, i) == SQLITE_BLOB) {
                            
                        }     
                        else if (sqlite3_column_type(stmt, i) == SQLITE_NULL) {
                            const char *name = sqlite3_column_name(stmt, i);
                            NSString *tmpStr = @"";
                            
                            NSString *columnName = [[NSString alloc]initWithCString:name encoding:NSUTF8StringEncoding];
                            [tmpObj setObject:tmpStr forKey:columnName];
                        }
                        
                    }
                    [obj addObject:tmpObj];
                
                }
            }
            return obj;
        } else {
            return nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception reason]);
        return nil;
    }
 }

+(BOOL) executeSQL:(NSString *)sqlTmp {
	@try {
        if(conn == SQLITE_OK) {     
            
            const char *sqlStmt = [sqlTmp cStringUsingEncoding:NSUTF8StringEncoding];
            sqlite3_stmt *cmp_sqlStmt1;
            int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt1, NULL);
            
            returnValue == SQLITE_OK ?  NSLog(@"\n Inserted \n") :NSLog(@"\n Not Inserted %s\n",sqlite3_errmsg(database));
            
            sqlite3_step(cmp_sqlStmt1);
            sqlite3_finalize(cmp_sqlStmt1);
            
            if (returnValue == SQLITE_OK)
            {
                return TRUE;
            }
        }
        return FALSE;

    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception reason]);
        return NO;
    }
}



+(CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text
{
    if (text.length > 0)
    {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:label.font}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){label.frame.size.width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        
        return ceil(rect.size.height);
    }
    
    return 0;
}

+(NSMutableArray *)SortArray : (NSMutableArray *)arrOriginal
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id"
                                                   ascending:YES
                                                  comparator:^(id obj1, id obj2) {
                                                      return [obj1 compare:obj2 options:NSNumericSearch];
                                                  }];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [arrOriginal
                   sortedArrayUsingDescriptors:sortDescriptors];
    [arrOriginal removeAllObjects];
    [arrOriginal addObjectsFromArray:sortedArray];
    return arrOriginal;
}

#pragma mark - Remove More Space on String

+(NSString *)returnRemoveMoreSpace : (NSString *)str
{
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [str componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    str = [filteredArray componentsJoinedByString:@" "];
    return str;
}


+(NSMutableArray *)SortArrayToWidth : (NSMutableArray *)arrOriginal
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"width"
                                                   ascending:YES
                                                  comparator:^(id obj1, id obj2) {
                                                      return [obj1 compare:obj2];
                                                  }];
    
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [arrOriginal
                   sortedArrayUsingDescriptors:sortDescriptors];
    [arrOriginal removeAllObjects];
    [arrOriginal addObjectsFromArray:sortedArray];
    return arrOriginal;
}


@end
