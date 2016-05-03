//
//  ImagesCollectionViewController.m
//  31_DownloadImages
//
//  Created by oreko on 28.04.16.
//  Copyright © 2016 Orest Kashchiy. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

- (instancetype)initWithUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
        self.progress = 0.0f;
        self.buttonSelected = NO;
    }
    return self;
}

+ (instancetype)cellModelWithUrl:(NSURL *)url {
    CellModel *cellModel = [[CellModel alloc] initWithUrl:url];
    return cellModel;
}

@end
