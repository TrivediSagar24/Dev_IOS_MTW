 
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <UIKit/UIKit.h>

@interface DBOperation : NSObject 
{
}

+(void)OpenDatabase:(NSString*)path;  //Open the Database
//+(void)finalizeStatements;//Closing and do the final statement at application exits
+(void)checkCreateDB;
//+(int) getLastInsertId;
+(BOOL) executeSQL:(NSString *)sqlTmp;
+(NSMutableArray*) selectData:(NSString *)sql;
+(NSMutableArray *)SortArray : (NSMutableArray *)arrOriginal;
+(CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text;
+(NSString *)returnRemoveMoreSpace : (NSString *)str;
@end
