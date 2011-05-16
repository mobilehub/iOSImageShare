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
//  iOSImageSharer.m
//  iOSImageShare
//
//  Created by Gustavo Ambrozio on 11/5/11.
//

#import "iOSImageSharer.h"
#import "iOSImageShareConstants.h"

@implementation iOSImageSharer

@synthesize name = _name;
@synthesize schema = _schema;
@synthesize availableDecoders = _availableDecoders;
@synthesize availabeOperations = _availabeOperations;
@synthesize iconLocation = _iconLocation;
@synthesize icon = _icon;

- (void) dealloc {
    [_name release];
    [_schema release];
    [_availableDecoders release];
    [_availabeOperations release];
    [_iconLocation release];
    [_icon release];
    
    [_updateIconConnection cancel];
    [_updateIconConnection release];
    
    [_iconData release];
    
    [super dealloc];
}

- (void) updateSharerIcon {
    
    [_icon release];
    _icon = nil;
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [cachePaths objectAtIndex:0];
    NSString *cacheFile = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"icon-%@.png", _schema]];
    
    if ([[NSFileManager defaultManager] isReadableFileAtPath:cacheFile]) {
        _icon = [[UIImage alloc] initWithContentsOfFile:cacheFile];
    } else {
        _icon = [[UIImage imageNamed:GENERIC_APP_ICON] retain];
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_iconLocation cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:20.0];
    
    _iconData = [[NSMutableData alloc] init];
    _updateIconConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_updateIconConnection start];
    
    [request release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_iconData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [cachePaths objectAtIndex:0];
    NSString *cacheFile = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"icon-%@.png", _schema]];
    
    [_iconData writeToFile:cacheFile atomically:YES];
    
    UIImage *newImage = [[UIImage alloc] initWithData:_iconData];
    if (newImage) {
        [_icon release];
        _icon = newImage;
    }
    
    [_iconData release];
    _iconData = nil;
    
    [_updateIconConnection release];
    _updateIconConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [_iconData release];
    _iconData = nil;
    
    [_updateIconConnection release];
    _updateIconConnection = nil;
}

@end
