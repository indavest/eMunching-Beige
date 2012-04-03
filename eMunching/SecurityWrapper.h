//
//  SecurityWrapper.h
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonHMAC.h>

@interface SecurityWrapper : NSObject


// Generates an SHA256 (much more secure than MD5) hash.
+ (NSString *)securedSHA256DigestForHash:(NSUInteger)hashValue andSalt: (NSString *) salt andName: (NSString *) name;
+ (NSString *)computeSHA256DigestForString:(NSString*)input;
+ (BOOL)compareEncryptedStrings:(NSString*)string1 andString: (NSString*)string2;
+ (NSString*) FZARandomSalt;
+ (NSString*) sha256:(NSString *)clear;
@end