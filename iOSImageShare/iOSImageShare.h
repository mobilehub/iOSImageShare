//
//  iOSImageShare.h
//  iOSImageShare
//
//  Created by Gustavo Ambrozio on 9/5/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iOSImageShare : NSObject {
@private
    NSMutableArray *_availableSharers;
    NSString *_mySchema;
    NSURLConnection *_updateSharersConnection;
    NSMutableData *_updateSharersData;
}

+ (NSString *)encodeData:(NSData *)data;
+ (NSString *)encodeImageAsPNG:(UIImage *)image;
+ (NSString *)encodeImageAsJPG:(UIImage *)image quality:(CGFloat)quality;
+ (void)updateAvailableSharers;
+ (NSArray *)availableSharers;

+ (void)sendImageUsingJPEG:(UIImage *)image quality:(CGFloat)quality withId:(id)identifier toSchema:(NSString*)schema withOperation:(NSString*)operation;
+ (void)sendImageUsingPNG:(UIImage *)image withId:(id)identifier toSchema:(NSString*)schema withOperation:(NSString*)operation;

@end
