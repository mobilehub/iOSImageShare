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
