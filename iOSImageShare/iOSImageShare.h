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
+ (void)sendImage:(UIImage *)image withAssetURL:(NSURL *)assetURL withId:(id)identifier toSchema:(NSString*)schema withOperation:(NSString*)operation;

@end
