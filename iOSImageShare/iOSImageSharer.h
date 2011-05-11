//
//  iOSImageSharer.h
//  iOSImageShare
//
//  Created by Gustavo Ambrozio on 11/5/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iOSImageSharer : NSObject {
@private
    NSString *_name;
    NSString *_schema;
    NSArray *_availableDecoders;
    NSArray *_availabeOperations;
    NSURL *_iconLocation;
    UIImage *_icon;
    
    NSURLConnection *_updateIconConnection;
    NSMutableData *_iconData;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* schema;
@property (nonatomic, retain) NSArray* availableDecoders;
@property (nonatomic, retain) NSArray* availabeOperations;
@property (nonatomic, retain) NSURL *iconLocation;
@property (nonatomic, retain) UIImage *icon;

- (void)updateSharerIcon;

@end
