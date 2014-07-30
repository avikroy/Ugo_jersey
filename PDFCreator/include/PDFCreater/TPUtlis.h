
#import <Foundation/Foundation.h>

@interface TPUtlis : NSObject

+ (NSString *) applicationDocumentsDirectory;
+ (NSString *) applicationLibraryDirectory;
+ (BOOL) createDirectoryAtPath:(NSString *)path withInterMediateDirectory:(BOOL)isIntermediateDirectory;
+ (NSString *) tempFilePathForDir:(NSString *)dirName;
+ (BOOL) fileExistsAtPath:(NSString *)path ;
+ (BOOL) deleteFileAtPath:(NSString *)filepath;
+ (BOOL) writeContent:(NSData *)fileContent ToFile:(NSString *)fileName andPath:(NSString *)filePath ;
+ (NSString *)getTempFilePath;
+ (NSString *)getDirectoryAtPath:(NSString *)path withInterMediateDirectory:(BOOL)isIntermediateDirectory;

@end

