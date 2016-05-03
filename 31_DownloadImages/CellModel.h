//
//  ImagesCollectionViewController.m
//  31_DownloadImages
//
//  Created by oreko on 28.04.16.
//  Copyright © 2016 Orest Kashchiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CellModel : NSObject

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) float progress;
@property (assign, nonatomic) BOOL buttonSelected;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSData *resumeData;

- (instancetype)initWithUrl:(NSURL *)url;

+ (instancetype)cellModelWithUrl:(NSURL *)url;

@end
