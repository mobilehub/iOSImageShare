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
