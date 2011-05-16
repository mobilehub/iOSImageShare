/*
 Copyright (C) 2011 by Gustavo Pelosi Ambrozio
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

//
//  NSURL+iOSImageShare.m
//  iOSImageShare
//
//  Created by Gustavo Ambrozio on 8/5/11.
//

#import "NSURL+iOSImageShare.h"
#import "URLBase64.h"

/* Add this before each category implementation, so we don't have to use -all_load or -force_load
 * to load object files from static libraries that only contain categories and no classes.
 *
 * See http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html for more info.
 */

@interface FIX_CATEGORY_BUG_NSURL @end
@implementation FIX_CATEGORY_BUG_NSURL @end

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
