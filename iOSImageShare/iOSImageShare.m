//
//  iOSImageShare.m
//  iOSImageShare
//
//  Created by Gustavo Ambrozio on 9/5/11.
//

#import "iOSImageShare.h"
#import "URLBase64.h"

#define SCHEMAS_URL  @"https://github.com/gpambrozio/iOSImageShare/raw/master/iOSImageShare/CompatibleApps.txt"


@implementation iOSImageSharer

@synthesize name = _name;
@synthesize schema = _schema;
@synthesize availableDecoders = _availableDecoders;
@synthesize availabeOperations = _availabeOperations;

- (void) dealloc {
    [_name release];
    [_schema release];
    [_availableDecoders release];
    [_availabeOperations release];
    [super dealloc];
}

@end

@interface iOSImageShare (PrivateStuff)

- (void)updateAvailableSchemas;
- (NSArray *)availableSchemas;

@end

@implementation iOSImageShare

static iOSImageShare *_instance = nil;

+ (iOSImageShare*)instance {
    if (_instance)
        return _instance;
    
    @synchronized(self) {
        if (_instance == nil) {
            [[self alloc] init];
        }
    }
    
    return _instance;
}

+ (id)allocWithZone:(NSZone*)zone {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    NSAssert(NO, @ "[iOSImageShare alloc] explicitly called on singleton class.");
    return nil;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

- (void)release {
}

- (id)autorelease {
    return self;
}

+ (NSString *)encodeData:(NSData *)data {
    return [URLBase64 encode:data];
}

+ (NSString *)encodeImageAsPNG:(UIImage *)image {
    return [URLBase64 encode:UIImagePNGRepresentation(image)];
}

+ (NSString *)encodeImageAsJPG:(UIImage *)image quality:(CGFloat)quality {
    return [URLBase64 encode:UIImageJPEGRepresentation(image, quality)];
}

- (void)updateAvailableSchemas {
    
    if (_updateSchemaConnection) {
        [_updateSchemaConnection cancel];
        [_updateSchemaConnection release];
        _updateSchemaConnection = nil;
    }
    
    if (_updateSchemaData) {
        [_updateSchemaData release];
        _updateSchemaData = nil;
    }
    
    NSURL *url = [[NSURL alloc] initWithString:SCHEMAS_URL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10.0];

    _updateSchemaData = [[NSMutableData alloc] init];
    _updateSchemaConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_updateSchemaConnection start];

    [request release];
    [url release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_updateSchemaData appendData:data];
}

- (void)parseAvailableSchemaData:(NSData*)data {
    NSString *list = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [_availableSchemas release];
    _availableSchemas = [[NSMutableArray alloc] init];
    
    NSArray *lines = [list componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
    for (NSString *line in lines) {
        NSArray *components = [line componentsSeparatedByString:@"|"];
        if ([components count] == 4) {
            
            iOSImageSharer *sharer = [[iOSImageSharer alloc] init];
            sharer.name   = [components objectAtIndex:0];
            sharer.schema = [components objectAtIndex:1];
            sharer.availableDecoders  = [[components objectAtIndex:2] componentsSeparatedByString:@","];
            sharer.availabeOperations = [[components objectAtIndex:3] componentsSeparatedByString:@","];
            
            [_availableSchemas addObject:sharer];
            [sharer release];
        }
    }
    
    [list release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self parseAvailableSchemaData:_updateSchemaData];
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [cachePaths objectAtIndex:0];
    NSString *cacheFile = [cacheDirectory stringByAppendingPathComponent:@"CompatibleApps.txt"];

    [_updateSchemaData writeToFile:cacheFile atomically:YES];

    [_updateSchemaData release];
    _updateSchemaData = nil;

    [_updateSchemaConnection release];
    _updateSchemaConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [cachePaths objectAtIndex:0];
    NSString *cacheFile = [cacheDirectory stringByAppendingPathComponent:@"CompatibleApps.txt"];

    // If there's no cache file, try to locate in main bundle.
    if (![[NSFileManager defaultManager] isReadableFileAtPath:cacheFile])
        cacheFile = [[NSBundle mainBundle] pathForResource:@"CompatibleApps" ofType:@"txt"];

    if (cacheFile) {
        NSData *cachedData = [NSData dataWithContentsOfFile:cacheFile];
        [self parseAvailableSchemaData:cachedData];
    }
    
    [_updateSchemaData release];
    _updateSchemaData = nil;
    
    [_updateSchemaConnection release];
    _updateSchemaConnection = nil;
}

+ (void)updateAvailableSchemas {
    [[iOSImageShare instance] updateAvailableSchemas];
}

- (NSArray *)availableSchemas {
    return _availableSchemas;
}

+ (NSArray *)availableSchemas {
    return [[iOSImageShare instance] availableSchemas];
}

@end
