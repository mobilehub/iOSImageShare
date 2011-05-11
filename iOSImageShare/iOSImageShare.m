//
//  iOSImageShare.m
//  iOSImageShare
//
//  Created by Gustavo Ambrozio on 9/5/11.
//

#import "iOSImageShare.h"
#import "iOSImageSharer.h"
#import "URLBase64.h"
#import "iOSImageShareConstants.h"

@interface iOSImageShare ()

- (void)readAvailableSharersDataFromCache;
- (void)findMySchema;

@property (readonly) NSString *mySchema;

@end


@implementation iOSImageShare

@synthesize mySchema = _mySchema;

static iOSImageShare *_instance = nil;

+ (iOSImageShare*)instance {
    if (_instance)
        return _instance;
    
    @synchronized(self) {
        if (_instance == nil) {
            // The autorelease below is just to avoid an analyser warning.
            [[[self alloc] init] autorelease];
        }
    }
    
    return _instance;
}

+ (id)allocWithZone:(NSZone*)zone {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            [_instance readAvailableSharersDataFromCache];
            [_instance findMySchema];
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

- (void)findMySchema {
    [_mySchema release];
    _mySchema = nil;
    
    NSArray *urls = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    if ([urls count] > 0) {
        NSDictionary *url = [urls objectAtIndex:0];
        NSArray *schemes = [url objectForKey:@"CFBundleURLSchemes"];
        if ([schemes count] > 0) {
            _mySchema = [[schemes objectAtIndex:0] copy];
        }
    }
}

- (void)updateAvailableSharers {
    
    if (_updateSharersConnection) {
        [_updateSharersConnection cancel];
        [_updateSharersConnection release];
        _updateSharersConnection = nil;
    }
    
    if (_updateSharersData) {
        [_updateSharersData release];
        _updateSharersData = nil;
    }
    
    NSURL *url = [[NSURL alloc] initWithString:SCHEMAS_URL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10.0];

    _updateSharersData = [[NSMutableData alloc] init];
    _updateSharersConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_updateSharersConnection start];

    [request release];
    [url release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_updateSharersData appendData:data];
}

- (void)parseAvailableSchemaData:(NSData*)data {
    NSString *list = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSMutableArray *newSharerList = [[NSMutableArray alloc] init];
    
    NSArray *lines = [list componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
    for (NSString *line in lines) {
        NSArray *components = [line componentsSeparatedByString:@"|"];
        if ([components count] >= 5) {
            
            NSString *schema = [components objectAtIndex:1];
            if (![schema isEqualToString:self.mySchema] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[schema stringByAppendingString:@"://"]]]) {
                
                iOSImageSharer *sharer = [[iOSImageSharer alloc] init];
                sharer.name   = [components objectAtIndex:0];
                sharer.schema = schema;
                sharer.availableDecoders  = [[components objectAtIndex:2] componentsSeparatedByString:@","];
                sharer.availabeOperations = [[components objectAtIndex:3] componentsSeparatedByString:@","];
                sharer.iconLocation = [NSURL URLWithString:[components objectAtIndex:4]];
                [sharer updateSharerIcon];

                [newSharerList addObject:sharer];
                [sharer release];
            }
        }
    }
    
    [_availableSharers release];
    _availableSharers = newSharerList;
    
    [list release];
}

- (void)readAvailableSharersDataFromCache {
    
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
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self parseAvailableSchemaData:_updateSharersData];
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [cachePaths objectAtIndex:0];
    NSString *cacheFile = [cacheDirectory stringByAppendingPathComponent:@"CompatibleApps.txt"];

    [_updateSharersData writeToFile:cacheFile atomically:YES];

    [_updateSharersData release];
    _updateSharersData = nil;

    [_updateSharersConnection release];
    _updateSharersConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    [self readAvailableSharersDataFromCache];
    
    [_updateSharersData release];
    _updateSharersData = nil;
    
    [_updateSharersConnection release];
    _updateSharersConnection = nil;
}

+ (void)updateAvailableSharers {
    [[iOSImageShare instance] updateAvailableSharers];
}

- (NSArray *)availableSharers {
    return _availableSharers;
}

+ (NSArray *)availableSharers {
    return [[iOSImageShare instance] availableSharers];
}

+ (void)sendImageUsingJPEG:(UIImage *)image quality:(CGFloat)quality withId:(id)identifier toSchema:(NSString*)schema withOperation:(NSString*)operation {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:
      [NSString stringWithFormat:@"%@://%@?id=%@&returnTo=%@base64=%@", 
       schema, operation, identifier, [[iOSImageShare instance] mySchema], [iOSImageShare encodeImageAsJPG:image quality:quality]]]];
}

+ (void)sendImageUsingPNG:(UIImage *)image withId:(id)identifier toSchema:(NSString*)schema withOperation:(NSString*)operation {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:
      [NSString stringWithFormat:@"%@://%@?id=%@&returnTo=%@base64=%@", 
       schema, operation, identifier, [[iOSImageShare instance] mySchema], [iOSImageShare encodeImageAsPNG:image]]]];
}

@end
