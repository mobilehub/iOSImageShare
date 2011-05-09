//
//  URLBase64.h
//  iOSImageShare
//
//  Created by Gustavo Ambrozio on 8/5/11.
//

#import <Foundation/Foundation.h>


@interface URLBase64 : NSObject {

}

+ (NSString*) encode:(const uint8_t*) input length:(NSInteger) length;
+ (NSString*) encode:(NSData*) rawBytes;
+ (NSData*) decode:(const char*) string length:(NSInteger) inputLength;
+ (NSData*) decode:(NSString*) string;


@end
