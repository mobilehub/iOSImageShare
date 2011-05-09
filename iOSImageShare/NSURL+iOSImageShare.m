//
//  NSURL+iOSImageShare.m
//  iOSImageShare
//
//  Created by Gustavo Ambrozio on 8/5/11.
//

#import "NSURL+iOSImageShare.h"
#import "URLBase64.h"

@implementation NSURL (NSURL_iOSImageShare)

- (NSString *)getParameterNamed:(NSString *)parameterName {
    
    if (self.query) {
        
        NSString *parameterNameToken = [parameterName stringByAppendingString:@"="];
        NSScanner *scanner = [NSScanner scannerWithString:self.query];
        
        // Skip to start of parameter.
        [scanner scanUpToString:parameterNameToken intoString:nil];
        
        // Skip to start of value if parameter really exists.
        if ([scanner scanString:parameterNameToken intoString:nil]) {
            NSString *parameterValue = nil;
            [scanner scanUpToString:@"&" intoString:&parameterValue];
            return parameterValue;
        }
    }
    
    return nil;
}

- (UIImage *)getImage {
    NSString *base64Image = [self getParameterNamed:@"base64"];
    if (base64Image) {
        NSData *imageData = [URLBase64 decode:base64Image];
        if (imageData) {
            return [UIImage imageWithData:imageData];
        }
    }
    
    return nil;
}

@end
