//
//  NSURL+iOSImageShare.h
//  iOSImageShare
//
//  Created by Gustavo Ambrozio on 8/5/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSURL (NSURL_iOSImageShare)

- (NSString *)getParameterNamed:(NSString *)parameterName;
- (UIImage *)getImage;

@end
