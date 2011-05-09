//
//  iOSImageShare.h
//  iOSImageShare
//
//  Created by Gustavo Ambrozio on 9/5/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iOSImageSharer : NSObject {
@private
    NSString *_name;
    NSString *_schema;
    NSArray *_availableDecoders;
    NSArray *_availabeOperations;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* schema;
@property (nonatomic, retain) NSArray* availableDecoders;
@property (nonatomic, retain) NSArray* availabeOperations;

@end

@interface iOSImageShare : NSObject {
@private
    NSMutableArray *_availableSchemas;
    NSURLConnection *_updateSchemaConnection;
    NSMutableData *_updateSchemaData;
}

+ (NSString *)encodeData:(NSData *)data;
+ (NSString *)encodeImageAsPNG:(UIImage *)image;
+ (NSString *)encodeImageAsJPG:(UIImage *)image quality:(CGFloat)quality;
+ (void)updateAvailableSchemas;
+ (NSArray *)availableSchemas;

@end
