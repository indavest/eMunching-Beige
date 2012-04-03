//
//  SecurityWrapper.m
//
//

#import "SecurityWrapper.h"


@implementation SecurityWrapper

// This is where most of the magic happens (the rest of it happens in computeSHA256DigestForString: method below).
// Here we are passing in the hash of the PIN that the user entered so that we can avoid manually handling the PIN itself.
// Then we are extracting the username that the user supplied during setup, so that we can add another unique element to the hash.
// From there, we mash the user name, the passed-in PIN hash, and the secret key (from ChristmasConstants.h) together to create 
// one long, unique string.
// Then we send that entire hash mashup into the SHA256 method below to create a "Digital Digest," which is considered
// a one-way encryption algorithm. "One-way" means that it can never be reverse-engineered, only brute-force attacked.
// The algorthim we are using is Hash = SHA256(Name + Salt + (Hash(PIN))). This is called "Digest Authentication."
+ (NSString *)securedSHA256DigestForHash:(NSUInteger)hashValue andSalt: (NSString *) salt andName: (NSString *) name
{
    // 1
    //NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
    //NSString *name = @"PunchMeIfY0uCAN";
    name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 2
    NSString *computedHashString = [NSString stringWithFormat:@"%@%i%@", name, hashValue, salt];
    // 3
    NSString *finalHash = [self computeSHA256DigestForString:computedHashString];
    //NSLog(@"** Computed hash: %@ for SHA256 Digest: %@", computedHashString, finalHash);
    return finalHash;
}

// This is where the rest of the magic happens.
// Here we are taking in our string hash, placing that inside of a C Char Array, then parsing it through the SHA256 encryption method.
+ (NSString*)computeSHA256DigestForString:(NSString*)input 
{
    
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA256(data.bytes, data.length, digest);
    
    // Setup our Objective-C output.
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}


+(NSString*) sha256:(NSString *)clear{
    const char *s=[clear cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}


+ (BOOL)compareEncryptedStrings:(NSString*)string1 andString: (NSString*)string2
{
    
    if ([string1 isEqualToString:string2]) {
        return YES;
    } else {
        return NO;
    }    
}

+(NSString*) FZARandomSalt {
    uint8_t bytes[16] = {0};
    int status = SecRandomCopyBytes(kSecRandomDefault, 16, bytes);
    if (status == -1) {
        NSLog(@"Error using randomization services: %s", strerror(errno));
        return nil;
    }
    NSString *salt = [NSString stringWithFormat: @"%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x",
                      bytes[0],  bytes[1],  bytes[2],  bytes[3],
                      bytes[4],  bytes[5],  bytes[6],  bytes[7],
                      bytes[8],  bytes[9],  bytes[10], bytes[11],
                      bytes[12], bytes[13], bytes[14], bytes[15]];
    return salt;
}


@end
